//
//  Int+CustomSolidColour.swift
//  Snippet
//
//  Created by Seb Vidal on 21/03/2022.
//

import UIKit

extension Int {
    func toCustomSolidColour(withComponents components: [CGFloat]) -> HSV {
        return HSV(
            h: Float(components[0]),
            s: Float(components[1]),
            v: Float(components[2])
        )
    }
}
