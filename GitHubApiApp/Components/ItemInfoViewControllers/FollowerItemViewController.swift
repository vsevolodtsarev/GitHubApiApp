//
//  FollowerItemViewController.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 05.02.2024.
//

import UIKit

final class FollowerItemViewController: ItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: LocalizedStrings.getFollowers)
    }
    
    override func didTapButton() {
        delegate?.didTapGetFollowers(for: user)
    }
}
