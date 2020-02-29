//
//  Token.swift
//  Surveys
//
//  Created by mkvault on 2/28/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Foundation
import KeychainAccess

struct Token: Codable {
    var accessToken: String
    var tokenType: String

    var bearerToken: String {
        return "\(tokenType) \(accessToken)"
    }

    static var current: Token? {
        set {
            let keychain = Keychain(service: Constants.Strings.bundleId)
            let encoder = JSONEncoder()
            guard let value = newValue, let encoded = try? encoder.encode(value) else { return }
            try? keychain.set(encoded, key: Token.Keys.token.rawValue)
        }
        get {
            let keychain = Keychain(service: Constants.Strings.bundleId)
            let decoder = JSONDecoder()
            guard let data = try? keychain.getData(Token.Keys.token.rawValue),
                let value = try? decoder.decode(Token.self, from: data) else { return nil }
            return value
        }
    }
}

// MARK: - Define
extension Token {
    private enum Keys: String {
        case token = "current_token"
    }
}
