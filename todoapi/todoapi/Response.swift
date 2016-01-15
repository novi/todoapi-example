//
//  Response.swift
//  todoapi
//
//  Created by ito on 1/13/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Nest
import Inquiline

extension Response {
    init(status: Status, json: JSON, headers: [(String, String)] = []) {
        self.init(status, headers: headers, contentType: "application/json", body: DefaultJSONSerializer().serialize(json))
    }
    
    init(status: Status, body: String, headers: [(String, String)] = []) {
        self.init(status, headers: headers, contentType: "text/plain", body: body)
    }
    
    init(_ body: String) {
        self.init(status: .Ok, body: body)
    }
}
