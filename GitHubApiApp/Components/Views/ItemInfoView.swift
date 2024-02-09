//
//  ItemInfoView.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 03.02.2024.
//

import UIKit

enum ItemInfoType {
    case repos
    case gists
    case followers
    case following
}

final class ItemInfoView: UIView {
    
    private let symbolImageView = UIImageView()
    private let titleLabel = CustomTitleLabel(textAlignment: .left, fontSize: 14)
    private let countLabel = CustomTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(symbolImageView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    func set(itemType: ItemInfoType, withCount: Int) {
        switch itemType {
        case .repos:
            symbolImageView.image = SFSymbolsImage.repos
            titleLabel.text = "Public Repos"
        case .gists:
            symbolImageView.image = SFSymbolsImage.gists
            titleLabel.text = "Public Gists"
        case .followers:
            symbolImageView.image = SFSymbolsImage.followers
            titleLabel.text = "Followers"
        case .following:
            symbolImageView.image = SFSymbolsImage.following
            titleLabel.text = "Following"
        }
        
        countLabel.text = "\(withCount)"
    }
}
