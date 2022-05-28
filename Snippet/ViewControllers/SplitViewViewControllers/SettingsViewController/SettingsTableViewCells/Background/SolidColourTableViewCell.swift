//
//  SolidColourTableViewCell.swift
//  Snippet
//
//  Created by Seb Vidal on 04/02/2022.
//

import UIKit
import SwiftUI

class SolidColourTableViewCell: UITableViewCell, SettingsTableViewCell, ColourPickerDelegate {
    weak var parent: SettingsViewController?
    var cellHeight: CGFloat = 248
    
    private var presetLabel: UILabel!
    private var presetContainer: UIView!
    
    private var presetButton1: UIButton!
    private var presetButton2: UIButton!
    private var presetButton3: UIButton!
    private var presetButton4: UIButton!
    private var presetButton5: UIButton!
    private var presetButton6: UIButton!
    
    private var colourPicker = ColourPickerViewController()
    private var customLabel: UILabel!
    private var customButton: UIButton!
    private var recentButtons: [UIButton] = []
    private var editButton: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addObservers()
        setupPresetLabel()
        setupPresetContainer()
        setupPresetButtons()
        setupCustomLabel()
        setupEditButton()
        setupRecentButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("UpdateUI"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTintColours), name: Notification.Name("NSSystemColorsDidChangeNotification"), object: nil)
    }
    
    private func setupPresetLabel() {
        presetLabel = UILabel()
        presetLabel.text = "Presets:"
        presetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(presetLabel)
        
        NSLayoutConstraint.activate([
            presetLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            presetLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19)
        ])
    }
    
    private func setupPresetContainer() {
        presetContainer = UIView()
        presetContainer.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(presetContainer)
        
        NSLayoutConstraint.activate([
            presetContainer.topAnchor.constraint(equalTo: presetLabel.bottomAnchor, constant: 10),
            presetContainer.leadingAnchor.constraint(equalTo: presetLabel.leadingAnchor),
            presetContainer.widthAnchor.constraint(equalToConstant: 284),
            presetContainer.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setupPresetButtons() {
        presetButton1 = UIButton()
        presetButton1.setImage(CGColor.preset1.imageRepresentation, for: .normal)
        presetButton1.addTarget(self, action: #selector(presetButtonTapped(_:)), for: .touchUpInside)
        presetButton1.layer.cornerCurve = .continuous
        presetButton1.layer.cornerRadius = 5
        presetButton1.layer.borderWidth = CacheManager.shared.preferredPresetSolidColour == 0 ? 2 : 1
        presetButton1.layer.borderColor = CacheManager.shared.preferredPresetSolidColour == 0 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        presetButton1.clipsToBounds = true
        presetButton1.tag = 1
        presetButton1.translatesAutoresizingMaskIntoConstraints = false
        presetButton1.toolTip = "Preset Green"
        
        presetContainer.addSubview(presetButton1)
        
        NSLayoutConstraint.activate([
            presetButton1.topAnchor.constraint(equalTo: presetContainer.topAnchor),
            presetButton1.leadingAnchor.constraint(equalTo: presetContainer.leadingAnchor),
            presetButton1.widthAnchor.constraint(equalTo: presetContainer.widthAnchor, multiplier: 0.333, constant: -10),
            presetButton1.heightAnchor.constraint(equalToConstant: 57)
        ])
        
        presetButton2 = UIButton()
        presetButton2.setImage(CGColor.preset2.imageRepresentation, for: .normal)
        presetButton2.addTarget(self, action: #selector(presetButtonTapped(_:)), for: .touchUpInside)
        presetButton2.layer.cornerCurve = .continuous
        presetButton2.layer.cornerRadius = 5
        presetButton2.layer.borderWidth = CacheManager.shared.preferredPresetSolidColour == 1 ? 2 : 1
        presetButton2.layer.borderColor = CacheManager.shared.preferredPresetSolidColour == 1 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        presetButton2.clipsToBounds = true
        presetButton2.tag = 2
        presetButton2.translatesAutoresizingMaskIntoConstraints = false
        presetButton2.toolTip = "Preset Red"
        
        presetContainer.addSubview(presetButton2)
        
        NSLayoutConstraint.activate([
            presetButton2.topAnchor.constraint(equalTo: presetContainer.topAnchor),
            presetButton2.leadingAnchor.constraint(equalTo: presetButton1.trailingAnchor, constant: 15),
            presetButton2.widthAnchor.constraint(equalTo: presetContainer.widthAnchor, multiplier: 0.333, constant: -10),
            presetButton2.heightAnchor.constraint(equalToConstant: 57)
        ])
        
        presetButton3 = UIButton()
        presetButton3.setImage(CGColor.preset3.imageRepresentation, for: .normal)
        presetButton3.addTarget(self, action: #selector(presetButtonTapped(_:)), for: .touchUpInside)
        presetButton3.layer.cornerCurve = .continuous
        presetButton3.layer.cornerRadius = 5
        presetButton3.layer.borderWidth = CacheManager.shared.preferredPresetSolidColour == 2 ? 2 : 1
        presetButton3.layer.borderColor = CacheManager.shared.preferredPresetSolidColour == 2 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        presetButton3.clipsToBounds = true
        presetButton3.tag = 3
        presetButton3.translatesAutoresizingMaskIntoConstraints = false
        presetButton3.toolTip = "Preset Purple"
        
        presetContainer.addSubview(presetButton3)
        
        NSLayoutConstraint.activate([
            presetButton3.topAnchor.constraint(equalTo: presetContainer.topAnchor),
            presetButton3.leadingAnchor.constraint(equalTo: presetButton2.trailingAnchor, constant: 15),
            presetButton3.widthAnchor.constraint(equalTo: presetContainer.widthAnchor, multiplier: 0.333, constant: -10),
            presetButton3.heightAnchor.constraint(equalToConstant: 57)
        ])
        
        presetButton4 = UIButton()
        presetButton4.setImage(CGColor.preset4.imageRepresentation, for: .normal)
        presetButton4.addTarget(self, action: #selector(presetButtonTapped(_:)), for: .touchUpInside)
        presetButton4.layer.cornerCurve = .continuous
        presetButton4.layer.cornerRadius = 5
        presetButton4.layer.borderWidth = CacheManager.shared.preferredPresetSolidColour == 3 ? 2 : 1
        presetButton4.layer.borderColor = CacheManager.shared.preferredPresetSolidColour == 3 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        presetButton4.clipsToBounds = true
        presetButton4.tag = 4
        presetButton4.translatesAutoresizingMaskIntoConstraints = false
        presetButton4.toolTip = "Preset Yellow"
        
        presetContainer.addSubview(presetButton4)
        
        NSLayoutConstraint.activate([
            presetButton4.topAnchor.constraint(equalTo: presetButton1.bottomAnchor, constant: 15),
            presetButton4.leadingAnchor.constraint(equalTo: presetButton1.leadingAnchor),
            presetButton4.widthAnchor.constraint(equalTo: presetContainer.widthAnchor, multiplier: 0.333, constant: -10),
            presetButton4.heightAnchor.constraint(equalToConstant: 57)
        ])
        
        presetButton5 = UIButton()
        presetButton5.setImage(CGColor.preset5.imageRepresentation, for: .normal)
        presetButton5.addTarget(self, action: #selector(presetButtonTapped(_:)), for: .touchUpInside)
        presetButton5.layer.cornerCurve = .continuous
        presetButton5.layer.cornerRadius = 5
        presetButton5.layer.borderWidth = CacheManager.shared.preferredPresetSolidColour == 4 ? 2 : 1
        presetButton5.layer.borderColor = CacheManager.shared.preferredPresetSolidColour == 4 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        presetButton5.clipsToBounds = true
        presetButton5.tag = 5
        presetButton5.translatesAutoresizingMaskIntoConstraints = false
        presetButton5.toolTip = "Preset Orange"
        
        presetContainer.addSubview(presetButton5)
        
        NSLayoutConstraint.activate([
            presetButton5.topAnchor.constraint(equalTo: presetButton1.bottomAnchor, constant: 15),
            presetButton5.leadingAnchor.constraint(equalTo: presetButton4.trailingAnchor, constant: 15),
            presetButton5.widthAnchor.constraint(equalTo: presetContainer.widthAnchor, multiplier: 0.333, constant: -10),
            presetButton5.heightAnchor.constraint(equalToConstant: 57)
        ])
        
        presetButton6 = UIButton()
        presetButton6.setImage(CGColor.preset6.imageRepresentation, for: .normal)
        presetButton6.addTarget(self, action: #selector(presetButtonTapped(_:)), for: .touchUpInside)
        presetButton6.layer.cornerCurve = .continuous
        presetButton6.layer.cornerRadius = 5
        presetButton6.layer.borderWidth = CacheManager.shared.preferredPresetSolidColour == 5 ? 2 : 1
        presetButton6.layer.borderColor = CacheManager.shared.preferredPresetSolidColour == 5 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        presetButton6.clipsToBounds = true
        presetButton6.tag = 6
        presetButton6.translatesAutoresizingMaskIntoConstraints = false
        presetButton6.toolTip = "Preset Blue"
        
        presetContainer.addSubview(presetButton6)
        
        NSLayoutConstraint.activate([
            presetButton6.topAnchor.constraint(equalTo: presetButton1.bottomAnchor, constant: 15),
            presetButton6.leadingAnchor.constraint(equalTo: presetButton5.trailingAnchor, constant: 15),
            presetButton6.widthAnchor.constraint(equalTo: presetContainer.widthAnchor, multiplier: 0.333, constant: -10),
            presetButton6.heightAnchor.constraint(equalToConstant: 57)
        ])
    }
    
    private func updatePresetButtonBorders() {
        let buttons: [UIButton] = [
            presetButton1,
            presetButton2,
            presetButton3,
            presetButton4,
            presetButton5,
            presetButton6
        ]
        
        for button in buttons {
            if button.layer.borderWidth == 2 {
                button.layer.borderColor = UIColor.systemTint.cgColor
            } else {
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor(named: "Border")?.cgColor
            }
        }
    }
    
    @objc func presetButtonTapped(_ sender: UIButton) {
        let buttons: [UIButton] = [presetButton1, presetButton2, presetButton3, presetButton4, presetButton5, presetButton6, customButton]
        let colours = CGColor.presets
        
        for button in buttons {
            button.layer.borderColor = UIColor(named: "Border")?.cgColor
            button.layer.borderWidth = 1
        }
        
        sender.layer.borderColor = UIColor.systemTint.cgColor
        sender.layer.borderWidth = 2
        
        parent?.updateBackground(to: .solid(colour: colours[sender.tag - 1]))
        CacheManager.shared.setPreferredPresetSolidColour(to: sender.tag - 1)
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updatePresetButtonBorders()
            
            if customButton.layer.borderWidth == 1 {
                customButton.layer.borderColor = UIColor(named: "Border")?.cgColor
            } else {
                customButton.layer.borderColor = UIColor.systemTint.cgColor
            }
            
            for button in recentButtons {
                button.layer.borderColor = UIColor(named: "Border")!.cgColor
            }
        }
    }
    
    private func setupCustomLabel() {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "Divider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: presetButton4.bottomAnchor, constant: 12),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        customLabel = UILabel()
        customLabel.text = "Custom:"
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(customLabel)
        
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: presetLabel.leadingAnchor),
            customLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10)
        ])
    }
    
    private func setupEditButton() {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(editButtonTapped(_:)))
        tapGesture.minimumPressDuration = 0
        
        editButton = UIImageView()
        editButton.image = UIImage(named: "Test")
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addGestureRecognizer(tapGesture)
        editButton.isUserInteractionEnabled = true

        addSubview(editButton)

        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: customLabel.topAnchor),
            editButton.leadingAnchor.constraint(equalTo: customLabel.leadingAnchor, constant: -2),
            editButton.widthAnchor.constraint(equalToConstant: 63.5),
            editButton.heightAnchor.constraint(equalToConstant: 49.5)
        ])
        
        bringSubviewToFront(editButton)
        
        let hsv = CacheManager.shared.preferredCustomSolidHSV
        let rgb = HSV(h: hsv[0], s: hsv[1], v: hsv[2]).rgb
        let colour = UIColor(displayP3Red: CGFloat(rgb.r), green: CGFloat(rgb.g), blue: CGFloat(rgb.b), alpha: 1)
        
        customButton = UIButton()
        customButton.setImage(colour.imageRepresentation, for: .normal)
        customButton.layer.cornerCurve = .continuous
        customButton.layer.cornerRadius = 3.5
        customButton.layer.borderWidth = CacheManager.shared.preferredPresetSolidColour == 6 ? 2: 1
        customButton.layer.borderColor = CacheManager.shared.preferredPresetSolidColour == 6 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        customButton.clipsToBounds = true
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        customButton.toolTip = "Custom Colour"
        customButton.addInteraction(UIToolTipInteraction(defaultToolTip: "Edit Custom Colour"))
        
        addSubview(customButton)
        
        NSLayoutConstraint.activate([
            customButton.topAnchor.constraint(equalTo: editButton.topAnchor, constant: 5),
            customButton.leadingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: 5),
            customButton.bottomAnchor.constraint(equalTo: editButton.bottomAnchor, constant: -5),
            customButton.widthAnchor.constraint(equalTo: customButton.heightAnchor)
        ])
    }
    
    @objc private func editButtonTapped(_ tapGesture: UILongPressGestureRecognizer) {
        switch tapGesture.state {
        case .began:
            editButton.image = UIImage(named: "Test-1")
        case .ended:
            editButton.image = UIImage(named: "Test")
            showColourPicker(editButton)
        case .possible:
            break
        case .changed:
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
    
    @objc func customButtonTapped() {
        guard let parent = parent else {
            return
        }
        
        let presetButtons = [presetButton1, presetButton2, presetButton3, presetButton4, presetButton5, presetButton6]
        for presetButton in presetButtons {
            presetButton?.layer.borderWidth = 1
            presetButton?.layer.borderColor = UIColor(named: "Border")?.cgColor
        }
        
        customButton.layer.borderWidth = 2
        customButton.layer.borderColor = UIColor.systemTint.cgColor
        
        let colour = CacheManager.shared.preferredCustomSolidColour
        parent.updateBackground(to: .solid(colour: colour))
        CacheManager.shared.setPreferredPresetSolidColour(to: 6)
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    private func showColourPicker(_ sender: UIImageView) {
        let components = CacheManager.shared.preferredCustomSolidHSV
        
        colourPicker = ColourPickerViewController()
        colourPicker.delegate = self
        colourPicker.hue = CGFloat(components[0])
        colourPicker.saturation = CGFloat(components[1])
        colourPicker.brightness = CGFloat(components[2])
        colourPicker.modalPresentationStyle = .popover
        colourPicker.popoverPresentationController?.permittedArrowDirections = .up
        colourPicker.preferredContentSize = CGSize(width: 282, height: 448)
        colourPicker.popoverPresentationController?.sourceView = sender
        
        parent?.present(colourPicker, animated: true)
    }
    
    func colourWillChange(forFirstTime firstTime: Bool, withHue hue: Float, saturation: Float, brightness: Float, source: UIView?) {
        if firstTime {
            let hsv = HSV(h: hue, s: saturation, v: brightness)
            let cgColor = hsv.cgColor
            
            if let components = cgColor.components {
                let red = Float(components[0])
                let green = Float(components[1])
                let blue = Float(components[2])
                
                CacheManager.shared.addRecentColour(withComponents: [red, green, blue])
                updateRecentButtons()
            }
        }
    }

    func colourDidChange(withHue hue: Float, saturation: Float, brightness: Float, source: UIView?) {
        let hsv = HSV(h: hue, s: saturation, v: brightness)
        CacheManager.shared.setPreferredCustomSolidHSV(to: hsv)
        CacheManager.shared.setPreferredPresetSolidColour(to: 6)
        updateCustomButton(with: hsv.cgColor)
        customButtonTapped()
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    private func setupRecentButtons() {
        let recentButtonContainer = UIView()
        recentButtonContainer.translatesAutoresizingMaskIntoConstraints = false

        addSubview(recentButtonContainer)

        NSLayoutConstraint.activate([
            recentButtonContainer.topAnchor.constraint(equalTo: customLabel.topAnchor, constant: 2),
            recentButtonContainer.leadingAnchor.constraint(equalTo: customButton.trailingAnchor, constant: 27),
            recentButtonContainer.bottomAnchor.constraint(equalTo: customButton.bottomAnchor),
            recentButtonContainer.widthAnchor.constraint(equalToConstant: 240)
        ])

        for row in 0...1 {
            for column in 0...7 {
                let button = UIButton()
                button.frame = CGRect(x: 27.5 * Double(column), y: 26 * Double(row), width: 20, height: 20)
                button.setImage(UIColor.clear.imageRepresentation, for: .normal)
                button.layer.cornerCurve = .continuous
                button.layer.cornerRadius = 3.5
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor(named: "Border")?.cgColor
                button.layer.masksToBounds = true
                button.addTarget(self, action: #selector(recentTapped(_:)), for: .touchUpInside)
                button.toolTip = "Recent Colour"

                recentButtonContainer.addSubview(button)
                recentButtons.append(button)
            }
        }
        
        updateRecentButtons()
    }
    
    @objc private func recentTapped(_ sender: UIButton) {
        guard sender.image(for: .normal) != nil else {
            return
        }

        guard let currentComponents = CacheManager.shared.preferredCustomSolidColour.components else {
            return
        }
        
        let currentComponentFloats = [Float(currentComponents[0]), Float(currentComponents[1]), Float(currentComponents[2])]
        
        guard let index = recentButtons.firstIndex(of: sender) else {
            return
        }
        
        if CacheManager.shared.recentColours.indices.contains(index) {
            let components = CacheManager.shared.recentColours[index]
            let red = CGFloat(components[0])
            let green = CGFloat(components[1])
            let blue = CGFloat(components[2])
            let recent = UIColor(displayP3Red: red, green: green, blue: blue, alpha: 1)
            let hsv = RGB(r: components[0], g: components[1], b: components[2]).hsv
            
            CacheManager.shared.setPreferredCustomSolidHSV(to: hsv)
            CacheManager.shared.setPreferredPresetSolidColour(to: 6)
            updateCustomButton(with: recent.cgColor)
            parent?.updateBackground(to: .solid(colour: recent.cgColor))
            
            CacheManager.shared.addRecentColour(withComponents: currentComponentFloats)
            
            updateRecentButtons()
        }
        
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    private func updateRecentButtons() {
        let recentColours = CacheManager.shared.recentColours
        
        if recentColours.count == 0 {
            return
        }

        for (index, recentButton) in recentButtons[0...recentColours.count - 1].enumerated() {
            let components = recentColours[index]
            let red = CGFloat(components[0])
            let green = CGFloat(components[1])
            let blue = CGFloat(components[2])
            
            let colour = UIColor(displayP3Red: red, green: green, blue: blue, alpha: 1)
            
            recentButton.setImage(colour.imageRepresentation, for: .normal)
        }
    }
    
    func updateCustomButton(with colour: CGColor) {
        customButton.setImage(UIColor(cgColor: colour).imageRepresentation, for: .normal)
        parent?.updateBackground(to: .solid(colour: colour))
    }
    
    @objc private func updateUI() {
        guard PresetManager.shared.selectedPreset["backgroundType"] as? Int == 1 else {
            return
        }
        
        let presetButtons = [presetButton1, presetButton2, presetButton3, presetButton4, presetButton5, presetButton6]
        
        if let value = PresetManager.shared.selectedPreset["backgroundValue"] as? Int {
            if presetButtons.indices.contains(value) {
                for (index, button) in presetButtons.enumerated() {
                    button?.layer.borderColor = index == value ? UIColor.systemTint.cgColor : UIColor(named: "Border")?.cgColor
                    button?.layer.borderWidth = index == value ? 2 : 1
                }
            }
        } else if let _ = PresetManager.shared.selectedPreset["backgroundValue"] as? [Float] {
            updateCustomButton(with: CacheManager.shared.preferredCustomSolidColour)
            customButton.layer.borderWidth = 2
            customButton.layer.borderColor = UIColor.systemTint.cgColor
            
            for presetButton in presetButtons {
                presetButton?.layer.borderWidth = 1
                presetButton?.layer.borderColor = UIColor(named: "Border")?.cgColor
            }
        }
    }
    
    @objc func updateTintColours() {
        if customButton.layer.borderWidth == 2 {
            customButton.layer.borderColor = UIColor.systemTint.cgColor
        }
        
        updatePresetButtonBorders()
    }
}
