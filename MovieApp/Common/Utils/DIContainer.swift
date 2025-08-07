//
//  DIContainer.swift
//  MovieApp
//
//  Created by Yasin Çetin on 6.08.2025.
//

import Foundation
import UIKit

final class DIContainer {
    
    private let apiService: TMDBApiServiceProtocol
    
    init() {
        self.apiService = TMDBApiService()
    }
    
    func makeHomeViewController(router: AppRouterProtocol) -> HomeViewController {
        let viewController = HomeViewController()
        let viewModel = HomeViewModel(apiService: apiService, router: router)
        viewController.setViewModel(viewModel)
        return viewController
    }
    
    func makeDetailViewController(movie: Movie, router: AppRouterProtocol) -> DetailViewController {
        let detailVC = DetailViewController()
        let viewModel = DetailViewModel(movie: movie, router: router)
        detailVC.setViewModel(viewModel)
        return detailVC
    }
}

