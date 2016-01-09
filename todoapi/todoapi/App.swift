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
    let pool: ConnectionPool
    init(request: Request, pool: ConnectionPool) {
        self.request = request
        self.pool = pool
    }
}

class App: AppType {
    
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
        return Context(request: request, pool: pool)
    }
    
    func catchError(e: ErrorType) {
        print("internal server error: \(e)")
    }
    
    func prepare() {
        do {
            try pool.createTodoTable()
        } catch { }
    }
}