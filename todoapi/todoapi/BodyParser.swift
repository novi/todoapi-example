//
//  BodyParser.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import Core


struct RequestBodyContext: ContextType {
    let body: JSON
}

struct BodyParser: MiddlewareType, AnyRequestHandleable {
    func handle(ctx: ContextBox) throws -> MiddlewareResult {
        let body = try? JSONParser.parse(ctx.request.body)
        try ctx.put(RequestBodyContext(body: body ?? JSON.from([:])))
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