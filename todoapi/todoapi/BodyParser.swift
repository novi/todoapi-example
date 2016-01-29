//
//  BodyParser.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import JSON

struct RequestBodyContext: ContextType {
    let body: JSON
}

struct BodyParser: MiddlewareType, AnyRequestHandleable {
    let empty: JSON = JSON.from([:])
    
    func handle(ctx: ContextBox) throws -> MiddlewareResult {
        let ctx = ctx as! Context
        let parsed: JSON
        if let bodyStr = ctx.request.body where bodyStr.characters.count > 0 {
            parsed = (try? JSONParser.parse(bodyStr)) ?? empty
        } else {
            parsed = empty
        }
        try ctx.put(RequestBodyContext(body: parsed))
        return .Next
    }
}

extension Context {
    var body: JSON {
        do {
            return (try self.get() as RequestBodyContext).body
        } catch {
            fatalError("the context requires body parser")
        }
    }
}