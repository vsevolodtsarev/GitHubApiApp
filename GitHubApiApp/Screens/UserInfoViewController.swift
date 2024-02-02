//
//  UserInfoViewController.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 01.02.2024.
//

import UIKit

final class UserInfoViewController: UIViewController {
    
    private let headerView = UIView()
    private let username: String
    
    init(username: String) {
        self.username = username
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        
        layoutUI()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                
                DispatchQueue.main.async {
                    let userInfoHeaderViewController = UserInfoHeaderViewController(user: user)
                    self.addChildViewController(add: userInfoHeaderViewController, to: self.headerView)
                }
 
            case .failure(let error):
                presentAlertViewControllerOnMainThread(alertTitle: "Something wrong", alertMessage: error.rawValue, buttonTitle: "Ok")
            }
        }
        
        
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    private func addChildViewController(add childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }
    
    private func layoutUI() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
}
