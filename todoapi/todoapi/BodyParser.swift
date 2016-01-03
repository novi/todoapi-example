//
//  BodyParser.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import Core


protocol JSONBodyContext {
    var body: JSON { get }
}

struct RequestBodyContext: JSONBodyContext, ContextType {
    let body: JSON
}

struct BodyParser: MiddlewareType, AnyRequestHandlable {
    func handle(ctx: ContextBox) throws -> MiddlewareResult {
        let body = try? JSONParser.parse(ctx.request.body)
        try ctx.set(RequestBodyContext(body: body ?? JSON.from([:])))
        return .Next
    }
}