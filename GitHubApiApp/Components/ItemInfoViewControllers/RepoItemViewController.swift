//
//  RepoItemViewController.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 05.02.2024.
//

import UIKit

final class RepoItemViewController: ItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemType: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: LocalizedStrings.profile, titleColor: .white)
    }
    
    override func didTapButton() {
        delegate?.didTapGitHubProfile(for: user)
    }
}
