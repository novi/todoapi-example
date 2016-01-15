//
//  App.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Nest
import Kunugi
import Inquiline
import MySQL
import URI

class Context: ContextBox {
    var context: [ContextType] = []
    var request: Request
    
    var method: Kunugi.Method
    var path: String
    var parameters: [String: String] = [:]    
    var query: [String: String]
    
    let pool: ConnectionPool
    
    init(request: RequestType, pool: ConnectionPool) {
        let uri = URI(string: request.path)
        self.request = Request(method: request.method, path: uri.path ?? "", headers: request.headers, body: request.body)
        self.pool = pool
        self.path = self.request.path
        self.query = uri.query
        self.method = Kunugi.Method(rawValue: request.method) ?? Kunugi.Method.OPTIONS
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
    
    func createContext(request: RequestType) throws -> ContextBox {
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
    
    var application: Application {
        let handler = self.handler
        return { request in
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