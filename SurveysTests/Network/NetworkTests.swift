//
//  NetworkTests.swift
//  SurveysTests
//
//  Created by mkvault on 3/1/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Quick
import Nimble
import Moya
@testable import Surveys

final class NetworkTests: QuickSpec {
    var provider: MoyaProvider<NimbleTarget>!

    override func spec() {
        super.spec()
        describe("Tests MoyaProvider with NimbleTarget") {
            self.failureContexts()
            self.sucessContexts()
        }
    }
}

// MARK: - Contexts
extension NetworkTests {
    func failureContexts() {
        context("When the request failed due to") {
            beforeEach {
                let endpoint = { (target: NimbleTarget) in
                    return Endpoint(
                        url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkError(Constants.Errors.mapping as NSError) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers
                    )
                }
                self.provider = MoyaProvider<NimbleTarget>(
                    endpointClosure: endpoint,
                    stubClosure: MoyaProvider.immediatelyStub
                )
            }

            it("failure get access token") {
                waitUntil(timeout: Configuration.timeout, action: { done in
                    self.provider.request(.oauth, completion: { result in
                        if case Result<Moya.Response, MoyaError>.failure(let error) = result {
                            expect(error).notTo(beNil())
                        }
                        done()
                    })
                })
            }

            it("failure get surveys") {
                waitUntil(timeout: Configuration.timeout, action: { done in
                    self.provider.request(.surveys(page: 0, perPage: 10), completion: { result in
                        if case Result<Moya.Response, MoyaError>.failure(let error) = result {
                            expect(error).notTo(beNil())
                        }
                        done()
                    })
                })
            }
        }
    }

    func sucessContexts() {
        context("When the request is success due to") {
            beforeEach {
                let configuration = URLSessionConfiguration.default
                configuration.headers = .default
                let session = Session(
                    configuration: configuration,
                    interceptor: AuthInterceptor()
                )
                let endpoint = { (target: NimbleTarget) in
                    return Endpoint(
                        url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers
                    )
                }
                self.provider = MoyaProvider<NimbleTarget>(
                    endpointClosure: endpoint,
                    stubClosure: MoyaProvider.immediatelyStub,
                    session: session
                )
            }

            it("has access token as expected") {
                waitUntil(timeout: Configuration.timeout, action: { done in
                    self.provider.request(.oauth, completion: { result in
                        if case Result<Moya.Response, MoyaError>.success(let value) = result {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let token = try? decoder.decode(Token.self, from: value.data)
                            expect(token).notTo(beNil())
                        }
                        done()
                    })
                })
            }

            it("has value for surveys as expected") {
                waitUntil(timeout: Configuration.timeout, action: { done in
                    self.provider.request(.surveys(page: 1, perPage: 10), completion: { result in
                        if case Result<Moya.Response, MoyaError>.success(let value) = result {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let surveys = try? decoder.decode([Survey].self, from: value.data)
                            expect(surveys).notTo(beNil())
                            expect(surveys?.count) == 10
                        }
                        done()
                    })
                })
            }
        }
    }
}

// MARK: - Configuration
extension NetworkTests {
    enum Configuration {
        static let timeout: TimeInterval = 5
    }
}

// MARK: - SampleData
extension NimbleTarget {
    var sampleData: Data {
        var resource = ""
        switch self {
        case .oauth: resource = "Token-Success"
        case .surveys: resource = "Surveys-Success"
        }

        guard let url = Bundle(for: NetworkTests.self).url(forResource: resource, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
    }
}
