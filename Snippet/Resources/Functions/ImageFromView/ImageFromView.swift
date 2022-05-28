//
//  ImageFromView.swift
//  Snippet
//
//  Created by Seb Vidal on 02/02/2022.
//

import UIKit

func image(from view: UIView) -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
    let image = renderer.image { context in
        view.layer.render(in: context.cgContext)
    }
    
    return image
}
