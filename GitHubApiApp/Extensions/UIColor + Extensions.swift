//
//  UIColor + Extensions.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 01.02.2024.
//

import UIKit

extension UIColor {
    static var dynamicButtonColor: UIColor  {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                 traits.userInterfaceStyle == .light ? .black : .white
            }
        }
    }
    
    static var dynamicButtonTextColor: UIColor  {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                 traits.userInterfaceStyle == .light ? .white : .black
            }
        }
    }
}
