//
//  MoreMovieViewModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 8.08.2025.
//

import Foundation
import PromiseKit

protocol MoreMovieViewModelInterface {
    func getMovies()
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
    
    func getMovies() {
       
    }
    
    func didSelectMovie(at index: Int) {
        let selectedMovie = movies[index]
        router.navigateToDetail(with: String(selectedMovie.id))
    }
}
