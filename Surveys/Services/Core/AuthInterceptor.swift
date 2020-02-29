//
//  AuthInterceptor.swift
//  Surveys
//
//  Created by mkvault on 2/29/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Moya
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        if let token = Token.current?.bearerToken {
            var urlRequest = urlRequest
            urlRequest.update(token: token)
            completion(.success(urlRequest))
        } else {
            refreshToken { (result) in
                switch result {
                case .success(let token):
                    var urlRequest = urlRequest
                    urlRequest.update(token: token.bearerToken)
                    completion(.success(urlRequest))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let response = request.task?.response as? HTTPURLResponse {
            if response.isAuthExpired {
                refreshToken { (result) in
                    switch result {
                    case .success(let token):
                        if var request = request.task?.currentRequest {
                            request.update(token: token.bearerToken)
                        }
                        completion(.retry)
                    case .failure(let error):
                        completion(.doNotRetryWithError(error))
                    }
                }
            } else {
                completion(.doNotRetry)
            }
        }
    }

    private func refreshToken(completion: @escaping (Result<Token, MoyaError>) -> Void) {
        MoyaProvider<NimbleTarget>().request(.oauth) { result in
            switch result {
            case .success(let value):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let token = try? decoder.decode(Token.self, from: value.data) else {
                    completion(.failure(MoyaError.jsonMapping(value)))
                    return
                }

                Token.current = token
                completion(.success(token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension HTTPURLResponse {
    var isAuthExpired: Bool {
        return statusCode == 401
    }
}
