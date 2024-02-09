//
//  Date + Extensions.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 05.02.2024.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = .current
        return dateFormatter.string(from: self)
    }
}
