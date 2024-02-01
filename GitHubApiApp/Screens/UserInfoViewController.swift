//
//  UserInfoViewController.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 01.02.2024.
//

import UIKit

final class UserInfoViewController: UIViewController {
    
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
        print(username)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
}
