//
//  SurveyDetailViewController.swift
//  Surveys
//
//  Created by mkvault on 2/28/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import UIKit

final class SurveyDetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    var viewModel: SurveyViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataBinding()
    }
}

// MARK: - Private functions
private extension SurveyDetailViewController {
    func dataBinding() {
        guard let viewModel = viewModel else { return }
        title = viewModel.title
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        imageView.setImage(with: viewModel.imagePath)
    }
}
