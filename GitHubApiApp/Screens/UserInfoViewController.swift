//
//  UserInfoViewController.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 01.02.2024.
//

import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

final class UserInfoViewController: UIViewController {
    
    private let headerView = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()
    private let dateLabel = CustomBodyLabel(textAlignment: .center)
    
    private let username: String
    
    weak var delegate: FollowerListViewControllerDelegate?
    
    init(username: String) {
        self.username = username
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    private func getUserInfo() {
        Task {
            do {
               let user = try await NetworkManagerAsyncAwait.shared.getUserInfo(for: username)
                configureUIElements(with: user)
            } catch {
                if let error = error as? Errors {
                    presentAlertViewControllerOnMainThread(alertTitle: LocalizedStrings.wrong,
                                                           alertMessage: error.localizedDescription,
                                                           buttonTitle: "Ok")
                }
            }
        }
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    private func configureUIElements(with user: User) {
        let userInfoHeaderViewController = UserInfoHeaderViewController(user: user)
        let repoItemViewController = RepoItemViewController(user: user)
        let followerItemViewController = FollowerItemViewController(user: user)
        
        repoItemViewController.delegate = self
        followerItemViewController.delegate = self
        
        addChildViewController(add: userInfoHeaderViewController, to: headerView)
        addChildViewController(add: repoItemViewController, to: itemViewOne)
        addChildViewController(add: followerItemViewController, to: itemViewTwo)
        dateLabel.text = "\(LocalizedStrings.gitHubSince) \(user.createdAt.convertToMonthYearFormat())"
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func addChildViewController(add childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }
    
    private func layoutUI() {
        view.addSubview(headerView)
        view.addSubview(itemViewOne)
        view.addSubview(itemViewTwo)
        view.addSubview(dateLabel)
        
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didTapGitHubProfile(for user: User) {
        presentSafariViewController(with: user.htmlUrl)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentAlertViewControllerOnMainThread(alertTitle: LocalizedStrings.noFollowersTitle,
                                                   alertMessage: LocalizedStrings.noFollowers,
                                                   buttonTitle: "Ok")
            return
        }
        delegate?.didRequestFollowers(for: user.login)
        dismissViewController()
    }
}
