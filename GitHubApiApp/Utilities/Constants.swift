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
    static let search = NSLocalizedString("search", comment: "search tab")
    static let favorites = NSLocalizedString("favorites", comment: "favorites tab")
    static let wrong = NSLocalizedString("wrong", comment: "Something went wrong")
    static let uncompleteRequest = NSLocalizedString("uncompleteRequest", comment: "Unable to complete request")
    static let enterUsername = NSLocalizedString("enterUsername", comment: "Enter a username")
    static let enterUsernameAlert = NSLocalizedString("enterUsernameAlert", comment: "Enter a username")
    static let noBio = NSLocalizedString("noBio", comment: "No bio")
    static let noLocation = NSLocalizedString("noLocation", comment: "No location")
    static let getFollowers = NSLocalizedString("getFollowers", comment: "Get Followers")
    static let profile = NSLocalizedString("profile", comment: "GitHub Profile")
    static let following = NSLocalizedString("following", comment: "Following")
    static let repos = NSLocalizedString("repos", comment: "Public Repo")
    static let gists = NSLocalizedString("gists", comment: "Public Gists")
    static let noFavorites = NSLocalizedString("noFavorites", comment: "No favorites, add plz")
    static let noRemove = NSLocalizedString("noRemove", comment: "Unable to remove")
    static let emptyUsername = NSLocalizedString("emptyUsername", comment: "Empty Username")
    static let noFollowers = NSLocalizedString("noFollowers", comment: "No Followers, follow him")
    static let noFollowersTitle = NSLocalizedString("noFollowersTitle", comment: "No Followers")
    static let gitHubSince = NSLocalizedString("gitHubSince", comment: "GitHub Since")
    static let success = NSLocalizedString("success", comment: "Success!")
    static let addFavorite = NSLocalizedString("addFavorite", comment: "addFavorite")
    static let searchUsername = NSLocalizedString("searchUsername", comment: "Search for a username")
    static let badStuff = NSLocalizedString("badStuff", comment: "bad stuff")
}
