//
//  UIViewController + Extensions.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 30.01.2024.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView?

extension UIViewController {
    
    func presentSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .dynamicButtonColor
        present(safariViewController, animated: true)
    }
    
    func presentAlertViewControllerOnMainThread(alertTitle: String,
                                                alertMessage: String,
                                                buttonTitle: String) {
        DispatchQueue.main.async {
            let alertViewController = CustomAlertViewController(alertTitle: alertTitle, 
                                                                alertMessage: alertMessage,
                                                                buttonTitle: buttonTitle)
            alertViewController.modalTransitionStyle = .crossDissolve
            alertViewController.modalPresentationStyle = .overFullScreen
            self.present(alertViewController, animated: true)
        }
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        guard let containerView else { return }
        
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView?.removeFromSuperview()
            containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = EmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
