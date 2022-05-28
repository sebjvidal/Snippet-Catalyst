//
//  CacheManager+Window.swift
//  Snippet
//
//  Created by Seb Vidal on 10/04/2022.
//

import Foundation

extension CacheManager {
    // MARK: Window - Title
    var preferredTitle: String {
        _loadPreferredTitle()
    }
    
    private func _loadPreferredTitle() -> String {
        return defaults.string(forKey: "title") ?? "Untitled"
    }
    
    func setPreferredTitle(to string: String?) {
        defaults.set(string ?? "Untitled", forKey: "title")
    }
    
    // MARK: Window - Titlebar Icon
    // Determins Tilebar Icon visibility
    var prefersIconVisible: Bool {
        _loadPrefersIconVisible()
    }
    
    private func _loadPrefersIconVisible() -> Bool {
        if defaults.keyExists(key: "showIcon") {
            return defaults.bool(forKey: "showIcon")
        }
        
        return false
    }
    
    func setPreferredIconVisibility(to bool: Bool) {
        defaults.set(bool, forKey: "showIcon")
    }
    
    // MARK: Window - Appearance
    // Determines window appearance in canvas
    // Automatic, Light or Dark
    var preferredAppearance: Int {
        _loadPreferredAppearance()
    }
    
    private func _loadPreferredAppearance() -> Int {
        return defaults.integer(forKey: "appearance")
    }
    
    func setPreferredAppearance(to int: Int) {
        defaults.set(int, forKey: "appearance")
    }
    
    // MARK: Window - Controls
    // Determines the colour of the window controls
    // Colourful, Graphite or none
    var preferredControlsStyle: Int {
        _loadPreferredControlsStyle()
    }
    
    private func _loadPreferredControlsStyle() -> Int {
        return defaults.integer(forKey: "controls")
    }
    
    func setPreferredControlStyle(to int: Int) {
        defaults.set(int, forKey: "controls")
    }
    
    // MARK: Window - Opacity
    // Determines window UIVisualEffectView opacity
    var preferredWindowOpacity: Float {
        _loadPreferredWindowOpacity()
    }
    
    private func _loadPreferredWindowOpacity() -> Float {
        if defaults.keyExists(key: "windowOpacity") {
            return defaults.float(forKey: "windowOpacity")
        }
        
        return 0.75
    }
    
    func setPreferredWindowOpacity(to float: Float) {
        defaults.set(float, forKey: "windowOpacity")
    }
    
    // MARK: Window - Controls Symbols
    // Determines whether symbols should be shown on the window controls
    var showControlsSymbols: Bool {
        _loadPrefersShowControlsSymbols()
    }
    
    private func _loadPrefersShowControlsSymbols() -> Bool {
        return defaults.bool(forKey: "controlsSymbols")
    }
    
    func setShowControlsSymbols(to bool: Bool) {
        defaults.set(bool, forKey: "controlsSymbols")
    }
    
    // MARK: Window - Horizontal Padding
    // Determines window horizontal padding
    var preferredHorizontalPadding: Int {
        _loadPreferredHorizontalPadding()
    }
    
    private func _loadPreferredHorizontalPadding() -> Int {
        if defaults.keyExists(key: "hPadding") {
            return defaults.integer(forKey: "hPadding")
        }
        
        return 64
    }
    
    func setPreferredHorizontalPadding(to int: Int) {
        defaults.set(int, forKey: "hPadding")
    }
    
    // MARK: Window - Vertical Padding
    // Determines window vertical padding
    var preferredVerticalPadding: Int {
        _loadPreferredVerticalPadding()
    }
    
    private func _loadPreferredVerticalPadding() -> Int {
        if defaults.keyExists(key: "vPadding") {
            return defaults.integer(forKey: "vPadding")
        }
        
        return 64
    }
    
    func setPreferredVerticalPadding(to int: Int) {
        defaults.set(int, forKey: "vPadding")
    }
    
    
    // MARK: Matched Padding
    var prefersMatchedPadding: Bool {
        _preferredMatchingPadding()
    }
    
    private func _preferredMatchingPadding() -> Bool {
        if let matchedPadding = defaults.object(forKey: "matchedPadding") as? Bool {
            return matchedPadding
        }
        
        return true
    }
    
    func setPreferredMatchedPadding(to bool: Bool) {
        defaults.set(bool, forKey: "matchedPadding")
    }
    
    // MARK: Window - Content Mode
    // Determines window sizing
    var windowContentMode: Int {
        _loadWindowContentMode()
    }
    
    private func _loadWindowContentMode() -> Int {
        return defaults.integer(forKey: "windowMode")
    }
    
    func setWindowContentMode(to int: Int) {
        defaults.set(int, forKey: "windowMode")
    }
}
