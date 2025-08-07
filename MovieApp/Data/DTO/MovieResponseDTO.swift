//
//  MovieResponseModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import Foundation

struct MovieResponseDTO: Codable {
    
    let results: [MovieDTO]?
    
}


struct MovieDTO: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: OriginalLanguage
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
    case ko = "ko"
    case zh = "zh"
}

extension MovieDTO {
    func toMovie() -> Movie {
        Movie(
            id: id,
            title: title,
            voteAverageText: "⭐️ \(voteAverage)",
            overview: overview,
            posterURL: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)"),
            backdropImageURL: URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
        )
    }
    
    
}
