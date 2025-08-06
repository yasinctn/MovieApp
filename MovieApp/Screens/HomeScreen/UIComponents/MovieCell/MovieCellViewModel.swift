//
//  MovieCellViewModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 6.08.2025.
//

import Foundation

struct MovieCellViewModel {
    let title: String
    let voteAverageText: String
    let imageURL: URL?
}

extension MovieCellViewModel {
    init(movie: MovieDTO) {
        self.title = movie.title
        self.voteAverageText = "⭐️ \(movie.voteAverage)"
        self.imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.backdropPath)")
    }
}
