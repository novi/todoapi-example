//
//  App.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import HTTP
import Kunugi
import MySQL

class Context: ContextBox {
    var context: [ContextType] = []
    var request: Request
    init(_ request: Request) {
        self.request = request
    }
}

struct DBContext: ContextType {
    let pool: ConnectionPool
}

class App: AppType {
    typealias C = Context
    let pool = ConnectionPool(options: DBOptions())
    
    var wrap: [WrapMiddleware] = []
    var middleware: [MiddlewareType] = []
    
    func use(m: WrapMiddleware) {
        wrap.append(m)
    }
    
    func use(m: MiddlewareType) {
        middleware.append(m)
    }
    func createContext(request: Request) throws -> ContextBox {
        let ctx = Context(request)
        try ctx.set(DBContext(pool: pool))
        return ctx
    }
    
    func catchError(e: ErrorType) {
        print("internal server error: \(e)")
    }
}