//
//  Logger.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import CoreFoundation

struct Logger: WrapMiddleware, AnyRequestHandleable {
    func handle(ctx: ContextBox, @noescape yieldNext: () throws -> MiddlewareResult) throws -> MiddlewareResult {
        let t1 = CFAbsoluteTimeGetCurrent()
        print("Logger before: \(ctx)")
        let res = try yieldNext()
        let t2 = CFAbsoluteTimeGetCurrent()
        print("Logger after: \(ctx),\n\(ctx.request.method) \(ctx.request.uri.path ?? "") \(t2-t1)s")
        //print("Logger response: ", res) // has memory leak?
        return res
    }
}