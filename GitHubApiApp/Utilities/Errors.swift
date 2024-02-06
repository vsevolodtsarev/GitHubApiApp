//
//  Errors.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 30.01.2024.
//

import Foundation

enum Errors: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server is invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again"
    case alreadyFavorites = "You've already favorited this user."
}
