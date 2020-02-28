//
//  UIImageView.swift
//  Surveys
//
//  Created by mkvault on 2/28/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func cancelDownload() {
        kf.cancelDownloadTask()
    }

    func setImage(with path: String) {
        kf.setImage(with: URL(string: path))
    }
}
