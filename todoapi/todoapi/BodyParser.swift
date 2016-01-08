//
//  BodyParser.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi

struct RequestBodyContext: ContextType {
    let body: AnyObject
}

struct BodyParser: MiddlewareType, AnyRequestHandleable {
    func handle(ctx: ContextBox) throws -> MiddlewareResult {
        let data = NSData(bytes: ctx.request.body, length: ctx.request.body.count)
        let body = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
        try ctx.put(RequestBodyContext(body: body ?? [:]))
        return .Next
    }
}

extension Context {
    var body: AnyObject {
        do {
            return (try self.get() as RequestBodyContext).body
        } catch {
            fatalError("the context requires body parser")
        }
    }
}