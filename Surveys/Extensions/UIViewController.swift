//
//  UIViewController.swift
//  Surveys
//
//  Created by mkvault on 2/29/20.
//  Copyright © 2020 Hoa Nguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(error: Error) {
        showAlert(
            title: Constants.Strings.alertTitle,
            message: error.localizedDescription
        )
    }

    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.Strings.OK, style: .default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
