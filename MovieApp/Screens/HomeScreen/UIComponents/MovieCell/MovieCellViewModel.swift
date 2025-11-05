//
//  MovieCellViewModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 6.08.2025.
//

import Foundation

struct MovieCellViewModel {

    private let movie: Movie
    private let favoritesService: FavoritesServiceProtocol

    init(movie: Movie, favoritesService: FavoritesServiceProtocol = FavoritesService.shared) {
        self.movie = movie
        self.favoritesService = favoritesService
    }

    var movieId: Int { movie.id }
    var title: String { movie.title }
    var imageURL: URL? { movie.posterURL }

    var isFavorite: Bool {
        favoritesService.isFavorite(movieId: movie.id)
    }

    var ratingText: String {
        String(format: "%.1f", movie.voteAverage)
    }

    var metaText: String {
        let year: String = {
            guard
                let s = movie.releaseDateString,
                let d = ISO8601DateFormatter.iso8601yyyyMMdd.date(from: s)
            else { return "Tarih yok" }
            let f = DateFormatter()
            f.dateFormat = "yyyy"
            return f.string(from: d)
        }()

        let lang = movie.originalLanguageCode?.uppercased() ?? "N/A"
        return "\(year) • \(lang) • \(movie.voteCount) oy"
    }
}

private extension ISO8601DateFormatter {
    static let iso8601yyyyMMdd: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .iso8601)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}

