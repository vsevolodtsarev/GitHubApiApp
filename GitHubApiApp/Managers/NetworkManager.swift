//
//  NetworkManager.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 30.01.2024.
//

import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.github.com"
    private let task = URLSession.shared
    private let cache = NSCache<NSString, UIImage>()
    
    func getFollowers(for username: String,
                      page: Int,
                      completion: @escaping (Result<[Follower], Errors>) -> Void) {
        let endpoint = baseURL + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        task.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        .resume()
    }
    
    func getUserInfo(for username: String, 
                     completion: @escaping (Result<User, Errors>) -> Void) {
        let endpoint = baseURL + "/users/\(username)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        task.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        .resume()
    }
    
    func downloadAvatarImage(from url: URL, completion: @escaping (Result<UIImage, Errors>) -> Void) {
        let cacheKey = NSString(string: "\(url)")
        if let image = cache.object(forKey: cacheKey) {
            completion(.success(image))
            return
        }
        
        task.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            
            cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        .resume()
    }
}
