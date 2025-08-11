//
//  TMDBApiService.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//


import PromiseKit

protocol TMDBApiServiceProtocol {
    func getNowPlaying(page: Int) -> Promise<[Movie]>
    func getPopularMovies(page: Int) -> Promise<[Movie]>
    func getTopRated(page: Int) -> Promise<[Movie]>
    func getUpcoming(page: Int) -> Promise<[Movie]>
    func getMovieDetail(id: String) -> Promise<MovieDetail>
}

final class TMDBApiService: TMDBApiServiceProtocol {

    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func getNowPlaying(page: Int) -> Promise<[Movie]> {
        fetchMovies(endpoint: .getNowPlaying(page: page))
    }

    func getPopularMovies(page: Int) -> Promise<[Movie]> {
        fetchMovies(endpoint: .getPopularMovies(page: page))
    }

    func getTopRated(page: Int) -> Promise<[Movie]> {
        fetchMovies(endpoint: .getTopRated(page: page))
    }

    func getUpcoming(page: Int) -> Promise<[Movie]> {
        fetchMovies(endpoint: .getUpcoming(page: page))
    }

    func getMovieDetail(id: String) -> Promise<MovieDetail> {
        return networkClient.request(endpoint: .getMovieDetail(id: id))
            .map { (response: MovieDetailDTO) in
                response.toMovieDetail()
            }
    }
}
private extension TMDBApiService {
    private func fetchMovies(endpoint: APIEndpoint) -> Promise<[Movie]> {
            return networkClient.request(endpoint: endpoint)
                .map { (response: MovieResponseDTO) in
                    response.results?.map { $0.toMovie() } ?? []
                }
        }
}
