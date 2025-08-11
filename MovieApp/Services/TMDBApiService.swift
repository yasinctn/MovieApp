//
//  TMDBApiService.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

protocol TMDBApiServiceProtocol {
    func getNowPlaying(page: Int, completion: @escaping (Result<MovieResponseDTO, Error>) -> Void)
    func getPopularMovies(page: Int, completion: @escaping (Result<MovieResponseDTO, Error>) -> Void)
    func getTopRated(page: Int, completion: @escaping (Result<MovieResponseDTO, Error>) -> Void)
    func getUpcoming(page: Int, completion: @escaping (Result<MovieResponseDTO, Error>) -> Void)
    func getMovieDetail(id: String, completion: @escaping (Result<MovieDetailDTO, Error>) -> Void)
}

final class TMDBApiService: TMDBApiServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    
    func getNowPlaying(page: Int, completion: @escaping (Result<MovieResponseDTO, any Error>) -> Void) {
        networkClient.request(endpoint: .getNowPlaying(page: page), completion: completion)
    }
    
    func getTopRated(page: Int, completion: @escaping (Result<MovieResponseDTO, any Error>) -> Void) {
        networkClient.request(endpoint: .getTopRated(page: page), completion: completion)
    }
    
    func getUpcoming(page: Int, completion: @escaping (Result<MovieResponseDTO, any Error>) -> Void) {
        networkClient.request(endpoint: .getUpcoming(page: page), completion: completion)
    }
    
    func getPopularMovies(page: Int, completion: @escaping (Result<MovieResponseDTO, Error>) -> Void) {
        networkClient.request(endpoint: .getPopularMovies(page: page), completion: completion)
    }
    
    func getMovieDetail(id: String, completion: @escaping (Result<MovieDetailDTO, Error>) -> Void) {
        networkClient.request(endpoint: .getMovieDetail(id: id), completion: completion)
    }
}
