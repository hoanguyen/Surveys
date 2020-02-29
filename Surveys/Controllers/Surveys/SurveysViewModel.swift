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
    private var surveys: [Survey] = []
    private let useCase: SurveyUseCase
    private var page: Int = 1
    private var isLoading: Bool = false
    private var shouldNotLoadMore = false
    weak var delegate: SurveysViewModelDelegate?

    enum Action {
        case didFetch
        case didLoadMore
        case didFail(Error)
        case showLoading(Bool)
    }

    private enum Configuration {
        static let perPage: Int = 10
    }

    init(useCase: SurveyUseCase) {
        self.useCase = useCase
    }
}

// MARK: - APIs
extension SurveysViewModel {
    func fetch(completion: (() -> Void)? = nil) {
        if isLoading { return }
        isLoading = true
        delegate?.viewModel(self, performAction: .showLoading(isLoading))
        useCase.get(page: 1, perPage: Configuration.perPage) { [weak self] result in
            guard let this = self else { return }
            this.isLoading = false
            this.delegate?.viewModel(this, performAction: .showLoading(this.isLoading))
            switch result {
            case .success(let data):
                this.surveys = data
                this.page = 1
                this.shouldNotLoadMore = false
                this.delegate?.viewModel(this, performAction: .didFetch)
            case .failure(let error):
                this.delegate?.viewModel(this, performAction: .didFail(error))
            }
            completion?()
        }
    }

    func loadMore(completion: (() -> Void)? = nil) {
        if isLoading { return }
        isLoading = true
        useCase.get(page: page + 1, perPage: Configuration.perPage) { [weak self] result in
            guard let this = self else { return }
            this.isLoading = false
            switch result {
            case .success(let data):
                if data.isEmpty {
                    this.shouldNotLoadMore = true
                } else {
                    this.surveys.append(contentsOf: data)
                    this.page += 1
                }
                this.delegate?.viewModel(this, performAction: .didLoadMore)
            case .failure(let error):
                this.delegate?.viewModel(this, performAction: .didFail(error))
            }
            completion?()
        }
    }
}

// MARK: - DataSource
extension SurveysViewModel {
    func numberOfItems(in section: Int = 0) -> Int {
        return surveys.count
    }

    func viewModelForItem(at index: Int) throws -> SurveyViewModel {
        guard surveys.indices.contains(index) else {
            throw Constants.Errors.indexOutOfRange
        }

        return SurveyViewModel(survey: surveys[index])
    }

    func shouldLoadMore(at indexPath: IndexPath) -> Bool {
        return indexPath.item == surveys.count - 4 && !shouldNotLoadMore
    }
}
