//
//  MovieDetail.swift
//  MovieApp
//
//  Created by Yasin Çetin on 7.08.2025.
//

import Foundation

struct MovieDetail {
    let id: Int
    let title: String?
    let voteAverageText: String
    let overview: String
    let posterURL: URL?
    let backdropImageURL: URL?
    let genres: [String]
    let runtime: Int?
    let releaseDate: String?
    let tagline: String?

    var runtimeText: String? {
        guard let runtime = runtime, runtime > 0 else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)s \(minutes)dk"
        } else {
            return "\(minutes)dk"
        }
    }

    var releaseDateFormatted: String? {
        guard let releaseDate = releaseDate else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate) else { return releaseDate }
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        return dateFormatter.string(from: date)
    }
}
