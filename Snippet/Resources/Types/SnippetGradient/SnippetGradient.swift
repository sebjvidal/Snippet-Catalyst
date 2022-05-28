//
//  SnippetGradient.swift
//  Snippet
//
//  Created by Seb Vidal on 12/02/2022.
//

import UIKit

struct SnippetGradient {
    var colour1: HSV
    var colour2: HSV
    var angle: CGFloat?
    
    init(colour1: HSV, colour2: HSV) {
        self.colour1 = colour1
        self.colour2 = colour2
    }
}

extension SnippetGradient {
    static let presets: [SnippetGradient] = [
        SnippetGradient(colour1: HSV(h: 321, s: 0.769, v: 0.816),
                        colour2: HSV(h: 255, s: 0.741, v: 0.894)),
        
        SnippetGradient(colour1: HSV(h: 39, s: 0.76, v: 0.945),
                        colour2: HSV(h: 328, s: 0.781, v: 0.843)),
        
        SnippetGradient(colour1: HSV(h: 59, s: 0.587, v: 0.996),
                        colour2: HSV(h: 24, s: 0.679, v: 0.929)),
        
        SnippetGradient(colour1: HSV(h: 180, s: 0.53, v: 0.976),
                        colour2: HSV(h: 273, s: 0.885, v: 0.957)),
        
        SnippetGradient(colour1: HSV(h: 327, s: 0.56, v: 1),
                        colour2: HSV(h: 284, s: 1, v: 0.70)),
        
        SnippetGradient(colour1: HSV(h: 174, s: 0.447, v: 0.95),
                        colour2: HSV(h: 139, s: 0.74, v: 0.85))
    ]
}
