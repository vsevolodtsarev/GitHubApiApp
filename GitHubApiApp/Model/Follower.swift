//
//  Follower.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 30.01.2024.
//

import Foundation

struct Follower: Decodable {
    let login: String
    let avatarUrl: URL
}
