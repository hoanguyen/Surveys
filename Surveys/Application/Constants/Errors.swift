//
//  Errors.swift
//  Surveys
//
//  Created by mkvault on 2/28/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Foundation

extension Constants {
    enum Errors: Swift.Error {
        // MARK: - Indexing Error
        case indexOutOfRange
        case notFound

        // MARK: - Network Error
        case mapping
    }
}
