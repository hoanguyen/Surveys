//
//  MockSurvey.swift
//  SurveysTests
//
//  Created by mkvault on 3/2/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

@testable import Surveys

extension Survey {
    static let dummy: Survey = {
        return Survey(
            id: "id",
            title: "title",
            description: "description",
            coverImageUrl: "coverImageURL"
        )
    }()

    static var surveys: [Survey] {
        return Array(repeating: dummy, count: 10)
    }
}
