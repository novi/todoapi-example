//
//  DBModel.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import MySQL

struct Row {
    
    struct MathResult: QueryRowResultType {
        let val: Int
        static func decodeRow(r: MySQL.QueryRowResult) throws -> MathResult {
            return try MathResult(
                val: r <| 0
            )
        }
    }
    
    
    struct Todo: QueryRowResultType, QueryParameterDictionaryType {
        let id: Int
        let title: String
        let done: Bool
        let updatedAt: SQLDate
        static func decodeRow(r: MySQL.QueryRowResult) throws -> Todo {
            return try Todo(
                id: r <| "id",
                title: r <| "title",
                done: r <| "done",
                updatedAt: r <| "updated_at"
            )
        }
        func queryParameter() throws -> QueryDictionary {
            return QueryDictionary([
                //"id": // auto increment
                "title": title,
                "done": done,
                "updated_at": updatedAt,
                ])
        }
        var json: JSON {
            return [
                "id": JSON.from(Double(id)),
                "title": JSON.from(title),
                "done": JSON.from(done),
                "timestamp": JSON.from(updatedAt.description)
            ]
        }
    }
    
}
