//
//  Constants.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 09.02.2024.
//

import UIKit

enum Urls {
    static let gitHubBaseUrl = "https://api.github.com"
}

enum SFSymbolsImage {
    static let location = UIImage(systemName: "mappin.and.ellipse")
    static let repos = UIImage(systemName: "folder")
    static let gists = UIImage(systemName: "text.alignleft")
    static let followers = UIImage(systemName: "heart")
    static let following = UIImage(systemName: "person.2")
}

enum LocalizedStrings {
    static let searchTab = NSLocalizedString("searchTab", comment: "search tab")
    static let favoritesTab = NSLocalizedString("favoritesTab", comment: "favorites tab")
    static let wrong = NSLocalizedString("wrong", comment: "Something went wrong")
    static let uncompleteRequest = NSLocalizedString("uncompleteRequest", comment: "Unable to complete request")
    static let enterUsername = NSLocalizedString("enterUsername", comment: "Enter a username")
    static let noBio = NSLocalizedString("noBio", comment: "No bio")
    static let noLocation = NSLocalizedString("noLocation", comment: "No location")
    static let getFollowers = NSLocalizedString("getFollowers", comment: "Get Followers")
    static let profile = NSLocalizedString("profile", comment: "GitHub Profile")
    static let following = NSLocalizedString("following", comment: "Following")
    static let repos = NSLocalizedString("repos", comment: "Public Repo")
    static let gists = NSLocalizedString("gists", comment: "Public Gists")
}