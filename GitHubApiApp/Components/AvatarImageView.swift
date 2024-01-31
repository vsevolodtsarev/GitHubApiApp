//
//  AvatarImageView.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 30.01.2024.
//

import UIKit

final class AvatarImageView: UIImageView {
    
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
    
    func setAvatarImage(from url: URL) {
        NetworkManager.shared.downloadAvatarImage(from: url) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.image = image
            case .failure(let error):
                assertionFailure("\(error)")
            }
        }
    }
}
