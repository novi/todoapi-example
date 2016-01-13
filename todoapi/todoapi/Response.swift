//
//  Response.swift
//  todoapi
//
//  Created by ito on 1/13/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import swiftra
import Core

extension Response {
    init(status: Status, headers: [String: String] = [:], json: JSON) {
        var headers = headers
        headers["Content-Type"] = "application/json"
        self.init(status: status, headers: headers, body: DefaultJSONSerializer().serialize(json))
    }
}
