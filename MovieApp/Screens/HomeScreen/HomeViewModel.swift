//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import Foundation

protocol HomeViewModelInterface {
    func getAllSections()
    var onMoviesUpdated: (() -> Void)? { get set }
    func movies(for section: MovieSection) -> [Movie]
    func didSelectMovie(_ movie: Movie)
}


final class HomeViewModel: HomeViewModelInterface {

    private let apiService: TMDBApiServiceProtocol?
    private let router: AppRouterProtocol
    
    private var nowPlaying: [Movie] = []
    private var popular: [Movie] = []
    private var topRated: [Movie] = []
    private var upcoming: [Movie] = []
    
    var onMoviesUpdated: (() -> Void)?
    
    init(apiService: TMDBApiServiceProtocol?, router: AppRouterProtocol) {
        self.apiService = apiService
        self.router = router
    }
    
    func getAllSections() {
        let group = DispatchGroup()
        
        group.enter()
        apiService?.getNowPlaying(page: 1) { [weak self] result in
            if case .success(let dto) = result {
                self?.nowPlaying = dto.results?.map { $0.toMovie() } ?? []
            }
            if case .failure(let failure) = result {
                print(failure)
            }
            group.leave()
        }
        
        group.enter()
        apiService?.getPopularMovies(page: 1) { [weak self] result in
            if case .success(let dto) = result {
                self?.popular = dto.results?.map { $0.toMovie() } ?? []
            }
            group.leave()
        }

        group.enter()
        apiService?.getTopRated(page: 1) { [weak self] result in
            if case .success(let dto) = result {
                self?.topRated = dto.results?.map { $0.toMovie() } ?? []
            }
            group.leave()
        }

        group.enter()
        apiService?.getUpcoming(page: 1) { [weak self] result in
            if case .success(let dto) = result {
                self?.upcoming = dto.results?.map { $0.toMovie() } ?? []
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.onMoviesUpdated?()
        }
    }
    
    func movies(for section: MovieSection) -> [Movie] {
        switch section {
        case .nowPlaying: return nowPlaying
        case .popular: return popular
        case .topRated: return topRated
        case .upcoming: return upcoming
        }
    }
    
    func didSelectMovie(_ movie: Movie) {
        router.navigateToDetail(with: String(movie.id))
    }
}
