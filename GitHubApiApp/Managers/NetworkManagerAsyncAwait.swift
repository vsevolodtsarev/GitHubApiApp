//
//  NetworkManagerAsync:Await.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 11.02.2024.
//

import UIKit

final class NetworkManagerAsyncAwait {
    
    static let shared = NetworkManagerAsyncAwait()
    
    private let baseURL = Urls.gitHubBaseUrl
    private let task = URLSession.shared
    private let cache = NSCache<NSString, UIImage>()
    private let decoder = JSONDecoder()
    
    private init() {
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getFollowers(for username: String,
                      page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw Errors.invalidUsername
        }
        
        let (data, response) = try await task.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Errors.invalidResponse
        }
        
        do {
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw Errors.invalidData
        }
    }
    
    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + "/users/\(username)"
        
        guard let url = URL(string: endpoint) else {
            throw Errors.invalidUsername
        }
        
        let (data, response) = try await task.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Errors.invalidResponse
        }
        
        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw Errors.invalidData
        }
    }
    
    func downloadAvatarImage(from url: URL) async -> UIImage? {
        let cacheKey = NSString(string: "\(url)")
        if let image = cache.object(forKey: cacheKey) {
            return image
        }
        
        do {
            let (data, _) = try await task.data(from: url)
            
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            cache.setObject(image, forKey: cacheKey)
            return image
            
        } catch {
            return nil
        }
    }
}
