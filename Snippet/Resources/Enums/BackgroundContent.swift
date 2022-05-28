//
//  BackgroundContent.swift
//  Snippet
//
//  Created by Seb Vidal on 04/02/2022.
//

import UIKit

enum BackgroundContent {
    case none
    case solid(colour: CGColor)
    case gradient(colours: [CGColor])
    case image(image: UIImage)
}
