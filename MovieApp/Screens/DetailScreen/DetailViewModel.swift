//
//  DetailViewModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import Foundation

protocol DetailViewModelProtocol {
    func getDetails(id: String)
    var onMovieDetailUpdated: (() -> Void)? { get set }
    var movieDetail: MovieDetail? { get }
}

final class DetailViewModel {
    
    private let router: AppRouterProtocol?
    private let apiService: TMDBApiServiceProtocol?
    
    var movieDetail: MovieDetail? {
        didSet {
            onMovieDetailUpdated?()
        }
    }
    
    var onMovieDetailUpdated: (() -> Void)?
    
    init(apiService: TMDBApiServiceProtocol?, router: AppRouterProtocol) {
        self.router = router
        self.apiService = apiService
    }
    
    
}

extension DetailViewModel: DetailViewModelProtocol {
    
    func getDetails(id: String) {
        apiService?.getMovieDetail(id: id) { result in
            switch result {
            case .success(let movieDetail):
                let domainMovieDetail = movieDetail.toMovieDetail()
                DispatchQueue.main.async {
                    self.movieDetail = domainMovieDetail
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
