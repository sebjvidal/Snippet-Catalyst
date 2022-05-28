//
//  CacheManager+Gradients.swift
//  Snippet
//
//  Created by Seb Vidal on 10/04/2022.
//

import Foundation

extension CacheManager {
    /// Loads and array of CGFloats corresponding to a gradient node's location.
    /// The CGFloat values should range from 0 to 1. Values outside this range will cause unexpected results.
    var gradientLocations: [NSNumber] {
        _loadPreferredGradientLocations()
    }
    
    var gradientValues: [[CGFloat]] {
        _loadPreferredGradientValues()
    }
    
    var gradientHSVs: [HSV] {
        _loadPreferredGradientHSVs()
    }
    
    var gradientColours: [CGColor] {
        _loadPreferredGradientColours()
    }
    
    private func _loadPreferredGradientValues() -> [[CGFloat]] {
        if let colours = defaults.array(forKey: "gradientColours") as? [[CGFloat]] {
            return colours
        }
        
        return [[]]
    }
    
    private func _loadPreferredGradientLocations() -> [NSNumber] {
        if let locations = defaults.array(forKey: "gradientLocations") as? [NSNumber] {
            return locations
        }
        
        return [0, 1]
    }
    
    private func _loadPreferredGradientHSVs() -> [HSV] {
        if let colours = defaults.array(forKey: "gradientColours") as? [[Float]] {
            var HSVs: [HSV] = []
            
            for colour in colours {
                let hue = colour[0]
                let saturation = colour[1]
                let brightness = colour[2]
                let hsv = HSV(h: hue, s: saturation, v: brightness)
                
                HSVs.append(hsv)
            }
            
            return HSVs
        }
        
        return [
            HSV(h: 321, s: 0.767, v: 0.808),
            HSV(h: 255, s: 0.741, v: 0.894)
        ]
    }
    
    private func _loadPreferredGradientColours() -> [CGColor] {
        let hsvs = _loadPreferredGradientHSVs()
        var cgColors: [CGColor] = []
        
        for hsv in hsvs {
            cgColors.append(hsv.cgColor)
        }
        
        return cgColors
    }
    
    func setGradientLocations(to locations: [CGFloat]) {
        defaults.set(locations, forKey: "gradientLocations")
    }
    
    func setGradientHSVs(to colours: [HSV]) {
        var floats: [[Float]] = []
        
        for colour in colours {
            floats.append([colour.h, colour.s, colour.v])
        }
        
        defaults.set(floats, forKey: "gradientColours")
    }
    
    // MARK: Gradients - Recent Preset
    var recentGradientPreset: Int {
        _loadPreferredRecentGradientPreset()
    }
    
    private func _loadPreferredRecentGradientPreset() -> Int {
        return defaults.integer(forKey: "recentGradientPreset")
    }
    
    func setRecentGradientPreset(to int: Int) {
        defaults.set(int, forKey: "recentGradientPreset")
    }
    
    // MARK: Gradients - Recent Type
    var recentSolidColourPreset: Int {
        _loadPreferredRecentSolidColourPreset()
    }
    
    private func _loadPreferredRecentSolidColourPreset() -> Int {
        return defaults.integer(forKey: "recentSolidColourPreset")
    }
    
    func setRecentSolidColourPreset(to int: Int) {
        defaults.set(int, forKey: "recentSolidColourPreset")
    }
}
