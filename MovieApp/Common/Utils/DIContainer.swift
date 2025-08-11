//
//  DIContainer.swift
//  MovieApp
//
//  Created by Yasin Çetin on 6.08.2025.
//

import Foundation
import UIKit

final class DIContainer {
    
    // MARK: - Shared Instances
    private lazy var networkClient: NetworkClientProtocol = makeNetworkClient()
    private lazy var apiService: TMDBApiServiceProtocol = makeTMDBApiService()
    
    // MARK: - ViewController Factories
    
    func makeHomeViewController(router: AppRouterProtocol) -> HomeViewController {
        let viewModel = HomeViewModel(apiService: apiService, router: router)
        let viewController = HomeViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeDetailViewController(id: String, router: AppRouterProtocol) -> DetailViewController {
        let viewModel = DetailViewModel(apiService: apiService, router: router)
        let viewController = DetailViewController(viewModel: viewModel)
        viewModel.getDetails(id: id)
        return viewController
    }
    
    func makeFavoritesViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        vc.title = "Favorites"
        return vc
    }

    func makeProfileViewController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        vc.title = "Profile"
        return vc
    }
    
    // MARK: - Service & Client Factories
    
    private func makeNetworkClient() -> NetworkClientProtocol {
        return NetworkClient()
    }
    
    private func makeTMDBApiService() -> TMDBApiServiceProtocol {
        return TMDBApiService(networkClient: networkClient)
    }
}


