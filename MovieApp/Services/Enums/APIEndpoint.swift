//
//  APIEndpoint.swift
//  MovieApp
//
//  Created by Yasin Çetin on 8.08.2025.
//

import Foundation
import Alamofire

enum APIEndpoint {
    
    case getPopularMovies(page: Int)
    case getMovieDetail(id: String)
    
    var bearerToken: String {
        return ConfigManager.shared.tmdbBearerToken
    }
    
    var baseURL: String {
        return ConfigManager.shared.tmdbBaseURL
    }
    
    var path: String {
        switch self {
        case .getPopularMovies:
            return "/discover/movie"
        case .getMovieDetail(let id):
            return "/movie/\(id)?language=en-US"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .getPopularMovies:
            return .get
        case .getMovieDetail:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(bearerToken)",
            "accept": "application/json"
        ]
    }
    
    var parameters: Parameters {
        switch self {
        case .getPopularMovies(let page):
            return [
                "include_adult": false,
                "include_video": false,
                "language": "en-US",
                "page": page,
                "sort_by": "popularity.desc"
            ]
        case .getMovieDetail:
            return [
                "language": "en-US"
            ]
        }
    }
    
    func asAFRequest() throws -> DataRequest {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        return AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        ).validate()
    }
}

typealias Parameters = [String: Any]
typealias Headers = [String : String]
