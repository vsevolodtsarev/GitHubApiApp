//
//  FavoritesViewController.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 29.01.2024.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    private let tableView = UITableView()
    private var favorites: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = LocalizedStrings.favorites
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.reuseID)
    }
    
    private func getFavorites() {
        
        Task {
            do {
                let favorites = try await PersistenceManagerAsyncAwait.shared.retrieveFavorites()
                if favorites.isEmpty {
                    showEmptyStateView(with: LocalizedStrings.noFavorites, in: view)
                } else {
                    self.favorites = favorites
                    tableView.reloadData()
                    view.bringSubviewToFront(tableView)
                }
            } catch {
                presentAlertViewControllerOnMainThread(alertTitle: LocalizedStrings.wrong,
                                                       alertMessage: error.localizedDescription,
                                                       buttonTitle: "Ok")
            }
        }
        //        PersistenceManager.retrieveFavorites { [weak self] result in
        //            guard let self else { return }
        //            switch result {
        //            case .success(let favorites):
        //                if favorites.isEmpty {
        //                    showEmptyStateView(with: LocalizedStrings.noFavorites, in: view)
        //                } else {
        //                    self.favorites = favorites
        //                    DispatchQueue.main.async {
        //                        self.tableView.reloadData()
        //                        self.view.bringSubviewToFront(self.tableView)
        //                    }
        //                }
        //
        //            case .failure(let error):
        //                presentAlertViewControllerOnMainThread(alertTitle: LocalizedStrings.wrong,
        //                                                       alertMessage: error.localizedDescription,
        //                                                       buttonTitle: "Ok")
        //            }
        //        }
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationViewController = FollowersListViewController(username: favorite.login)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let favorite = favorites[indexPath.row]
        
        Task {
            
            let error = try await PersistenceManagerAsyncAwait.shared.updateWith(favorite: favorite,
                                                                                 actionType: .remove)
            guard let error else {
                favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                
                if favorites.isEmpty {
                    showEmptyStateView(with: LocalizedStrings.noFavorites, in: view)
                }
                return
            }
            
            presentCustomAlertViewController(alertTitle: LocalizedStrings.noRemove,
                                             alertMessage: error.localizedDescription,
                                             buttonTitle: "Ok")
            
            
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.reuseID) as? FavoritesCell
        else {
            return UITableViewCell() }
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
}
