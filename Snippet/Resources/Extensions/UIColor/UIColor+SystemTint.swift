//
//  UIColor+SystemTint.swift
//  Snippet
//
//  Created by Seb Vidal on 09/05/2022.
//

import UIKit

extension UIColor {
    static var systemTint: UIColor {
        if let value = UserDefaults.standard.object(forKey: "AppleHighlightColor") as? NSString {
            let components = value.components(separatedBy: " ")
            let colour = components[3]
            
            switch colour {
            case "Purple":
                return UIColor(displayP3Red: 188/255, green: 61/255, blue: 197/255, alpha: 1)
            case "Pink":
                return UIColor(displayP3Red: 213/255, green: 87/255, blue: 143/255, alpha: 1)
            case "Red":
                return UIColor(displayP3Red: 220/255, green: 79/255, blue: 75/255, alpha: 1)
            case "Orange":
                return UIColor(displayP3Red: 228/255, green: 122/255, blue: 46/255, alpha: 1)
            case "Yellow":
                return UIColor(displayP3Red: 225/255, green: 178/255, blue: 61/255, alpha: 1)
            case "Green":
                return UIColor(displayP3Red: 104/255, green: 175/255, blue: 67/255, alpha: 1)
            case "Graphite":
                return UIColor(displayP3Red: 154/255, green: 154/255, blue: 154/255, alpha: 1)
            default:
                break
            }
        }
        
        return .systemBlue
    }
    
    static var systemTintString: String {
        if let value = UserDefaults.standard.object(forKey: "AppleHighlightColor") as? NSString {
            let components = value.components(separatedBy: " ")
            let colour = components[3]
            
            return colour
        }
        
        return "Blue"
    }
}
