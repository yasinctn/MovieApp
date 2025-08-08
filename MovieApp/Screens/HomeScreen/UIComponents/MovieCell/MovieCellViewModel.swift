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
    init(movie: Movie) {
        self.title = movie.title
        self.voteAverageText = movie.voteAverageText
        self.imageURL = movie.posterURL
    }
}
