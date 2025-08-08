//
//  NetworkError.swift
//  MovieApp
//
//  Created by Yasin Çetin on 8.08.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int, message: String?)
    case requestCreationError(Error)
    case unkownError
}
