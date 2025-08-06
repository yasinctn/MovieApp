//
//  TMDBApiService.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import Alamofire

protocol TMDBApiServiceProtocol {
    func getPopularMovies(completion: @escaping (Result<MovieResponseDTO, Error>) -> Void)
}

final class TMDBApiService: TMDBApiServiceProtocol {
    
    private let baseURL = ConfigManager.shared.tmdbBaseURL
    private let bearerToken = ConfigManager.shared.tmdbBearerToken
    
    func getPopularMovies(completion: @escaping (Result<MovieResponseDTO, Error>) -> Void) {
        let endpoint = "/discover/movie"
        let url = baseURL + endpoint
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "accept": "application/json"
        ]
        
        let parameters: Parameters = [
            "include_adult": false,
            "include_video": false,
            "language": "en-US",
            "page": 1,
            "sort_by": "popularity.desc"
        ]
        
        AF.request(url, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: MovieResponseDTO.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    completion(.success(movieResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
}

