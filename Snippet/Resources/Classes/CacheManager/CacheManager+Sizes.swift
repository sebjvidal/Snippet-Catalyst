//
//  CacheManager+Sizes.swift
//  Snippet
//
//  Created by Seb Vidal on 10/04/2022.
//

import Foundation

extension CacheManager {
    // MARK: Sizes
    var preferredSize: Int {
        _loadPreferredSize()
    }
    
    private func _loadPreferredSize() -> Int {
        return defaults.integer(forKey: "aspectRatio")
    }
    
    func setupPreferredSize(to int: Int) {
        defaults.set(int, forKey: "aspectRatio")
    }
}
