//
//  SurveyAPI.swift
//  Surveys
//
//  Created by mkvault on 2/28/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Foundation
import Moya

final class SurveyAPI: SurveyUseCase {
    private let provider: MoyaProvider<NimbleTarget>

    init(provider: MoyaProvider<NimbleTarget>) {
        self.provider = provider
    }

    func get(page: Int, perPage: Int, completion: @escaping (Result<[Survey], Error>) -> Void) {
        provider.request(.surveys(page: page, perPage: perPage)) { result in
            switch result {
            case .success(let value):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let surveys: [Survey] = try? decoder.decode([Survey].self, from: value.data) else {
                    completion(.failure(Constants.Errors.mapping))
                    return
                }
                completion(.success(surveys))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
