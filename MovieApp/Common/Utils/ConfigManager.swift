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
        return config["TMDBBaseURL"] as? String ?? "https://api.themoviedb.org/3"
    }

    var tmdbBearerToken: String {
        
        let token = config["TMDBBearerToken"] as? String ?? ""
        if token.isEmpty {
            print("⚠️ WARNING: TMDB Bearer Token is missing! Please add it to Secrets.plist file with key 'TMDBBearerToken'")
        }
        return token
    }
}
