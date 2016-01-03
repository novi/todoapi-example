//
//  Logger.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi

struct Logger: WrapMiddleware, AnyRequestHandlable {
    func handle(ctx: ContextBox, @noescape yieldNext: () throws -> Void) throws {
        let t1 = CFAbsoluteTimeGetCurrent()
        print("logger before \(ctx)")
        try yieldNext()
        let t2 = CFAbsoluteTimeGetCurrent()
        print("logger after \(ctx),\n\(ctx.request.method) \(ctx.request.uri.path ?? "") \(t2-t1)s")
    }
}