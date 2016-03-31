//
//  Server.swift
//  todoapi
//
//  Created by Yusuke Ito on 1/15/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import http4swift
import Nest
import Inquiline

extension HTTPRequest {
    var bodyString: String {
        var buffer = body
        buffer.append(CChar(0))
        return String.fromCString(buffer) ?? "" // String(buffer) ?? ""
    }
}

extension Request {
    init(req: HTTPRequest) {
        var headers: [Nest.Header] = []
        for (v, k) in req.headers {
            headers.append((k, v))
        }
        self.init(method: req.method, path: req.path, headers: headers, body: req.bodyString)
    }
}


public func serve(port: UInt16, app: Application) {
    let addr = SocketAddress(port: port)
    guard let sock = Socket() else {
        return
    }
    guard let server = HTTPServer(socket: sock, addr: addr) else {
        return
    }
    
    server.serve { (request, writer) in
        let response = app(Request(req: request))
        
        let body = response.body?.bytes()
        let size = body?.filter({ c in return c != 0 }).count ?? 0
        try writer.write("HTTP/1.0 \(response.statusLine)\r\n")
        try writer.write("Content-Length: \(size)\r\n")
        for header in response.headers {
            try writer.write("\(header.0): \(header.1)\r\n")
        }
        try writer.write("\r\n")
        if let body = body {
            try writer.write(body)
        }
    }
}


//

extension String {
    
    func bytes() -> [Int8] {
        var buffer = [Int8]()
        withCString { raw in
            var bytes = raw
            while true {
                let byte = bytes.memory
                buffer.append(byte)
                if byte == 0 {
                    break
                }
                bytes = bytes.advancedBy(1)
            }
        }
        return buffer
    }
    
}