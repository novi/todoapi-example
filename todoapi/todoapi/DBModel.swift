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
            return try build(MathResult.init)(
                r <| 0
            )
        }
    }
}
