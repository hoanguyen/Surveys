//
//  SurveysViewController.swift
//  Surveys
//
//  Created by mkvault on 2/28/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import UIKit
import Moya

final class SurveysViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var surveyButton: UIButton!
    @IBOutlet private weak var pageControlCenterX: NSLayoutConstraint!
    private var viewModel: SurveysViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configurationLayout()
        configurationViewModel()
    }
}

// MARK: - Private functions
private extension SurveysViewController {
    func configurationLayout() {
        configurationCollectionView()
        configurationPageControl()
    }

    func configurationViewModel() {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        let session = Session(
            configuration: configuration,
            interceptor: AuthInterceptor()
        )
        let useCase = SurveyAPI(provider: MoyaProvider<NimbleTarget>(session: session))
        let viewModel = SurveysViewModel(useCase: useCase)
        viewModel.delegate = self
        viewModel.fetch()
        self.viewModel = viewModel
    }

    func configurationCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let navigationBarHeight = navigationController?.navigationBar.height ?? 0
        let cellHeight = UIScreen.mainHeight - Constants.Measure.statusBarHeight - navigationBarHeight
        layout.itemSize = CGSize(
            width: UIScreen.mainWidth,
            height: cellHeight
        )
        layout.minimumLineSpacing = .leastNonzeroMagnitude
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    func configurationPageControl() {
        pageControlCenterX.constant = (UIScreen.mainWidth - pageControl.height) / 2
        pageControl.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        pageControl.numberOfPages = 0
    }

    func updateUI() {
        collectionView.reloadData()
        pageControl.numberOfPages = viewModel.numberOfItems()
    }

    func refreshUI() {
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
        pageControl.numberOfPages = viewModel.numberOfItems()
        surveyButton.isHidden = viewModel.numberOfItems() == 0
    }
}

// MARK: - Actions
private extension SurveysViewController {
    @IBAction func didTapRefreshButton() {
        viewModel.fetch()
    }
}

// MARK: - SurveysViewModelDelegate
extension SurveysViewController: SurveysViewModelDelegate {
    func viewModel(_ viewModel: SurveysViewModel, performAction action: SurveysViewModel.Action) {
        switch action {
        case .didFetch: refreshUI()
        case .didLoadMore: updateUI()
        case .didFail(let error): showAlert(error: error)
        case .showLoading(let isLoading):
            if isLoading {
                ProgressView.show(on: self)
            } else {
                ProgressView.hide()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SurveysViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = try? viewModel.viewModelForItem(at: indexPath.item) else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(withClass: SurveyCell.self, for: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SurveysViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.height
        let index = Int((scrollView.contentOffset.y / offset).rounded())
        pageControl.currentPage = index
    }
}
