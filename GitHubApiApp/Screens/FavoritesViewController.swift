//
//  FavoritesViewController.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 29.01.2024.
//

import UIKit

final class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                print(favorites)
            case .failure(let error):
                print(error)
            }
        }
    }
}
