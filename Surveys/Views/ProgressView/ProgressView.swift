//
//  ProgressView.swift
//  Surveys
//
//  Created by mkvault on 2/29/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import UIKit

final class ProgressView: UIView {
    @IBOutlet private var contentView: UIView!
    private static var current: ProgressView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

// MARK: - Private funtions
private extension ProgressView {
    func commonInit() {
        Bundle.main.loadNibNamed("ProgressView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

// MARK: - Public funtions
extension ProgressView {
    static func show(on target: UIViewController) {
        if ProgressView.current != nil { return }
        ProgressView.current = ProgressView(frame: target.view.bounds)
        guard let progressView = ProgressView.current else { return }
        target.view.addSubview(progressView)
    }

    static func hide() {
        guard let progressView = ProgressView.current else { return }
        progressView.removeFromSuperview()
        ProgressView.current = nil
    }
}
