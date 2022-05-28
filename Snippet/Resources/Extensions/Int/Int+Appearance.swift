//
//  Int+Appearance.swift
//  Snippet
//
//  Created by Seb Vidal on 21/03/2022.
//

import UIKit

extension Int {
    func toUIUserInterfaceStyle() -> UIUserInterfaceStyle {
        switch self {
        case 1:
            return .light
        case 2:
            return .dark
        default:
            return .unspecified
        }
    }
}
