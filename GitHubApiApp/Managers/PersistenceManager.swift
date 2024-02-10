//
//  PersistenceManager.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 06.02.2024.
//

import Foundation

enum PersistenceActionType {
    case add
    case remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, 
                           actionType: PersistenceActionType,
                           completion: @escaping (Errors?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completion(.alreadyFavorites)
                        return
                    }
                    
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                
                completion(save(favorites: favorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func retrieveFavorites(completion: @escaping(Result<[Follower], Errors>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Follower]) -> Errors? {
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
