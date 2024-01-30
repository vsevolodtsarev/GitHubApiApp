//
//  User.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 30.01.2024.
//

import Foundation

struct User: Decodable {
    let login: String
    let avatarUrl: URL
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: URL
    let following: Int
    let followers: Int
    let createdAt: Date
}
