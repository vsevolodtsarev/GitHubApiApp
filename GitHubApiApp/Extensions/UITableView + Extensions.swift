//
//  UITableView + Extensions.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 10.02.2024.
//

import UIKit

extension UITableView {
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
