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
        Task {
            image = await NetworkManagerAsyncAwait.shared.downloadAvatarImage(from: url) ?? placeHolderImage
        }
    }
}
