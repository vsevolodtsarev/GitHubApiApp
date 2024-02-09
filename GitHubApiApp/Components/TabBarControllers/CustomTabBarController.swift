//
//  CustomTabBarController.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 07.02.2024.
//

import UIKit

final class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .dynamicButtonColor
        viewControllers = [createSearchNavigationController(), createFavoritesNavigationController()]
    }
    
    private func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.title = LocalizedStrings.searchTab
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchViewController)
    }
    
    private func createFavoritesNavigationController() -> UINavigationController {
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.title = LocalizedStrings.favoritesTab
        favoritesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favoritesViewController)
    }
}
