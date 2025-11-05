//
//  Cast.swift
//  MovieApp
//
//  Created by Claude Code
//

import Foundation

struct Cast: Codable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    let order: Int

    var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(profilePath)")
    }
}
