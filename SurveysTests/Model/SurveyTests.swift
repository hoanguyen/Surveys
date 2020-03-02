//
//  SurveyTests.swift
//  SurveysTests
//
//  Created by mkvault on 3/1/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Quick
import Nimble
@testable import Surveys

final class SurveyTests: QuickSpec {
    override func spec() {
        super.spec()
        describe("Test Survey Model") {
            context("When initializing with dummy data", closure: {
                var survey: Survey!
                beforeEach {
                    survey = Survey.dummy
                }
                it("has value for each properties as expected") {
                    expect(survey.id) == "id"
                    expect(survey.title) == "title"
                    expect(survey.description) == "description"
                    expect(survey.coverImageUrl) == "coverImageURL"
                }
            })

            context("When initializing with json data", closure: {
                var surveys: [Survey]?
                beforeEach {
                    guard let url = Bundle(for: NetworkTests.self).url(forResource: "Surveys-Success", withExtension: "json"),
                        let data = try? Data(contentsOf: url) else {
                            return
                    }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    surveys = try? decoder.decode([Survey].self, from: data)
                }
                it("has value for each properties as expected") {
                    expect(surveys).notTo(beNil())
                    expect(surveys?.first?.id) == "d5de6a8f8f5f1cfe51bc"
                    expect(surveys?.first?.title) == "Scarlett Bangkok"
                    expect(surveys?.first?.description) == "We'd love ot hear from you!"
                    expect(surveys?.first?.coverImageUrl) == "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_"
                }
            })
        }
    }
}
