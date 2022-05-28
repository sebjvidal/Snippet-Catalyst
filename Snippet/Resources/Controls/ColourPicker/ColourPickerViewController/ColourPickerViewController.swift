//
//  ColourPickerViewController.swift
//  Snippet
//
//  Created by Seb Vidal on 05/02/2022.
//

import UIKit
import SwiftUI

class ColourPickerViewController: UIViewController, UITextFieldDelegate {
    var delegate: ColourPickerDelegate?
    
    var hue: CGFloat = 0
    var saturation: CGFloat = 1
    var brightness: CGFloat = 1
    
    private var hexTextField: UITextField!
    private var hsvGradient: HSVGradient!
    private var hsvSlider: HSVSliderView!
    
    private var redLabel: UILabel!
    private var greenLabel: UILabel!
    private var blueLabel: UILabel!
    private var redTextField: UITextField!
    private var greenTextField: UITextField!
    private var blueTextField: UITextField!
    
    private var hueLabel: UILabel!
    private var saturationLabel: UILabel!
    private var brightnessLabel: UILabel!
    private var hueTextField: UITextField!
    private var saturationTextField: UITextField!
    private var brightnessTextField: UITextField!
    
    private var firstEdit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupHSVView()
        setupHSVSliderView()
        setupRgbLabels()
        setupHsvLabels()
        updateTextFields()
    }
    
    private func setupTextField() {
        hexTextField = UITextField()
        hexTextField.delegate = self
        hexTextField.font = .systemFont(ofSize: 16, weight: .semibold)
        hexTextField.borderStyle = .none
        hexTextField.autocapitalizationType = .allCharacters
        hexTextField.translatesAutoresizingMaskIntoConstraints = false
        hexTextField.text = "#" + HSV(h: Float(hue), s: Float(saturation), v: Float(brightness)).hex
        
        view.addSubview(hexTextField)
        
        NSLayoutConstraint.activate([
            hexTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            hexTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hexTextField.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setupHSVView() {
        hsvGradient = HSVGradient()
        hsvGradient.parent = self
        hsvGradient.clipsToBounds = true
        hsvGradient.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hsvGradient)

        NSLayoutConstraint.activate([
            hsvGradient.topAnchor.constraint(equalTo: hexTextField.bottomAnchor, constant: 12),
            hsvGradient.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hsvGradient.widthAnchor.constraint(equalToConstant: 250),
            hsvGradient.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setupHSVSliderView() {
        hsvSlider = HSVSliderView()
        hsvSlider.parent = self
        hsvSlider.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hsvSlider)
        
        NSLayoutConstraint.activate([
            hsvSlider.topAnchor.constraint(equalTo: hsvGradient.bottomAnchor, constant: 16),
            hsvSlider.leadingAnchor.constraint(equalTo: hsvGradient.leadingAnchor, constant: 1),
            hsvSlider.widthAnchor.constraint(equalToConstant: 248),
            hsvSlider.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupRgbLabels() {
        redLabel = UILabel()
        redLabel.text = "R:"
        redLabel.translatesAutoresizingMaskIntoConstraints = false
        
        redTextField = UITextField()
        redTextField.tag = 1
        redTextField.delegate = self
        redTextField.borderStyle = .roundedRect
        redTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(redLabel)
        view.addSubview(redTextField)
        
        NSLayoutConstraint.activate([
            redTextField.topAnchor.constraint(equalTo: hsvSlider.bottomAnchor, constant: 16),
            redTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            redTextField.leadingAnchor.constraint(equalTo: redLabel.trailingAnchor, constant: 8),
            redLabel.centerYAnchor.constraint(equalTo: redTextField.centerYAnchor),
            redLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            redLabel.widthAnchor.constraint(equalToConstant: 14)
        ])
        
        greenLabel = UILabel()
        greenLabel.text = "G:"
        greenLabel.translatesAutoresizingMaskIntoConstraints = false
        
        greenTextField = UITextField()
        greenTextField.tag = 1
        greenTextField.delegate = self
        greenTextField.borderStyle = .roundedRect
        greenTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(greenLabel)
        view.addSubview(greenTextField)
        
        NSLayoutConstraint.activate([
            greenTextField.topAnchor.constraint(equalTo: redTextField.bottomAnchor, constant: 8),
            greenTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            greenTextField.leadingAnchor.constraint(equalTo: redLabel.trailingAnchor, constant: 8),
            greenLabel.centerYAnchor.constraint(equalTo: greenTextField.centerYAnchor),
            greenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            greenLabel.widthAnchor.constraint(equalToConstant: 14)
        ])
        
        blueLabel = UILabel()
        blueLabel.text = "B:"
        blueLabel.translatesAutoresizingMaskIntoConstraints = false

        blueTextField = UITextField()
        blueTextField.tag = 1
        blueTextField.delegate = self
        blueTextField.borderStyle = .roundedRect
        blueTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(blueLabel)
        view.addSubview(blueTextField)

        NSLayoutConstraint.activate([
            blueTextField.topAnchor.constraint(equalTo: greenTextField.bottomAnchor, constant: 8),
            blueTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            blueTextField.leadingAnchor.constraint(equalTo: blueLabel.trailingAnchor, constant: 8),
            blueLabel.centerYAnchor.constraint(equalTo: blueTextField.centerYAnchor),
            blueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            blueLabel.widthAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    private func setupHsvLabels() {
        hueLabel = UILabel()
        hueLabel.text = "H:"
        hueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        hueTextField = UITextField()
        hueTextField.tag = 2
        hueTextField.delegate = self
        hueTextField.borderStyle = .roundedRect
        hueTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hueLabel)
        view.addSubview(hueTextField)
        
        NSLayoutConstraint.activate([
            hueTextField.topAnchor.constraint(equalTo: hsvSlider.bottomAnchor, constant: 16),
            hueTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hueTextField.leadingAnchor.constraint(equalTo: hueLabel.trailingAnchor, constant: 8),
            hueLabel.centerYAnchor.constraint(equalTo: hueTextField.centerYAnchor),
            hueLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            hueLabel.widthAnchor.constraint(equalToConstant: 14)
        ])
        
        saturationLabel = UILabel()
        saturationLabel.text = "S:"
        saturationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        saturationTextField = UITextField()
        saturationTextField.tag = 3
        saturationTextField.delegate = self
        saturationTextField.borderStyle = .roundedRect
        saturationTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(saturationLabel)
        view.addSubview(saturationTextField)
        
        NSLayoutConstraint.activate([
            saturationTextField.topAnchor.constraint(equalTo: hueTextField.bottomAnchor, constant: 8),
            saturationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saturationTextField.leadingAnchor.constraint(equalTo: saturationLabel.trailingAnchor, constant: 8),
            saturationLabel.centerYAnchor.constraint(equalTo: saturationTextField.centerYAnchor),
            saturationLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            saturationLabel.widthAnchor.constraint(equalToConstant: 14)
        ])

        brightnessLabel = UILabel()
        brightnessLabel.text = "V:"
        brightnessLabel.translatesAutoresizingMaskIntoConstraints = false
        
        brightnessTextField = UITextField()
        brightnessTextField.tag = 3
        brightnessTextField.delegate = self
        brightnessTextField.borderStyle = .roundedRect
        brightnessTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(brightnessLabel)
        view.addSubview(brightnessTextField)
        
        NSLayoutConstraint.activate([
            brightnessTextField.topAnchor.constraint(equalTo: saturationTextField.bottomAnchor, constant: 8),
            brightnessTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            brightnessTextField.leadingAnchor.constraint(equalTo: brightnessLabel.trailingAnchor, constant: 8),
            brightnessLabel.centerYAnchor.constraint(equalTo: brightnessTextField.centerYAnchor),
            brightnessLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            brightnessLabel.widthAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let _ = textFieldShouldReturn(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            let hexCharacters = CharacterSet(charactersIn: "#0123456789abcdefABCDEF")
            let characterSet = CharacterSet(charactersIn: string)
            
            return hexCharacters.isSuperset(of: characterSet) && updatedText.count <= 7
        } else {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            return allowedCharacters.isSuperset(of: characterSet)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        colourWillChangeDelegateUpdate()
        
        if textField.tag == 0 {
            handleHexTextFieldChange(withTextField: textField)
        } else if textField.tag == 1 {
            handleRgbTextFieldsChange(withTextField: textField)
        } else if textField.tag == 2 {
            handleHueTextFieldChange(withTextField: textField)
        } else if textField.tag == 3 {
            handleSaturationBrightnessTextFieldChange(withTextField: textField)
        }
        
        hsvGradient.updateSaturation(to: saturation, brightnessTo: brightness)
        hsvGradient.updateHue(to: hue)
        hsvSlider.updateHue(to: hue)
        
        colourDidChangeDelegateUpdate()
        
        return true
    }
    
    func handleHexTextFieldChange(withTextField textField: UITextField) {
        guard let text = textField.text?.replacingOccurrences(of: "#", with: "") else {
            return
        }

        if text.count == 6 {
            let red = UInt(text[0] + text[1], radix: 16) ?? 0
            let green = UInt(text[2] + text[3], radix: 16) ?? 0
            let blue = UInt(text[4] + text[5], radix: 16) ?? 0

            let rgb = RGB(
                r: Float(red) / 255,
                g: Float(green) / 255,
                b: Float(blue) / 255
            )

            redTextField.text = String(red)
            greenTextField.text = String(green)
            blueTextField.text = String(blue)

            let hsv = rgb.hsv

            hue = CGFloat(hsv.h)
            saturation = CGFloat(hsv.s)
            brightness = CGFloat(hsv.v)
            
            print(hue, saturation, brightness)

            hueTextField.text = String(Int(Float(hsv.h)))
            saturationTextField.text = String(Int(round(hsv.s * 100)))
            brightnessTextField.text = String(Int(round(hsv.v * 100)))

            textField.text = "#" + (textField.text?.replacingOccurrences(of: "#", with: "").uppercased() ?? "")
        } else {
            let hex = HSV(
                h: Float(hue),
                s: Float(saturation),
                v: Float(brightness)
            ).hex

            textField.text = "#\(hex)"
        }
    }
    
    func handleRgbTextFieldsChange(withTextField textField: UITextField) {
        if let int = Int(textField.text ?? "") {
            if int > 255 {
                textField.text = "255"
            }
        }
        
        let hsv = RGB(
            r: Float((Int(redTextField.text ?? "0") ?? 0)) / 255,
            g: Float(Int(greenTextField.text ?? "0") ?? 0) / 255,
            b: Float(Int(blueTextField.text ?? "0") ?? 0) / 255
        ).hsv
        
        hue = CGFloat(hsv.h)
        saturation = CGFloat(hsv.s)
        brightness = CGFloat(hsv.v)
        
        hueTextField.text = String(Int(round(hsv.h)))
        saturationTextField.text = String(Int(round(hsv.s * 100)))
        brightnessTextField.text = String(Int(round(hsv.v * 100)))
        hexTextField.text = "#" + hsv.hex
    }
    
    func handleHueTextFieldChange(withTextField textField: UITextField) {
        if let int = Int(textField.text ?? "") {
            if int > 360 {
                textField.text = "360"
            }
        }
        
        let hsv = HSV(
            h: Float(Int(hueTextField.text ?? "0") ?? 0),
            s: Float(Int(saturationTextField.text ?? "0") ?? 100) / 100,
            v: Float(Int(brightnessTextField.text ?? "100") ?? 100) / 100
        )
        let rgb = hsv.rgb
        
        hue = CGFloat(rgb.hsv.h)
        saturation = CGFloat(rgb.hsv.s)
        brightness = CGFloat(rgb.hsv.v)
        
        redTextField.text = String(Int(round(rgb.r * 100)))
        greenTextField.text = String(Int(round(rgb.g * 100)))
        blueTextField.text = String(Int(round(rgb.r * 100)))
        hexTextField.text = "#" + rgb.hsv.hex
    }
    
    func handleSaturationBrightnessTextFieldChange(withTextField textField: UITextField) {
        if let int = Int(textField.text ?? "") {
            if int > 100 {
                textField.text = "100"
            }
        }
        
        let hsv = HSV(
            h: Float(Int(hueTextField.text ?? "0") ?? 0),
            s: Float(Int(saturationTextField.text ?? "0") ?? 100) / 100,
            v: Float(Int(brightnessTextField.text ?? "100") ?? 100) / 100
        )
        let rgb = hsv.rgb
        
        hue = CGFloat(rgb.hsv.h)
        saturation = CGFloat(rgb.hsv.s)
        brightness = CGFloat(rgb.hsv.v)
        
        redTextField.text = String(Int(round(rgb.r * 100)))
        greenTextField.text = String(Int(round(rgb.g * 100)))
        blueTextField.text = String(Int(round(rgb.r * 100)))
        hexTextField.text = "#" + rgb.hsv.hex
    }
    
    func updateGradientSliderColours(hue: CGFloat) {
        colourWillChangeDelegateUpdate()
        
        self.hue = hue
        
        hsvGradient.updateHue(to: hue)
        updateTextFields()
        colourDidChangeDelegateUpdate()
    }
    
    func updateGradientSliderColours(saturation: CGFloat, brightness: CGFloat) {
        colourWillChangeDelegateUpdate()
        
        self.saturation = saturation
        self.brightness = brightness
        
        updateTextFields()
        colourDidChangeDelegateUpdate()
    }
    
    private func updateTextFields() {
        let hsv = HSV(h: Float(hue), s: Float(saturation), v: Float(brightness))
        let rgb = hsv.rgb
        let hex = hsv.hex
        
        hexTextField.text = "#" + hex
        
        redTextField.text = String(Int(255 * rgb.r))
        greenTextField.text = String(Int(255 * rgb.g))
        blueTextField.text = String(Int(255 * rgb.b))
        
        hueTextField.text = String(Int(round(hsv.h)))
        saturationTextField.text = String(Int(round(hsv.s * 100)))
        brightnessTextField.text = String(Int(round(hsv.v * 100)))
    }
    
    private func colourDidChangeDelegateUpdate() {
        let colour = HSV(h: Float(hue), s: Float(saturation), v: Float(brightness)).cgColor
        delegate?.colourDidChange(to: colour, source: popoverPresentationController?.sourceView)
        delegate?.colourDidChange(withHue: Float(hue), saturation: Float(saturation), brightness: Float(brightness), source: popoverPresentationController?.sourceView)
    }
    
    private func colourWillChangeDelegateUpdate() {
        delegate?.colourWillChange(forFirstTime: firstEdit, withHue: Float(hue), saturation: Float(saturation), brightness: Float(brightness), source: popoverPresentationController?.sourceView)
        
        if firstEdit {
            firstEdit = false
        }
    }
}
