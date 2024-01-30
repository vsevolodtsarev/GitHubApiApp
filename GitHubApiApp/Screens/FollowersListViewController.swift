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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
