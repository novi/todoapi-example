//
//  MethodOverride.swift
//  todoapi
//
//  Created by ito on 1/14/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import swiftra
import Foundation

struct MethodOverride: MiddlewareType, AnyRequestHandleable {
    let key: String
    init(_ headerKey: String = "X-HTTP-Method-Override") {
        self.key = headerKey
    }
    func handle(ctx: ContextBox) throws -> MiddlewareResult {
        let ctx = ctx as! Context
        if let override = ctx.request.headers[key], let newMethod = Method(rawValue: override.uppercaseString) {
            ctx.method = newMethod
        }
        return .Next
    }
}