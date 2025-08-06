//
//  ConfigManager.swift
//  MovieApp
//
//  Created by Yasin Çetin on 5.08.2025.
//

import Foundation

final class ConfigManager {
    static let shared = ConfigManager()
    private var config: [String: Any] = [:]

    private init() {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let data = NSDictionary(contentsOfFile: path) as? [String: Any] {
            self.config = data
        }
    }

    var tmdbBaseURL: String {
        return config["TMDBBaseURL"] as? String ?? ""
    }

    var tmdbBearerToken: String {
        return config["TMDBBearerToken"] as? String ?? ""
    }
}
