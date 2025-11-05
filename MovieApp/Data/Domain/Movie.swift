//
//  Movie.swift
//  MovieApp
//
//  Created by Yasin Çetin on 6.08.2025.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterURL: URL?
    let backdropImageURL: URL?
    let voteAverage: Double
    let voteCount: Int
    let releaseDateString: String?      // "YYYY-MM-DD" (TMDB)
    let originalLanguageCode: String?   // "en", "tr" ...

    var voteAverageText: String { String(format: "⭐️ %.1f", voteAverage) }
}


