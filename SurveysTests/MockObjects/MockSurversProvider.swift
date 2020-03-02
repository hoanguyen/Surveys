//
//  MockSurversProvider.swift
//  SurveysTests
//
//  Created by mkvault on 3/2/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

@testable import Surveys

final class MockSurverysProvider {
    var shouldSuccess: Bool
    var emptyData: Bool

    init(shouldSuccess: Bool, emptyData: Bool) {
        self.shouldSuccess = shouldSuccess
        self.emptyData = emptyData
    }
}

// MARK: - SurveyUseCase
extension MockSurverysProvider: SurveyUseCase {
    func get(page: Int, perPage: Int, completion: @escaping (Result<[Survey], Swift.Error>) -> Void) {
        if shouldSuccess {
            let data = emptyData ? [] : Survey.surveys
            completion(.success(data))
        } else {
            completion(.failure(MockSurverysProvider.Error.fail))
        }
    }
}

// MARK: - MockSurverysProvider
extension MockSurverysProvider {
    enum Error: Swift.Error {
        case fail
    }
}
