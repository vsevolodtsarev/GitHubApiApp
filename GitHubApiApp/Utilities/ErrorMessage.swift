//
//  ErrorMessage.swift
//  GitHubApiApp
//
//  Created by Всеволод Царев on 30.01.2024.
//

import Foundation

enum NetworkError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server is invalid. Please try again."
}
