//
//  AvatarImageView.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 30.01.2024.
//

import UIKit

final class AvatarImageView: UIImageView {
    
    private let cache = NetworkManager.shared.cache
    private let placeHolderImage = UIImage(resource: .avatarPlaceholder)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from url: URL) {
        let cacheKey = NSString(string: "\(url)")
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            
            cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
