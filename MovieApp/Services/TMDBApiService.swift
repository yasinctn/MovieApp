//
//  TMDBApiService.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

protocol TMDBApiServiceProtocol {
    func getPopularMovies(page: Int, completion: @escaping (Result<MovieResponseDTO, Error>) -> Void)
    func getMovieDetail(id: String, completion: @escaping (Result<MovieDetailDTO, Error>) -> Void)
}

final class TMDBApiService: TMDBApiServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getPopularMovies(page: Int, completion: @escaping (Result<MovieResponseDTO, Error>) -> Void) {
        networkClient.request(endpoint: .getPopularMovies(page: page), completion: completion)
    }
    
    func getMovieDetail(id: String, completion: @escaping (Result<MovieDetailDTO, Error>) -> Void) {
        networkClient.request(endpoint: .getMovieDetail(id: id), completion: completion)
    }
}
