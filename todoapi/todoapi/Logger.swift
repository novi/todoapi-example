//
//  Logger.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import Nest
import CoreFoundation

struct Logger: WrapMiddleware, AnyRequestHandleable {
    func handle(ctx: ContextBox, @noescape yieldNext: () throws -> MiddlewareResult) throws -> MiddlewareResult {
        let ctx = ctx as! Context
        let t1 = CFAbsoluteTimeGetCurrent()
        print("Logger before: \(ctx)")
        let res = try yieldNext()
        let t2 = CFAbsoluteTimeGetCurrent()
        print("Logger after: \(ctx),\n\(ctx.method) \(ctx.request.path ?? "")(\(ctx.path)) \(t2-t1)s")
        //print("Logger response: ", res) // has memory leak?
        return res
    }
}