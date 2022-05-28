//
//  CacheManager+Backgrounds.swift
//  Snippet
//
//  Created by Seb Vidal on 10/04/2022.
//

import Foundation

extension CacheManager {
    // MARK: Preset Solid Colour
    var preferredPresetSolidColour: Int {
        _loadPreferredPresetSolidColour()
    }
    
    private func _loadPreferredPresetSolidColour() -> Int {
        return defaults.integer(forKey: "presetSolidColour")
    }
    
    func setPreferredPresetSolidColour(to int: Int) {
        defaults.set(int, forKey: "presetSolidColour")
    }
    
    // MARK: Custom Solid Colour - CGColor
    var preferredCustomSolidColour: CGColor {
        _loadPreferredCustomSolidColour()
    }
    
    private func _loadPreferredCustomSolidColour() -> CGColor {
        let hsv = _loadPreferredCustomSolidHsv()
        let rgb = HSV(h: hsv[0], s: hsv[1], v: hsv[2]).rgb
        
        let red = CGFloat(rgb.r)
        let green = CGFloat(rgb.g)
        let blue = CGFloat(rgb.b)
        
        let colour = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.displayP3)!, components: [red, green, blue, 1])!
        
        return colour
    }
    
    func setPreferredCustomSolidHSV(to hsv: HSV) {
        defaults.set([hsv.h, hsv.s, hsv.v], forKey: "customSolidHsv")
    }
    
    // MARK: Custom Solid Colour - HSV
    var preferredCustomSolidHSV: [Float] {
        _loadPreferredCustomSolidHsv()
    }
    
    private func _loadPreferredCustomSolidHsv() -> [Float] {
        if let components = defaults.array(forKey: "customSolidHsv") as? [Float] {
            return components
        }
        
        return [1, 1, 1]
    }
}
