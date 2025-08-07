//
//  AppRouter.swift
//  MovieApp
//
//  Created by Yasin Çetin on 6.08.2025.
//

import Foundation
import UIKit

protocol AppRouterProtocol {
    func start()
    func navigateToDetail(with movie: Movie)
}

final class AppRouter: AppRouterProtocol {
    
    private let window: UIWindow
    private let container: DIContainer
    private let navigationController: UINavigationController
    
    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.container = container
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let homeVC = container.makeHomeViewController(router: self)
        navigationController.viewControllers = [homeVC]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func navigateToDetail(with movie: Movie) {
        let detailVC = container.makeDetailViewController(movie: movie, router: self)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
