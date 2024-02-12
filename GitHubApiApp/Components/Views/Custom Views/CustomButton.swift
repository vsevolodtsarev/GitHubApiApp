//
//  CustomButton.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 29.01.2024.
//

import UIKit

final class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String, titleColor: UIColor) {
        self.init(frame: .zero)
        set(color: backgroundColor, title: title, titleColor: titleColor)
    }
    
    private func configure() {
        configuration = .filled()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(color: UIColor, title: String, titleColor: UIColor) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = titleColor
        configuration?.title = title
    }
}
