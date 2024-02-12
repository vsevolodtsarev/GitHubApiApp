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
        actionButton.set(color: .systemGreen, title: LocalizedStrings.getFollowers, titleColor: .white)
    }
    
    override func didTapButton() {
        delegate?.didTapGetFollowers(for: user)
    }
}
