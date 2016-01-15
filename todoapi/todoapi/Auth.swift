//
//  Auth.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import Inquiline
import Nest

struct UserAuthenticated: ContextType {
    let userType: String
}


struct AuthUser: MiddlewareType, AnyRequestHandleable {
    let authAs: String
    func handle(ctx: ContextBox) throws -> MiddlewareResult {
        print("auth check \(authAs)")
        let ctx = ctx as! Context
        /*if let xauth = ctx.request.headers["x-auth"] where xauth.hasPrefix(authAs) {
            try ctx.put(UserAuthenticated(userType: xauth))
            return .Next
        }*/
        return .Respond(Response(.Forbidden))
    }
    init(authAs: String) {
        self.authAs = authAs
    }
}