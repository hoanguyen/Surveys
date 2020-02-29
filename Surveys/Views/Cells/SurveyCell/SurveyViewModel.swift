//
//  SurveyViewModel.swift
//  Surveys
//
//  Created by mkvault on 2/28/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Foundation

struct SurveyViewModel {
    private let survey: Survey

    var title: String { return survey.title.trimmed }

    var description: String { return survey.description.trimmed }

    var imagePath: String { return survey.coverImageUrl + "l" }

    init(survey: Survey) {
        self.survey = survey
    }
}
