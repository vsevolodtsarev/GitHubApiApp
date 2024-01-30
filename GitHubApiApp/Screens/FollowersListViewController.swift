//
//  FollowersListViewController.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 29.01.2024.
//

import UIKit

final class FollowersListViewController: UIViewController {
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result  in
            
            guard let self else { return }
            
            switch result {
            case .success(let followers):
                print("followers count = \(followers.count)")
                print(followers)
                
            case .failure(let error):
                self.presentAlertViewControllerOnMainThread(alertTitle: "Bad Stuff Happened!",
                                                            alertMessage: error.rawValue,
                                                            buttonTitle: "Ok")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
