//
//  MovieSection.swift
//  MovieApp
//
//  Created by Yasin Çetin on 12.08.2025.
//

import Foundation

protocol SectionModel {
    var sectionTitle: String? { get }
    var itemCount: Int { get }
    var sectionType: MovieSectionType { get }
    func getItem(at index: Int) -> Movie?
}

struct MovieSection: SectionModel {
    var sectionTitle: String?
    var movies: [Movie]
    var sectionType: MovieSectionType
    
    var itemCount: Int {
        return movies.count
    }
    
    func getItem(at index: Int) -> Movie? {
        guard index < movies.count else { return nil }
        return movies[index]
    }
    
    init(sectionType: MovieSectionType, movies: [Movie] = []) {
        self.sectionType = sectionType
        self.sectionTitle = sectionType.title
        self.movies = movies
    }
}
