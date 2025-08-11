//
//  MovieSection.swift
//  MovieApp
//
//  Created by Yasin Çetin on 8.08.2025.
//

import Foundation

enum MovieSection: Int, CaseIterable {
    case nowPlaying
    case popular
    case topRated
    case upcoming
    
    var title: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        case .upcoming: return "Upcoming"
        }
    }
}
