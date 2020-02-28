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
        let viewModel = SurveysViewModel()
        viewModel.delegate = self
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
        pageControl.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        pageControl.numberOfPages = 0
    }
}

// MARK: - SurveysViewModelDelegate
extension SurveysViewController: SurveysViewModelDelegate {
    func viewModel(_ viewModel: SurveysViewModel, performAction action: SurveysViewModel.Action) {
        switch action {
        case .didFail(let error): print(error)
        case .didFetch: print("didFetch")
        case .didLoadMore: print("didLoadMore")
        case .showLoading(let isShowLoading): print("showLoading \(isShowLoading)")
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

}
