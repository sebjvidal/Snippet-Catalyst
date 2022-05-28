//
//  Int+ControlColourScheme.swift
//  Snippet
//
//  Created by Seb Vidal on 21/03/2022.
//

import UIKit

extension Int {
    func toControlColourScheme() -> ControlColourScheme {
        switch self {
        case 1:
            return .graphite
        case 2:
            return .none
        default:
            return .colourful
        }
    }
}
