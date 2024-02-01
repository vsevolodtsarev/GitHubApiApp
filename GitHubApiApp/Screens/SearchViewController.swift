//
//  SearchViewController.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 29.01.2024.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    private let usernameTextField = CustomTextField()
    private let getFollowersButton = CustomButton(backgroundColor: .dynamicButtonColor,
                                                  title: "Get Followers",
                                                  titleColor: .dynamicButtonTextColor)
    private var isUsernameEntered: Bool {
        guard let textfield = usernameTextField.text else { return false }
        return !textfield.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureLogoImageView()
        configureUsernameTextField()
        configureGetFollowersButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func pushFollowersListViewController() {
        guard isUsernameEntered else {
            presentAlertViewControllerOnMainThread(
                alertTitle: "Empty Username",
                alertMessage: "Please enter a username. We need to know who to look for 😀.",
                buttonTitle: "Ok")
            return
        }
        guard let userName = usernameTextField.text else { return }
        let followersListViewController = FollowersListViewController(username: userName)
        followersListViewController.title = userName
        navigationController?.pushViewController(followersListViewController, animated: true)
    }
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = .gitHubLogo
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.widthAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    private func configureUsernameTextField() {
        view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureGetFollowersButton() {
        view.addSubview(getFollowersButton)
        getFollowersButton.addTarget(self, action: #selector(pushFollowersListViewController), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            getFollowersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            getFollowersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            getFollowersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            getFollowersButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersListViewController()
        return true
    }
}
