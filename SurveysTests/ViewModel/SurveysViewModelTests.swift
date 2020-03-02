//
//  SurveysViewModelTests.swift
//  SurveysTests
//
//  Created by mkvault on 3/2/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import Quick
import Nimble
@testable import Surveys

final class SurveysViewModelTests: QuickSpec {
    override func spec() {
        super.spec()
        describe("Tests SurveysViewModel") {
            initContext()
            dataEmptyContext()
            fetchApiSuccessContext()
            fetchApiFailureContext()
            loadmoreApiSuccessContext()
            loadmoreApiFailureContext()
        }
    }
}

private extension SurveysViewModelTests {
    func initContext() {
        var provider: MockSurverysProvider!
        var viewModel: SurveysViewModel!
        context("When initializing with MockNetwork") {
            beforeEach {
                provider = MockSurverysProvider(shouldSuccess: false, emptyData: false)
                viewModel = SurveysViewModel(useCase: provider)
            }
            it("don't have surveys") {
                expect(viewModel.numberOfItems()) == 0
                expect {
                    try viewModel.viewModelForItem(at: 0)
                }.to(throwError(Constants.Errors.indexOutOfRange))
            }
        }
    }

    func dataEmptyContext() {
        var provider: MockSurverysProvider!
        var viewModel: SurveysViewModel!
        context("When the request is succeeded due to") {
            beforeEach {
                provider = MockSurverysProvider(shouldSuccess: true, emptyData: true)
                viewModel = SurveysViewModel(useCase: provider)
            }

            it("don't have any value in surveys array") {
                waitUntil(timeout: Configuration.timeout, action: { done in
                    viewModel.loadMore {
                        expect(viewModel.numberOfItems()) == 0
                        expect { try viewModel.viewModelForItem(at: 0) }
                            .to(throwError(Constants.Errors.indexOutOfRange))
                        done()
                    }
                })
            }
        }
    }

    func fetchApiSuccessContext() {
        var viewModel: SurveysViewModel!
        var provider: MockSurverysProvider!
        context("When the request is succeeded due to") {
            beforeEach {
                provider = MockSurverysProvider(shouldSuccess: true, emptyData: false)
                viewModel = SurveysViewModel(useCase: provider)
            }

            it("response has surveys data") {
                waitUntil(timeout: Configuration.timeout, action: { done in
                    viewModel.fetch {
                        expect(viewModel.numberOfItems()) == 10
                        expect {
                            try viewModel.viewModelForItem(at: 0)
                        }.notTo(throwError(Constants.Errors.indexOutOfRange))
                        done()
                    }
                })
            }
        }
    }

    func loadmoreApiSuccessContext() {
        var viewModel: SurveysViewModel!
        var provider: MockSurverysProvider!
        var latestNumberOfSurveys = 0
        context("When the request is succeeded due to") {
            beforeEach {
                provider = MockSurverysProvider(shouldSuccess: true, emptyData: false)
                viewModel = SurveysViewModel(useCase: provider)
                viewModel.fetch {
                    latestNumberOfSurveys = viewModel.numberOfItems()
                }
            }
            it("the condition to trigger load more event") {
                expect(viewModel.shouldLoadMore(at: Configuration.sixthIndexPath)) == true
            }
            it("load more response has surveys data") {
                waitUntil(timeout: Configuration.timeout, action: { done in
                    viewModel.loadMore {
                        expect(viewModel.numberOfItems()) > 10
                        expect(viewModel.numberOfItems()) > latestNumberOfSurveys
                        latestNumberOfSurveys = viewModel.numberOfItems()
                        done()
                    }
                })
            }
        }
    }

    func fetchApiFailureContext() {
        var viewModel: SurveysViewModel!
        var provider: MockSurverysProvider!
        context("When the request is failed due to") {
            beforeEach {
                provider = MockSurverysProvider(shouldSuccess: false, emptyData: true)
                viewModel = SurveysViewModel(useCase: provider)
            }

            it("api response has empty surveys data") {
                waitUntil(timeout: Configuration.timeout, action: { done in
                    viewModel.fetch {
                        expect(viewModel.numberOfItems()) == 0
                        expect {
                            try viewModel.viewModelForItem(at: 0)
                        }.to(throwError(Constants.Errors.indexOutOfRange))
                        done()
                    }
                })
            }
        }
    }

    func loadmoreApiFailureContext() {
        var viewModel: SurveysViewModel!
        var provider: MockSurverysProvider!
        var latestNumberOfSurveys = 0
        context("When load more event is failed due to") {
            beforeEach {
                provider = MockSurverysProvider(shouldSuccess: true, emptyData: false)
                viewModel = SurveysViewModel(useCase: provider)
                viewModel.fetch {
                    latestNumberOfSurveys = viewModel.numberOfItems()
                }
            }

            it("the condition load more trigger is failed") {
                expect(viewModel.shouldLoadMore(at: Configuration.fifthIndexPath)) == false
            }

            it("api response has empty surveys data") {
                provider.emptyData = true
                waitUntil(timeout: Configuration.timeout, action: { done in
                    viewModel.loadMore {
                        expect(viewModel.numberOfItems()) == latestNumberOfSurveys
                        done()
                    }
                })
            }
        }
    }
}

// MARK: - Configuration
extension SurveysViewModelTests {
    enum Configuration {
        static let timeout: TimeInterval = 5
        static let fifthIndexPath = IndexPath(item: 5, section: 0)
        static let sixthIndexPath = IndexPath(item: 6, section: 0)
    }
}
