//
//  App.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import swiftra
import Kunugi
import MySQL

class Context: ContextBox {
    var context: [ContextType] = []
    var request: Request
    let pool: ConnectionPool
    init(request: Request, pool: ConnectionPool) {
        self.request = request
        self.pool = pool
        self.path = request.path
    }
    deinit {
        //print("context deinit")
    }
    
    var path: String
    var params: [String: String] = [:]
    var method: Kunugi.Method {
        return Kunugi.Method(rawValue: request.method) ?? Kunugi.Method.OPTIONS
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
    
    var dispatcher: (Request -> Response) {
        return { request in
            let handler = self.handler
            do {
                switch try handler.handleIfNeeded(try self.createContext(request)) {
                case .Next:
                    return Response(.NotFound)
                case .Respond(let res):
                    return res
                }
            } catch(let e) {
                self.catchError(e)
                return Response(.InternalServerError)
            }
        }
    }
}