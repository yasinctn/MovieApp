//
//  MainTabBarController.swift
//  MovieApp
//
//  Created by Yasin Çetin on 7.08.2025.
//

import Foundation

import UIKit

final class MainTabBarController: UITabBarController {
    
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        tabBar.tintColor = .systemBlue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
