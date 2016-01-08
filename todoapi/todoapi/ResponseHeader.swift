//
//  ResponseHeader.swift
//  todoapi
//
//  Created by Yusuke Ito on 1/8/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import HTTP

struct AdditionalResponseHeader: WrapMiddleware, AnyRequestHandleable {
    func handle(ctx: ContextBox, @noescape yieldNext: () throws -> MiddlewareResult) throws -> MiddlewareResult {
        print("AdditionalResponseHeader before")
        let res = try yieldNext()
        print("AdditionalResponseHeader after")
        //print("AdditionalResponseHeader response: ", res) // has memory leak?
        switch res {
        case .Respond(let res):
            var headers = res.headers
            headers["X-ADDITIONAL-RESPONSE-HEADER"] = "hey"
            let newRes = Response(statusCode: res.statusCode, reasonPhrase: res.reasonPhrase, majorVersion: res.majorVersion, minorVersion: res.minorVersion, headers: headers, body: res.body)
            return .Respond(newRes)
        default: break
        }
        return res
    }
}
