//
//  Auth.swift
//  todoapi
//
//  Created by ito on 1/3/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import HTTP

struct UserAuthenticated: ContextType {
    let userType: String
}

struct AuthUser: MiddlewareType, AnyRequestHandleable {
    let authAs: String
    func handle(ctx: ContextBox) throws -> MiddlewareResult {
        print("auth check \(authAs)")
        if let xauth = ctx.request.headers["x-auth"] where xauth.hasPrefix(authAs) {
            try ctx.set(UserAuthenticated(userType: xauth))
            return .Next
        }
        return .Respond(Response(status: .Forbidden))
    }
    init(authAs: String) {
        self.authAs = authAs
    }
}