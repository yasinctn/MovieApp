//
//  DetailViewModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import Foundation

protocol DetailViewModelProtocol {
    func getImageUrl(for path: String) -> URL
}

final class DetailViewModel {
    
    private let router: AppRouterProtocol
    
    var movies: [MovieDTO] = []
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
}

extension DetailViewModel: DetailViewModelProtocol {
    
    func getImageUrl(for path: String) -> URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")!
    }
}
