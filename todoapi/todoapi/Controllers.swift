//
//  Controllers.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import swiftra
import MySQL

struct PrivateController: ControllerMiddleware, AnyRequestHandleable {
    let name: String
    func get(ctx: ContextBox) throws -> MiddlewareResult {
        return .Respond(Response("private get \(name) \(ctx.parameters)"))
    }    
    func post(ctx: ContextBox) throws -> MiddlewareResult {
        return .Respond(Response("private post \(name) \(ctx.parameters)"))
    }
}


struct UserController: ControllerMiddleware, AnyRequestHandleable {
    func get(ctx: ContextBox) throws -> MiddlewareResult {
        let user = try ctx.get() as UserAuthenticated
        return .Respond(Response("user is authenticated as \(user.userType)"))
    }
    
    func post(ctx: ContextBox) throws -> MiddlewareResult {
        let user = try ctx.get() as UserAuthenticated
        return .Respond(Response("user is authenticated as \(user.userType)"))
    }
}

struct SumController: ControllerMiddleware, AnyRequestHandleable {
    func post(ctx: ContextBox) throws -> MiddlewareResult {
        let ctx = ctx as! Context
        let body = ctx.body
        guard let a = body["a"]?.intValue, let b = body["b"]?.intValue else {
            return .Respond(Response(.BadRequest))
        }
        return .Respond(Response("\(a) + \(b) is \(a+b)"))
    }
    // calc using mysql
    func put(ctx: ContextBox) throws -> MiddlewareResult {
        let ctx = ctx as! Context
        let body = ctx.body
        guard let a = body["a"]?.intValue, let b = body["b"]?.intValue else {
            return .Respond(Response(.BadRequest))
        }
        let rows:[Row.MathResult] = try ctx.pool.execute{ conn in
            try conn.query("SELECT ? + ? as val;", [a, b])
        }
        let val = rows[0]
        return .Respond(Response("\(a) + \(b) is \(val.val)"))
    }
}