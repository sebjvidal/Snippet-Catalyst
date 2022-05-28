//
//  ColourPickerDelegate.swift
//  Snippet
//
//  Created by Seb Vidal on 14/02/2022.
//

import UIKit

protocol ColourPickerDelegate {
    func colourWillChange(forFirstTime firstTime: Bool, withHue hue: Float, saturation: Float, brightness: Float, source: UIView?)
    func colourDidChange(to colour: CGColor, source: UIView?)
    func colourDidChange(withHue hue: Float, saturation: Float, brightness: Float, source: UIView?)
}

extension ColourPickerDelegate {
    func colourWillChange(forFirstTime firstTime: Bool, withHue hue: Float, saturation: Float, brightness: Float, source: UIView?) {}
    func colourDidChange(to colour: CGColor, source: UIView?) {}
}
