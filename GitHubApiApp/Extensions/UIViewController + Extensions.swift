//
//  UIViewController + Extensions.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 30.01.2024.
//

import UIKit

extension UIViewController {
    func presentAlertViewControllerOnMainThread(alertTitle: String,
                                                alertMessage: String,
                                                buttonTitle: String) {
        DispatchQueue.main.async {
            let alertViewController = AlertViewController(alertTitle: alertTitle, alertMessage: alertMessage, buttonTitle: buttonTitle)
            alertViewController.modalTransitionStyle = .crossDissolve
            alertViewController.modalPresentationStyle = .overFullScreen
            self.present(alertViewController, animated: true)
        }
    }
}
