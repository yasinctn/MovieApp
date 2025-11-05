//
//  FavoritesViewModel.swift
//  MovieApp
//
//  Created by Claude Code
//

import Foundation

protocol FavoritesViewModelProtocol {
    var movies: [Movie] { get }
    var onMoviesUpdated: (() -> Void)? { get set }
    func loadFavorites()
    func didSelectMovie(_ movie: Movie)
}

final class FavoritesViewModel: FavoritesViewModelProtocol {

    // MARK: - Properties
    private let favoritesService: FavoritesServiceProtocol
    private let router: AppRouter

    var movies: [Movie] = []
    var onMoviesUpdated: (() -> Void)?

    // MARK: - Initialization
    init(favoritesService: FavoritesServiceProtocol = FavoritesService.shared,
         router: AppRouter) {
        self.favoritesService = favoritesService
        self.router = router
        setupNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public Methods
    func loadFavorites() {
        movies = favoritesService.getFavoriteMovies().reversed() // Show most recent first
        onMoviesUpdated?()
    }

    func didSelectMovie(_ movie: Movie) {
        router.navigateToDetail(with: "\(movie.id)")
    }

    // MARK: - Private Methods
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesDidChange),
            name: FavoritesService.favoritesDidChangeNotification,
            object: nil
        )
    }

    @objc private func favoritesDidChange() {
        loadFavorites()
    }
}
