//
//  NimbleTarget.swift
//  Surveys
//
//  Created by mkvault on 2/28/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Foundation
import Moya

enum NimbleTarget {
    case oauth
    case surveys(page: Int, perPage: Int)
}

// MARK: - Define default data
extension NimbleTarget {
    enum Default {
        static let data: [String: String] = [
            ParamKey.grantType.rawValue: "password",
            ParamKey.username.rawValue: "carlos@nimbl3.com",
            ParamKey.password.rawValue: "antikera"
        ]
    }

    private enum ParamKey: String {
        case grantType = "grant_type"
        case username
        case password
        case page
        case perPage = "per_page"
    }
}

// MARK: - Define Nimble Target
extension NimbleTarget: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://nimble-survey-api.herokuapp.com") else {
            fatalError("Cannot initialize the base URL")
        }
        return url
    }

    var path: String {
        switch self {
        case .oauth: return "/oauth/token"
        case .surveys: return "/surveys.json"
        }
    }

    var method: Moya.Method {
        switch self {
        case .oauth: return .post
        default: return .get
        }
    }

    var task: Task {
        switch self {
        case .oauth:
            return .requestParameters(
                parameters: Default.data,
                encoding: URLEncoding.queryString
            )
        case .surveys(let page, let perPage):
            return .requestParameters(
                parameters: [
                    ParamKey.page.rawValue: page,
                    ParamKey.perPage.rawValue: perPage
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        return Data()
    }

    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}
