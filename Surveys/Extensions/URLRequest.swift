//
//  URLRequest.swift
//  Surveys
//
//  Created by mkvault on 2/29/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Foundation

extension URLRequest {
    mutating func update(token: String) {
        setValue(token, forHTTPHeaderField: "Authorization")
    }
}
