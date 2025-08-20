//
//  MoreMovieViewModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 8.08.2025.
//

import Foundation
import PromiseKit

protocol MoreMovieViewModelInterface {
    func getMovies(for section: MovieSectionType)
    var movies: [Movie] { get }
    func didSelectMovie(at index: Int)
    var onMoviesUpdated: (() -> Void)? { get set }
}

final class MoreMovieViewModel: MoreMovieViewModelInterface {

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
    
    func getMovies(for section: MovieSectionType) {
        
        switch section {
            
        case .popular:
            apiService?.getPopularMovies(page: 1).done(on: .main) { [weak self] movies in
                self?.movies = movies
            }.catch { error in
                self.handleError(error: error)
            }
        case .upcoming:
            apiService?.getUpcoming(page: 1).done(on: .main) { [weak self] movies in
                self?.movies = movies
            }.catch { error in
                self.handleError(error: error)
            }
        case .nowPlaying:
            apiService?.getNowPlaying(page: 1).done(on: .main) { [weak self] movies in
                self?.movies = movies
            }.catch { error in
                self.handleError(error: error)
            }
        case .topRated:
            apiService?.getTopRated(page: 1).done(on: .main) { [weak self] movies in
                self?.movies = movies
            }.catch { error in
                self.handleError(error: error)
            }
        }
    }
    
    func didSelectMovie(at index: Int) {
        let selectedMovie = movies[index]
        router.navigateToDetail(with: String(selectedMovie.id))
    }
    
    func handleError(error: Error) {
        print("Home sections error:", error)
    }
}
