//
//  Int+SolidColour.swift
//  Snippet
//
//  Created by Seb Vidal on 21/03/2022.
//

import UIKit

extension Int {
    func toPresetSolidColour() -> CGColor {
        if CGColor.presets.indices.contains(self) {
            return .presets[self]
        } else {
            return .preset1
        }
    }
}
