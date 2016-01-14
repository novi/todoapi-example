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

extension Kunugi.Method {
    init?(_ method: HTTP.Method) {
        switch method {
        case .GET:
            self = .GET
        case .POST:
            self = .POST
        case .DELETE:
            self = .DELETE
        case .PUT:
            self = .PUT
        case .HEAD:
            self = .HEAD
        case .OPTIONS:
            self = .OPTIONS
        default:
            return nil
        }
    }
}

class Context: ContextBox {
    var context: [ContextType] = []
    var request: Request
    
    var method: Kunugi.Method
    var path: String
    var parameters: [String: String] = [:]    
    
    let pool: ConnectionPool
    init(request: Request, method: Kunugi.Method, pool: ConnectionPool) {
        self.request = request
        self.pool = pool
        self.path = request.uri.path ?? ""
        self.method = method
    }
}

extension App {
    struct Responder: ResponderType {
        let respond: (request: Request) throws -> Response
        func respond(request: Request) throws -> Response {
            return try respond(request: request)
        }
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
    
    var responder: ResponderType {
        let handler = self.handler
        return Responder{ request in
            guard let method = Kunugi.Method(request.method) else {
                return Response(status: .MethodNotAllowed)
            }
            let context = Context(request: request, method: method, pool: self.pool)
            do {
                switch try handler.handleIfNeeded(context) {
                case .Next:
                    return Response(status: .NotFound)
                case .Respond(let res):
                    return res
                }
            } catch(let e) {
                self.catchError(e)
                throw e
            }
        }
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