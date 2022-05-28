//
//  CGColor.swift
//  Snippet
//
//  Created by Seb Vidal on 08/02/2022.
//

import UIKit

extension CGColor {
    static let preset1 = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.displayP3)!, components: [135.0/255, 183.0/255, 98.0/255, 1])!
    static let preset2 = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.displayP3)!, components: [192.0/255, 82.0/255, 75.0/255, 1])!
    static let preset3 = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.displayP3)!, components: [130.0/255, 70.0/255, 142.0/255, 1])!
    static let preset4 = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.displayP3)!, components: [233.0/255, 189.0/255, 95.0/255, 1])!
    static let preset5 = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.displayP3)!, components: [218.0/255, 141.0/255, 75.0/255, 1])!
    static let preset6 = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.displayP3)!, components: [92.0/255, 153.0/255, 209.0/255, 1])!
    
    static let presets = [preset1, preset2, preset3, preset4, preset5, preset6]
    
    static let defaultGradient1 = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.displayP3)!, components: [208.0/255, 48.0/255, 152.0/255, 1])!
    static let defaultGradient2 = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.displayP3)!, components: [102.0/255, 59.0/255, 228.0/255, 1])!
}

extension CGColor {
    var imageRepresentation : UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}
