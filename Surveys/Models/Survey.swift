//
//  Survey.swift
//  Surveys
//
//  Created by mkvault on 2/28/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Foundation

protocol SurveyUseCase {
    func get(page: Int, perPage: Int, completion: @escaping (Result<[Survey], Error>) -> Void)
}

final class Survey: Codable {
    let id: String
    let title: String
    let description: String
    let coverImageUrl: String

    init(id: String, title: String, description: String, coverImageUrl: String) {
        self.id = id
        self.title = title
        self.description = description
        self.coverImageUrl = coverImageUrl
    }
}
