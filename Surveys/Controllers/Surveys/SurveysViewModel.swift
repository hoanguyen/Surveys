//
//  SurveysViewModel.swift
//  Surveys
//
//  Created by mkvault on 2/28/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Foundation

protocol SurveysViewModelDelegate: class {
    func viewModel(_ viewModel: SurveysViewModel, performAction action: SurveysViewModel.Action)
}

final class SurveysViewModel {
    private var surveys: [Survey] = [
        Survey(id: "0", title: "0", description: "", coverImageUrl: ""),
        Survey(id: "1", title: "1", description: "", coverImageUrl: ""),
        Survey(id: "2", title: "2", description: "", coverImageUrl: ""),
        Survey(id: "3", title: "3", description: "", coverImageUrl: "")
    ]
    weak var delegate: SurveysViewModelDelegate?

    enum Action {
        case didFetch
        case didLoadMore
        case didFail(Error)
        case showLoading(Bool)
    }
}

// MARK: - DataSource
extension SurveysViewModel {
    func numberOfItems(in section: Int) -> Int {
        return surveys.count
    }

    func viewModelForItem(at index: Int) throws -> SurveyViewModel {
        guard surveys.indices.contains(index) else {
            throw Constants.Errors.indexOutOfRange
        }

        return SurveyViewModel(survey: surveys[index])
    }
}
