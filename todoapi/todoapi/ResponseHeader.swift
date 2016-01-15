//
//  ResponseHeader.swift
//  todoapi
//
//  Created by Yusuke Ito on 1/8/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Kunugi
import Inquiline


struct AdditionalResponseHeader: WrapMiddleware, AnyRequestHandleable {
    func handle(ctx: ContextBox, @noescape yieldNext: () throws -> MiddlewareResult) throws -> MiddlewareResult {
        print("AdditionalResponseHeader before")
        let res = try yieldNext()
        print("AdditionalResponseHeader after")
        //print("AdditionalResponseHeader response: ", res) // has memory leak?
        switch res {
        case .Respond(let res):
            var res = res as! Response
            res.headers.append( ("X-ADDITIONAL-RESPONSE-HEADER", "hey") )
            return .Respond(res)
        default: break
        }
        return res
    }
}
