//
//  Controllers.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import HTTP
import MySQL

struct PrivateController: ControllerMiddleware, AnyRequestHandleable {
    let name: String
    func get(ctx: ContextBox) throws -> MiddlewareResult {
        return .Respond(Response(status: .OK, body: "private get \(name) \(ctx.request.parameters)"))
    }    
    func post(ctx: ContextBox) throws -> MiddlewareResult {
        return .Respond(Response(status: .Created, body: "private post \(name) \(ctx.request.parameters)"))
    }
}


struct UserController: ControllerMiddleware, AnyRequestHandleable {
    func get(ctx: ContextBox) throws -> MiddlewareResult {
        let user = try ctx.get() as UserAuthenticated
        return .Respond(Response(status: .OK, body: "user is authenticated as \(user.userType)"))
    }
    
    func post(ctx: ContextBox) throws -> MiddlewareResult {
        let user = try ctx.get() as UserAuthenticated
        return .Respond(Response(status: .OK, body: "user is authenticated as \(user.userType)"))
    }
}

struct SumController: ControllerMiddleware, AnyRequestHandleable {
    func post(ctx: ContextBox) throws -> MiddlewareResult {
        let ctx = ctx as! Context
        guard let body = ctx.body as? NSDictionary, let a = body["a"] as? Int, let b = body["b"] as? Int else {
            return .Respond(Response(status: .BadRequest))
        }
        return .Respond(Response(status: .OK, body: "\(a) + \(b) is \(a+b)"))
    }
    // calc using mysql
    func put(ctx: ContextBox) throws -> MiddlewareResult {
        let ctx = ctx as! Context
        guard let body = ctx.body as? NSDictionary, let a = body["a"] as? Int, let b = body["b"] as? Int else {
            return .Respond(Response(status: .BadRequest))
        }
        let rows:[Row.MathResult] = try ctx.pool.execute{ conn in
            try conn.query("SELECT ? + ? as val;", [a, b])
        }
        let val = rows[0]
        return .Respond(Response(status: .OK, body: "\(a) + \(b) is \(val.val)"))
    }
}