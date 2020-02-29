//
//  Strings.swift
//  Surveys
//
//  Created by mkvault on 2/29/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Foundation

extension Constants {
    struct Strings {
        static let alertTitle = "Error!"
        static let OK = "OK"

        static var bundleId: String {
            return Bundle.main.bundleIdentifier ?? "com.dev.hoanguyen.Surveys"
        }
    }
}
