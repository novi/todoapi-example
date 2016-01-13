//
//  BodyParser.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import Foundation

#if os(Linux)
typealias AnyType = Any
#else
typealias AnyType = AnyObject
#endif

struct RequestBodyContext: ContextType {
    let body: [String:AnyType]
}

struct BodyParser: MiddlewareType, AnyRequestHandleable {
    let empty: [String:AnyType] = [:]
    
    func handle(ctx: ContextBox) throws -> MiddlewareResult {
        var body: [String:AnyType] = empty
        if ctx.request.body.count > 0 {
            let data = NSData(bytes: ctx.request.body, length: ctx.request.body.count)
            if let parsed = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
                if let parsed2 = parsed as? [String: AnyType] {
                    body = parsed2
                }
            }
        }
        try ctx.put(RequestBodyContext(body: body))
        return .Next
    }
}

extension Context {
    var body: [String:AnyType] {
        do {
            return (try self.get() as RequestBodyContext).body
        } catch {
            fatalError("the context requires body parser")
        }
    }
}