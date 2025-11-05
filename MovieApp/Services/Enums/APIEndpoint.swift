//
//  APIEndpoint.swift
//  MovieApp
//
//  Created by Yasin Çetin on 8.08.2025.
//

import Foundation
import Alamofire

enum APIEndpoint {
    
    case getNowPlaying(page: Int)
    case getPopularMovies(page: Int)
    case getTopRated(page: Int)
    case getUpcoming(page: Int)
    case getMovieDetail(id: String)
    
    typealias Parameters = [String: Any]
    typealias Headers = [String : String]

    private var bearerToken: String {
        ConfigManager.shared.tmdbBearerToken
    }
    
    private var baseURL: String {
        ConfigManager.shared.tmdbBaseURL
    }
    
    var path: String {
        switch self {
        case .getNowPlaying:
            return "/movie/now_playing"
        case .getPopularMovies:
            return "/movie/popular"
        case .getTopRated:
            return "/movie/top_rated"
        case .getUpcoming:
            return "/movie/upcoming"
        case .getMovieDetail(let id):
            return "/movie/\(id)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders {
        [
            "Authorization": "Bearer \(bearerToken)",
            "accept": "application/json"
        ]
    }
    
    var parameters: Parameters {
        switch self {
        case .getNowPlaying(let page),
             .getPopularMovies(let page),
             .getTopRated(let page),
             .getUpcoming(let page):
            return [
                "language": "en-US",
                "page": page
            ]
        case .getMovieDetail:
            return [
                "language": "en-US",
                "append_to_response": "credits"
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

