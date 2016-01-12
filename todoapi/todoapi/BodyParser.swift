//
//  BodyParser.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi

struct RequestBodyContext: ContextType {
    let body: [String:AnyObject]
}

struct BodyParser: MiddlewareType, AnyRequestHandleable {
    let empty: [String:AnyObject] = [:]
    
    func handle(ctx: ContextBox) throws -> MiddlewareResult {
        let parsed: AnyObject
        if ctx.request.body.count > 0 {
            let data = NSData(bytes: ctx.request.body, length: ctx.request.body.count)
            parsed = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) ?? empty
        } else {
            parsed = empty
        }
        try ctx.put(RequestBodyContext(body: (parsed as? [String:AnyObject]) ?? empty ))
        return .Next
    }
}

extension Context {
    var body: [String:AnyObject] {
        do {
            return (try self.get() as RequestBodyContext).body
        } catch {
            fatalError("the context requires body parser")
        }
    }
}