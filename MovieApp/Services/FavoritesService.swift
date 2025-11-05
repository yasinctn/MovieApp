//
//  FavoritesService.swift
//  MovieApp
//
//  Created by Claude Code
//

import Foundation

protocol FavoritesServiceProtocol {
    func toggleFavorite(movie: Movie)
    func isFavorite(movieId: Int) -> Bool
    func getFavoriteMovies() -> [Movie]
    func removeFavorite(movieId: Int)
    func addFavorite(movie: Movie)
}

class FavoritesService: FavoritesServiceProtocol {

    // UserDefaults key for storing favorite movies
    private let favoritesKey = "favoriteMovies"

    // Notification name for favorite status changes
    static let favoritesDidChangeNotification = Notification.Name("FavoritesDidChange")

    // Singleton instance
    static let shared = FavoritesService()

    private init() {}

    // MARK: - Public Methods

    /// Toggle favorite status for a movie
    func toggleFavorite(movie: Movie) {
        if isFavorite(movieId: movie.id) {
            removeFavorite(movieId: movie.id)
        } else {
            addFavorite(movie: movie)
        }
    }

    /// Check if a movie is favorited
    func isFavorite(movieId: Int) -> Bool {
        let favorites = getFavoriteMovies()
        return favorites.contains { $0.id == movieId }
    }

    /// Get all favorite movies
    func getFavoriteMovies() -> [Movie] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Movie].self, from: data)) ?? []
    }

    /// Add a movie to favorites
    func addFavorite(movie: Movie) {
        var favorites = getFavoriteMovies()
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
            saveFavorites(favorites)
            postFavoritesChangeNotification()
        }
    }

    /// Remove a movie from favorites
    func removeFavorite(movieId: Int) {
        var favorites = getFavoriteMovies()
        favorites.removeAll { $0.id == movieId }
        saveFavorites(favorites)
        postFavoritesChangeNotification()
    }

    // MARK: - Private Methods

    private func saveFavorites(_ favorites: [Movie]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
            UserDefaults.standard.synchronize()
        }
    }

    private func postFavoritesChangeNotification() {
        NotificationCenter.default.post(name: FavoritesService.favoritesDidChangeNotification, object: nil)
    }
}
