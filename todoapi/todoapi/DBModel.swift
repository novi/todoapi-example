//
//  DBModel.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import MySQL

extension ConnectionPool {
    func createTodoTable() throws {
        try execute { conn in
            try conn.query("CREATE TABLE `todos` ( " +
                "`id` int(11) NOT NULL AUTO_INCREMENT," +
                "`title` varchar(256) NOT NULL DEFAULT ''," +
                "`done` tinyint(1) NOT NULL DEFAULT '0'," +
                "`updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
                "PRIMARY KEY (`id`)," +
                "UNIQUE KEY `id` (`id`)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8;")
        }
    }
}

struct Row {
    struct Todo: QueryRowResultType, QueryParameterDictionaryType {
        let id: Int
        let title: String
        let done: Bool
        let updatedAt: SQLDate
        static func decodeRow(r: MySQL.QueryRowResult) throws -> Todo {
            return try build(Todo.init)(
                r <| "id",
                r <| "title",
                r <| "done",
                r <| "updated_at"
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
