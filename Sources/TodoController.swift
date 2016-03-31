//
//  TodoController.swift
//  todoapi
//
//  Created by Yusuke Ito on 1/12/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import Nest
import Inquiline
import MySQL
import JSON

struct RequestParameterId: ContextType {
    let id: Int
}

struct TodoController: ControllerMiddleware, AnyRequestHandleable {
    func before(ctx: ContextBox) throws -> MiddlewareResult {
        let ctx = ctx as! Context
        guard let id = Int(ctx.parameters["id"] ?? "") else {
            return .Respond( Response(.BadRequest) )
        }
        try ctx.put(RequestParameterId(id: id))
        return .Next
    }
    func get(ctx: ContextBox) throws -> MiddlewareResult {
        let id = (try ctx.get() as RequestParameterId).id
        let ctx = ctx as! Context
        let todos: [Row.Todo] = try ctx.pool.execute{ conn in
            try conn.query("SELECT * FROM todos WHERE id = ?", [id])
        }
        if let first = todos.first {
            return .Respond( Response(status: .Ok, json: first.json) )
        } else {
            return .Respond( Response(.NotFound))
        }
    }
    func delete(ctx: ContextBox) throws -> MiddlewareResult {
        let id = (try ctx.get() as RequestParameterId).id
        let ctx = ctx as! Context
        let status: QueryStatus = try ctx.pool.execute { conn in
            try conn.query("DELETE FROM todos WHERE id = ? LIMIT 1", [id])
        }
        if status.affectedRows == 0 {
            return .Respond( Response(.NotFound))
        } else {
            return .Respond( Response(.Ok))
        }
    }
    func put(ctx: ContextBox) throws -> MiddlewareResult {
        let id = (try ctx.get() as RequestParameterId).id
        let ctx = ctx as! Context
        let body = ctx.body
        
        var params: [String: QueryParameter?] = [:]
        if let title = body["title"]?.stringValue {
            params["title"] = title
        }
        if let done = body["done"]?.boolValue {
            params["done"] = done
        }
        
        if params.count == 0 {
            return .Respond( Response(.BadRequest) )
        }
        
        let _: QueryStatus = try ctx.pool.execute { conn in
            try conn.query("UPDATE todos SET ? WHERE id = ? LIMIT 1", [QueryDictionary(params), id])
        }
        return try get(ctx)
    }
}

struct TodoListController: ControllerMiddleware, AnyRequestHandleable {
    func get(ctx: ContextBox) throws -> MiddlewareResult {
        
        let ctx = ctx as! Context
        let limit: Int = Int(ctx.query["count"] ?? "") ?? 100
        let todos: [Row.Todo] = try ctx.pool.execute{ conn in
            try conn.query("SELECT * FROM todos ORDER BY updated_at DESC LIMIT ?", [limit])
        }
        
        let json: JSON = [
            "todos": JSON.from(todos.map({ $0.json }))
        ]
        return .Respond( Response(status: .Ok, json: json))
    }
    func post(ctx: ContextBox) throws -> MiddlewareResult {
        let ctx = ctx as! Context
        let body = ctx.body
        guard let title = body["title"]?.stringValue else {
            return .Respond(Response(.BadRequest))
        }
        let todo = Row.Todo(id: 0, title: title, done: false, updatedAt: SQLDate.now(timeZone: ctx.pool.options.timeZone))
        
        let status: QueryStatus = try ctx.pool.execute { conn in
            try conn.query("INSERT INTO todos SET ?", [todo])
        }
        let created = Row.Todo(id: status.insertedId, title: todo.title, done: todo.done, updatedAt: todo.updatedAt)
        return .Respond(Response(status: .Created, json: created.json))
    }
}