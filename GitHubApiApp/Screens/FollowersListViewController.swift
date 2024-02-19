//
//  FollowersListViewController.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 29.01.2024.
//

import UIKit

protocol FollowerListViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

final class FollowersListViewController: UIViewController {
    
    private enum Section {
        case main
    }
    
    private var username: String
    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?
    private var followers: [Follower] = []
    private var filteredFollowers: [Follower] = []
    private var page: Int = 1
    private var hasMoreFollowers: Bool = true
    private var isSearching: Bool = false
    private var isLoadingMoreFollowers: Bool = false
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func addUserToFavorite(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        Task {
            let error = try await PersistenceManagerAsyncAwait.shared.updateWith(favorite: favorite,
                                                                                 actionType: .add)
            
            guard let error else {
                presentCustomAlertViewController(alertTitle: LocalizedStrings.success,
                                                 alertMessage: LocalizedStrings.addFavorite,
                                                 buttonTitle: "Ok")
                return
            }
            
            presentCustomAlertViewController(alertTitle: LocalizedStrings.wrong,
                                             alertMessage: error.localizedDescription,
                                             buttonTitle: "Ok")
        }
    }
    
    @objc private func didTapAddButton() {
        showLoadingView()
        
        Task {
            do {
                let user = try await NetworkManagerAsyncAwait.shared.getUserInfo(for: username)
                addUserToFavorite(user: user)
                
            } catch {
                if let error = error as? Errors {
                    presentCustomAlertViewController(alertTitle: LocalizedStrings.wrong,
                                                     alertMessage: error.localizedDescription,
                                                     buttonTitle: "Ok")
                }
            }
        }
        dismissLoadingView()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        guard let collectionView else { return }
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    private func configureDataSource() {
        guard let collectionView else { return }
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, follower in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as? FollowerCell
                cell?.set(follower: follower)
                return cell
            })
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = LocalizedStrings.searchUsername
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        
        Task {
            do {
                let followers = try await NetworkManagerAsyncAwait.shared.getFollowers(for: username, page: page)
                if followers.count < 100 { hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                if followers.isEmpty {
                    let message = LocalizedStrings.noFollowers
                    showEmptyStateView(with: message, in: self.view)
                    dismissLoadingView()
                }
                updateData(on: followers)
                dismissLoadingView()
            } catch {
                if let error = error as? Errors {
                    presentCustomAlertViewController(alertTitle: LocalizedStrings.badStuff,
                                                     alertMessage: error.localizedDescription,
                                                     buttonTitle: "Ok")
                }
                dismissLoadingView()
            }
            isLoadingMoreFollowers = false
        }
    }
}

extension FollowersListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        let destinationViewController = UserInfoViewController(username: follower.login)
        destinationViewController.delegate = self
        let navigationViewController = UINavigationController(rootViewController: destinationViewController)
        present(navigationViewController, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
}

extension FollowersListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowersListViewController: FollowerListViewControllerDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
