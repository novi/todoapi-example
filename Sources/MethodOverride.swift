//
//  MethodOverride.swift
//  todoapi
//
//  Created by ito on 1/14/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import Nest
import Foundation

struct MethodOverride: MiddlewareType, AnyRequestHandleable {
    let key: String
    init(_ headerKey: String = "X-HTTP-Method-Override") {
        self.key = headerKey
    }
    func handle(ctx: ContextBox) throws -> MiddlewareResult {
        let ctx = ctx as! Context
        if let val = ctx.request[key], let newMethod = Method(rawValue: val.uppercaseString) {
            ctx.method = newMethod
        }        
        return .Next
    }
}