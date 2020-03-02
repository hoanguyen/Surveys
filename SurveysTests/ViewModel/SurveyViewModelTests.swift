//
//  SurveyViewModelTests.swift
//  SurveysTests
//
//  Created by mkvault on 3/2/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Quick
import Nimble
@testable import Surveys

final class SurveyItemViewModelTests: QuickSpec {
    override func spec() {
        super.spec()
        let survey = Survey.dummy
        var viewModel = SurveyViewModel(survey: survey)
        describe("A survey item view model") {
            context("when initializing with survey") {
                beforeEach {
                    viewModel = SurveyViewModel(survey: survey)
                }
                it("has value for each properties as expected") {
                    expect(viewModel.title) == "title"
                    expect(viewModel.description) == "description"
                    expect(viewModel.imagePath) == "coverImageURL" + "l"
                }
            }
        }
    }
}
