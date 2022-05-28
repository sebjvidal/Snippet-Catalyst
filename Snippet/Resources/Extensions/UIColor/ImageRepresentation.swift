//
//  ImageRepresentation.swift
//  Snippet
//
//  Created by Seb Vidal on 04/02/2022.
//

import UIKit

extension UIColor {
    var imageRepresentation : UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}
