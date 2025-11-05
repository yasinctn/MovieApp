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
    func navigateToDetail(with id: String)
    func navigateToMore(with section: MovieSectionType)
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
        let favoritesVC = container.makeFavoritesViewController(router: self)
        let profileVC = container.makeProfileViewController()

        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 1)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        
        let tabBarController = MainTabBarController(viewControllers: [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: favoritesVC),
            UINavigationController(rootViewController: profileVC)
        ])
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
//    func start() {
//        let homeVC = container.makeHomeViewController(router: self)
//        navigationController.viewControllers = [homeVC]
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
//    }
    
    func navigateToDetail(with id: String) {
        let detailVC = container.makeDetailViewController(id: id, router: self)
        
        if let tabBarController = window.rootViewController as? UITabBarController,
           let navController = tabBarController.selectedViewController as? UINavigationController {
            navController.pushViewController(detailVC, animated: true)
        }
    }
    
    func navigateToMore(with id: MovieSectionType) {
        let detailVC = container.makeMoreMovieViewController(section: id, router: self)
        
        if let tabBarController = window.rootViewController as? UITabBarController,
           let navController = tabBarController.selectedViewController as? UINavigationController {
            navController.pushViewController(detailVC, animated: true)
        }
    }
}
