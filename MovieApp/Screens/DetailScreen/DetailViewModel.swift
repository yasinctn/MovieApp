//
//  DetailViewModel.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import Foundation
import PromiseKit

protocol DetailViewModelProtocol {
    func getDetails(id: String)
    func retry()
    var onMovieDetailUpdated: (() -> Void)? { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var movieDetail: MovieDetail? { get }
}

final class DetailViewModel {
    
    private let router: AppRouterProtocol?
    private let apiService: TMDBApiServiceProtocol?
    private var currentMovieId: String?

    var movieDetail: MovieDetail? {
        didSet {
            onMovieDetailUpdated?()
        }
    }

    var onMovieDetailUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    init(apiService: TMDBApiServiceProtocol?, router: AppRouterProtocol) {
        self.router = router
        self.apiService = apiService
    }
    
    
}

extension DetailViewModel: DetailViewModelProtocol {
    
    func getDetails(id: String) {
        currentMovieId = id
        onLoadingStateChanged?(true)

        apiService?.getMovieDetail(id: id)
        .done(on: .main) { [weak self] detail in
            self?.onLoadingStateChanged?(false)
            self?.movieDetail = detail
            self?.onMovieDetailUpdated?()
        }
        .catch { [weak self] error in
            self?.onLoadingStateChanged?(false)
            self?.onError?("Film bilgileri yüklenirken bir hata oluştu. Lütfen tekrar deneyin.")
            #if DEBUG
            print("Detail error:", error)
            #endif
        }
    }

    func retry() {
        guard let movieId = currentMovieId else { return }
        getDetails(id: movieId)
    }
    
}
