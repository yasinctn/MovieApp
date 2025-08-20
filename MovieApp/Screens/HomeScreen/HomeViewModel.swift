//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import Foundation
import PromiseKit

protocol HomeViewModelInterface {
    func getAllSections()
    var onMoviesUpdated: (() -> Void)? { get set }
    func movies(for section: MovieSectionType) -> [Movie]
    func didSelectMovie(_ movie: Movie)
    func didTapShowAll(for section: MovieSectionType)
    func getSectionsCount() -> Int
    func getSection(at index: Int) -> MovieSectionType
}
//

final class HomeViewModel: HomeViewModelInterface {
    
    func didTapShowAll(for section: MovieSectionType) {
        router.navigateToMore(with: section)
    }
    

    private let apiService: TMDBApiServiceProtocol
    private let router: AppRouterProtocol
    
    private var nowPlaying: [Movie] = []
    private var popular: [Movie] = []
    private var topRated: [Movie] = []
    private var upcoming: [Movie] = []
    
    var onMoviesUpdated: (() -> Void)?
    
    init(apiService: TMDBApiServiceProtocol, router: AppRouterProtocol) {
        self.apiService = apiService
        self.router = router
    }
    
    
    func getAllSections() {
        when(fulfilled:
            apiService.getNowPlaying(page: 1),
            apiService.getPopularMovies(page: 1),
            apiService.getTopRated(page: 1),
            apiService.getUpcoming(page: 1)
        )
        .done(on: .main) { [weak self] nowPlaying, popular, topRated, upcoming in
            self?.nowPlaying = nowPlaying
            self?.popular = popular
            self?.topRated = topRated
            self?.upcoming = upcoming
            self?.onMoviesUpdated?()
        }
        .catch { error in
            #if DEBUG
            print("Home sections error:", error)
            #endif
        }
    }
    
    func movies(for section: MovieSectionType) -> [Movie] {
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
    
    func getSectionsCount() -> Int {
        return MovieSectionType.allCases.count
    }
    
    func getSection(at index: Int) -> MovieSectionType {
        guard index < MovieSectionType.allCases.count else {
            return .popular // Default fallback
        }
        return MovieSectionType.allCases[index]
    }
}


