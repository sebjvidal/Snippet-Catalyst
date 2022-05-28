//
//  Int+PresetGradient.swift
//  Snippet
//
//  Created by Seb Vidal on 21/03/2022.
//

import UIKit

extension Int {
    func toPresetGradient() -> [CGColor] {
        let gradient: SnippetGradient
        
        if SnippetGradient.presets.indices.contains(self) {
            gradient = .presets[self]
        } else {
            gradient = .presets[0]
        }
        
        var colours: [CGColor] = []
        colours.append(gradient.colour1.cgColor)
        colours.append(gradient.colour2.cgColor)
        
        return colours
    }
    
    func toPresetGradientHSV() -> [HSV] {
        let gradient: SnippetGradient
        
        if SnippetGradient.presets.indices.contains(self) {
            gradient = .presets[self]
        } else {
            gradient = .presets[0]
        }
        
        var colours: [HSV] = []
        colours.append(gradient.colour1)
        colours.append(gradient.colour2)
        
        return colours
    }
}
