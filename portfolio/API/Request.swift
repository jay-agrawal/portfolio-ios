//
//  Request.swift
//  upstox
//
//  Created by Jayesh Agrawal on 16/11/24.
//

import Foundation

struct Request<Value> {
    var method: APIMethod
    var path: String

    init(method: APIMethod = .get, path: String) {
        self.method = method
        self.path = path
    }
}
