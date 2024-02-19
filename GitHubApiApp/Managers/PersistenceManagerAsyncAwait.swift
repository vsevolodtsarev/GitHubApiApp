//
//  PersistenceManagerAsyncAwait.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 19.02.2024.
//

import Foundation

final class PersistenceManagerAsyncAwait {
    
    enum PersistenceActionType {
        case add
        case remove
    }
    
    private enum Keys {
        static let favorites = "favorites"
    }
    
    static let shared = PersistenceManagerAsyncAwait()
    private let defaults = UserDefaults.standard
    
//    func updateWith(favorite: Follower,
//                           actionType: PersistenceActionType,
//                           completion: @escaping (Errors?) -> Void) {
//        retrieveFavorites { result in
//            switch result {
//            case .success(var favorites):
//                
//                switch actionType {
//                case .add:
//                    guard !favorites.contains(favorite) else {
//                        completion(.alreadyFavorites)
//                        return
//                    }
//                    
//                    favorites.append(favorite)
//                    
//                case .remove:
//                    favorites.removeAll { $0.login == favorite.login }
//                }
//                
//                completion(save(favorites: favorites))
//                
//            case .failure(let error):
//                completion(error)
//            }
//        }
//    }
    
    func updateWith(favorite: Follower,
                           actionType: PersistenceActionType) async throws -> Errors? {
        var retrievedFavorites = try await retrieveFavorites()
        
        switch actionType {
            
        case .add:
            guard !retrievedFavorites.contains(favorite) else {
                return Errors.alreadyFavorites
            }
            retrievedFavorites.append(favorite)
            
        case .remove:
            retrievedFavorites.removeAll { $0.login == favorite.login }
        }
        
        let saved = save(favorites: retrievedFavorites)
        
        return saved
    }
    
    
    func retrieveFavorites() async throws -> [Follower] {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            return favorites
        } catch {
            throw Errors.unableToFavorite
        }
    }
    
    private func save(favorites: [Follower]) -> Errors? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return Errors.alreadyFavorites
        }
    }
}
