//
//  Collection+Extension.swift
//  MovieApp
//
//  Created by Yasin Çetin on 12.08.2025.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
