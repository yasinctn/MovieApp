//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import Foundation

protocol HomeViewModelInterface {
    func getMovies()
    var movies: [Movie] { get }
    func didSelectMovie(at index: Int)
    var onMoviesUpdated: (() -> Void)? { get set }
}

final class HomeViewModel: HomeViewModelInterface {

    private let apiService: TMDBApiServiceProtocol?
    private let router: AppRouterProtocol
    
    var movies: [Movie] = [] {
        didSet {
            onMoviesUpdated?()
        }
    }
    
    var onMoviesUpdated: (() -> Void)?
    
    init(apiService: TMDBApiServiceProtocol?, router: AppRouterProtocol) {
        self.apiService = apiService
        self.router = router
    }
    
    func getMovies() {
        apiService?.getPopularMovies(page: 1) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                let domainMovies = response.results?.map { $0.toMovie() } ?? []
                DispatchQueue.main.async {
                    self.movies = domainMovies
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didSelectMovie(at index: Int) {
        let selectedMovie = movies[index]
        router.navigateToDetail(with: String(selectedMovie.id))
    }
}
