//
//  DetailViewModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import Foundation

protocol DetailViewModelProtocol {
    func getImageUrl() -> URL?
    func getOverview() -> String?
    func getVote() -> String?
    func getTitle() -> String?
}

final class DetailViewModel {
    
    private let router: AppRouterProtocol?
    private var movie: Movie?
    
    init(movie: Movie, router: AppRouterProtocol) {
        self.router = router
        self.movie = movie
    }
    
}

extension DetailViewModel: DetailViewModelProtocol {
    func getTitle() -> String? {
        return movie?.title
    }
    
    func getImageUrl() -> URL? {
        return movie?.posterURL
    }
    
    func getOverview() -> String? {
        return movie?.overview
    }
    
    func getVote() -> String? {
        return movie?.voteAverageText
    }
    
    
}
