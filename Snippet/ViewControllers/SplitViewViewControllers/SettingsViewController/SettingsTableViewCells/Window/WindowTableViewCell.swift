//
//  WindowTableViewCell.swift
//  Snippet
//
//  Created by Seb Vidal on 30/01/2022.
//

import UIKit
import AppKit

class WindowTableViewCell: UITableViewCell, UITextFieldDelegate, SettingsTableViewCell {
    weak var parent: SettingsViewController?
    var cellHeight: CGFloat = 597
    
    private var cellHeading: UILabel!
    
    private var titleLabel: UILabel!
    private var titleTextField: UITextField!
    private var showIconSwitch: UISwitch!
    
    private var appearanceLabel: UILabel!
    private var containerView: UIView!
    private var automaticAppearanceButton: UIButton!
    private var lightAppearanceButton: UIButton!
    private var darkAppearanceButton: UIButton!
    private var automaticLabel: UILabel!
    private var lightLabel: UILabel!
    private var darkLabel: UILabel!
    
    private var controlsLabel: UILabel!
    private var controlsContainerView: UIView!
    private var noneControlsButton: UIButton!
    private var colourfulControlsButton: UIButton!
    private var graphiteControlsButton: UIButton!
    private var noneLabel: UILabel!
    private var colourfulLabel: UILabel!
    private var graphiteLabel: UILabel!
    private var controlsSymbolsSwitch: UISwitch!
    
    private var opacityLabel: UILabel!
    private var opacitySlider: UISlider!
    private var opacityMinButton: UIButton!
    private var opacityMaxButton: UIButton!
    
    private var horizontalLabel: UILabel!
    private var verticalLabel: UILabel!
    private var horizontalPaddingSegmentedControl: UISegmentedControl!
    private var verticalPaddingSegmentedControl: UISegmentedControl!
    
    private var linkImageView: UIImageView!
    private var linkSwitch: UISwitch!
    
    private var windowModeLabel: UILabel!
    private var automaticWindowModeButton: UIButton!
    private var fitWindowModeButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addObservers()
        setupCellHeading()
        setupTitleTextView()
        setupShowIconSwitch()
        setupAppearance()
        setupAppearanceLabels()
        setupControls()
        setupControlsLabels()
        setupShowControlsSymbols()
        setupOpacityLabel()
        setupPadding()
        setupPaddingLinkButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColours()
        }
    }

    private func updateColours() {
        let buttons: [UIButton] = [
            automaticAppearanceButton,
            lightAppearanceButton,
            darkAppearanceButton,

            colourfulControlsButton,
            graphiteControlsButton,
            noneControlsButton
        ]
        
        for button in buttons {
            if button.layer.borderWidth == 2 {
                button.layer.borderColor = UIColor.systemTint.cgColor
            } else {
                button.layer.borderColor = UIColor(named: "Border")?.cgColor
            }
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("UpdateUI"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTintColours), name: Notification.Name("NSSystemColorsDidChangeNotification"), object: nil)
    }
    
    private func setupCellHeading() {
        cellHeading = UILabel()
        cellHeading.text = "Window"
        cellHeading.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        cellHeading.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cellHeading)
        
        NSLayoutConstraint.activate([
            cellHeading.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            cellHeading.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }

    private func setupTitleTextView() {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "Divider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: cellHeading.bottomAnchor, constant: 12),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        titleLabel = UILabel()
        titleLabel.text = "Title:"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: cellHeading.leadingAnchor, constant: 2)
        ])
        
        titleTextField = UITextField()
        titleTextField.toolTip = "Window Title"
        titleTextField.delegate = self
        titleTextField.borderStyle = .roundedRect
        titleTextField.text = CacheManager.shared.preferredTitle
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleTextField.widthAnchor.constraint(equalToConstant: 286)
        ])
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        parent?.canvas?.setWindowTitleText(to: textField.text)
        CacheManager.shared.setPreferredTitle(to: textField.text)
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    private func setupShowIconSwitch() {
        showIconSwitch = UISwitch()
        showIconSwitch.isOn = CacheManager.shared.prefersIconVisible
        showIconSwitch.title = "Show Icon"
        showIconSwitch.toolTip = "Show Window Icon"
        showIconSwitch.addTarget(self, action: #selector(iconSwitchChanged(_:)), for: .valueChanged)
        showIconSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(showIconSwitch)
        
        NSLayoutConstraint.activate([
            showIconSwitch.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            showIconSwitch.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor)
        ])
    }
    
    @objc func iconSwitchChanged(_ sender: UISwitch) {
        parent?.canvas?.toggleIcon(on: sender.isOn)
        CacheManager.shared.setPreferredIconVisibility(to: sender.isOn)
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    private func setupAppearance() {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "Divider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: showIconSwitch.bottomAnchor, constant: 14),
            divider.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        appearanceLabel = UILabel()
        appearanceLabel.text = "Appearance:"
        appearanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(appearanceLabel)
        
        NSLayoutConstraint.activate([
            appearanceLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            appearanceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: appearanceLabel.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: appearanceLabel.bottomAnchor, constant: 10),
            containerView.heightAnchor.constraint(equalToConstant: (254 / 3) / 1.49),
            containerView.widthAnchor.constraint(equalToConstant: 286)
        ])
        
        setupAutomaticAppearanceButton()
        setupLightAppearanceButton()
        setupDarkAppearanceButton()
    }
    
    private func setupAutomaticAppearanceButton() {
        let appearance = CacheManager.shared.preferredAppearance
        let image = UIImage(named: "Automatic")
        automaticAppearanceButton = UIButton()
        automaticAppearanceButton.toolTip = "Automatic Appearance"
        automaticAppearanceButton.addTarget(self, action: #selector(appearanceTapped(_:)), for: .touchUpInside)
        automaticAppearanceButton.setImage(image, for: .normal)
        automaticAppearanceButton.clipsToBounds = true
        automaticAppearanceButton.layer.cornerCurve = .continuous
        automaticAppearanceButton.layer.cornerRadius = 5
        automaticAppearanceButton.layer.borderColor = appearance == 0 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        automaticAppearanceButton.layer.borderWidth = appearance == 0 ? 2 : 1
        automaticAppearanceButton.tag = 0
        automaticAppearanceButton.isUserInteractionEnabled = true
        automaticAppearanceButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(automaticAppearanceButton)
        
        NSLayoutConstraint.activate([
            automaticAppearanceButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            automaticAppearanceButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            automaticAppearanceButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.333, constant: -10),
            automaticAppearanceButton.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
    
    private func setupLightAppearanceButton() {
        let appearance = CacheManager.shared.preferredAppearance
        let image = UIImage(named: "Light")
        lightAppearanceButton = UIButton()
        lightAppearanceButton.toolTip = "Light Appearance"
        lightAppearanceButton.addTarget(self, action: #selector(appearanceTapped(_:)), for: .touchUpInside)
        lightAppearanceButton.setImage(image, for: .normal)
        lightAppearanceButton.clipsToBounds = true
        lightAppearanceButton.layer.cornerCurve = .continuous
        lightAppearanceButton.layer.cornerRadius = 5
        lightAppearanceButton.layer.borderColor = appearance == 1 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        lightAppearanceButton.layer.borderWidth = appearance == 1 ? 2 : 1
        lightAppearanceButton.tag = 1
        lightAppearanceButton.isUserInteractionEnabled = true
        lightAppearanceButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(lightAppearanceButton)
        
        NSLayoutConstraint.activate([
            lightAppearanceButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            lightAppearanceButton.leadingAnchor.constraint(equalTo: automaticAppearanceButton.trailingAnchor, constant: 15),
            lightAppearanceButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.333, constant: -10),
            lightAppearanceButton.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
    
    private func setupDarkAppearanceButton() {
        let appearance = CacheManager.shared.preferredAppearance
        let image = UIImage(named: "Dark")
        darkAppearanceButton = UIButton()
        darkAppearanceButton.toolTip = "Dark Appearance"
        darkAppearanceButton.addTarget(self, action: #selector(appearanceTapped(_:)), for: .touchUpInside)
        darkAppearanceButton.setImage(image, for: .normal)
        darkAppearanceButton.clipsToBounds = true
        darkAppearanceButton.layer.cornerCurve = .continuous
        darkAppearanceButton.layer.cornerRadius = 5
        darkAppearanceButton.layer.borderColor = appearance == 2 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        darkAppearanceButton.layer.borderWidth = appearance == 2 ? 2 : 1
        darkAppearanceButton.tag = 2
        darkAppearanceButton.isUserInteractionEnabled = true
        darkAppearanceButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(darkAppearanceButton)

        NSLayoutConstraint.activate([
            darkAppearanceButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            darkAppearanceButton.leadingAnchor.constraint(equalTo: lightAppearanceButton.trailingAnchor, constant: 15),
            darkAppearanceButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.333, constant: -10),
            darkAppearanceButton.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
    
    @objc private func appearanceTapped(_ sender: UIButton) {
        CacheManager.shared.setPreferredAppearance(to: sender.tag)
        updateAppearanceButtons()
        
        switch sender.tag {
        case 0:
            parent?.canvas?.updateAppearance(to: .unspecified)
        case 1:
            parent?.canvas?.updateAppearance(to: .light)
        case 2:
            parent?.canvas?.updateAppearance(to: .dark)
        default:
            break
        }
        
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    private func updateAppearanceButtons() {
        let buttons: [UIButton] = [
            automaticAppearanceButton,
            lightAppearanceButton,
            darkAppearanceButton
        ]
        
        let scheme = CacheManager.shared.preferredAppearance
        for button in buttons {
            button.layer.borderColor = scheme == button.tag ? UIColor.systemTint.cgColor : UIColor(named: "Border")?.cgColor
            button.layer.borderWidth = scheme == button.tag ? 2 : 1
        }
    }
    
    private func setupAppearanceLabels() {
        automaticLabel = UILabel()
        automaticLabel.text = "Automatic"
        automaticLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(automaticLabel)
        
        NSLayoutConstraint.activate([
            automaticLabel.topAnchor.constraint(equalTo: automaticAppearanceButton.bottomAnchor, constant: 8),
            automaticLabel.centerXAnchor.constraint(equalTo: automaticAppearanceButton.centerXAnchor)
        ])
        
        lightLabel = UILabel()
        lightLabel.text = "Light"
        lightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lightLabel)
        
        NSLayoutConstraint.activate([
            lightLabel.topAnchor.constraint(equalTo: lightAppearanceButton.bottomAnchor, constant: 8),
            lightLabel.centerXAnchor.constraint(equalTo: lightAppearanceButton.centerXAnchor)
        ])
        
        darkLabel = UILabel()
        darkLabel.text = "Dark"
        darkLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(darkLabel)
        
        NSLayoutConstraint.activate([
            darkLabel.topAnchor.constraint(equalTo: darkAppearanceButton.bottomAnchor, constant: 8),
            darkLabel.centerXAnchor.constraint(equalTo: darkAppearanceButton.centerXAnchor)
        ])
    }
    
    private func setupControls() {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "Divider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: automaticLabel.bottomAnchor, constant: 10),
            divider.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        controlsLabel = UILabel()
        controlsLabel.text = "Controls:"
        controlsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(controlsLabel)
        
        NSLayoutConstraint.activate([
            controlsLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            controlsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
        
        controlsContainerView = UIView()
        controlsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(controlsContainerView)
        
        NSLayoutConstraint.activate([
            controlsContainerView.leadingAnchor.constraint(equalTo: controlsLabel.leadingAnchor),
            controlsContainerView.topAnchor.constraint(equalTo: controlsLabel.bottomAnchor, constant: 10),
            controlsContainerView.heightAnchor.constraint(equalToConstant: (254 / 3) / 1.49),
            controlsContainerView.widthAnchor.constraint(equalToConstant: 286)
        ])
        
        setupColourfulButton()
        setupGraphiteButton()
        setupNoneButton()
    }
    
    private func setupColourfulButton() {
        let controls = CacheManager.shared.preferredControlsStyle
        let image = UIImage(named: "ColourfulControls")
        colourfulControlsButton = UIButton()
        colourfulControlsButton.toolTip = "Multicolour Window Controls"
        colourfulControlsButton.addTarget(self, action: #selector(controlsTapped(_:)), for: .touchUpInside)
        colourfulControlsButton.setImage(image, for: .normal)
        colourfulControlsButton.clipsToBounds = true
        colourfulControlsButton.layer.cornerCurve = .continuous
        colourfulControlsButton.layer.cornerRadius = 5
        colourfulControlsButton.layer.borderColor = controls == 0 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        colourfulControlsButton.layer.borderWidth = controls == 0 ? 2 : 1
        colourfulControlsButton.tag = 0
        colourfulControlsButton.isUserInteractionEnabled = true
        colourfulControlsButton.translatesAutoresizingMaskIntoConstraints = false
        
        controlsContainerView.addSubview(colourfulControlsButton)
        
        NSLayoutConstraint.activate([
            colourfulControlsButton.topAnchor.constraint(equalTo: controlsContainerView.topAnchor),
            colourfulControlsButton.leadingAnchor.constraint(equalTo: controlsContainerView.leadingAnchor),
            colourfulControlsButton.widthAnchor.constraint(equalTo: controlsContainerView.widthAnchor, multiplier: 0.333, constant: -10),
            colourfulControlsButton.heightAnchor.constraint(equalTo: controlsContainerView.heightAnchor)
        ])
    }
    
    private func setupGraphiteButton() {
        let controls = CacheManager.shared.preferredControlsStyle
        let image = UIImage(named: "GraphiteControls")
        graphiteControlsButton = UIButton()
        graphiteControlsButton.toolTip = "Graphite Window Controls"
        graphiteControlsButton.addTarget(self, action: #selector(controlsTapped(_:)), for: .touchUpInside)
        graphiteControlsButton.setImage(image, for: .normal)
        graphiteControlsButton.clipsToBounds = true
        graphiteControlsButton.layer.cornerCurve = .continuous
        graphiteControlsButton.layer.cornerRadius = 5
        graphiteControlsButton.layer.borderColor = controls == 1 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        graphiteControlsButton.layer.borderWidth = controls == 1 ? 2 : 1
        graphiteControlsButton.tag = 1
        graphiteControlsButton.isUserInteractionEnabled = true
        graphiteControlsButton.translatesAutoresizingMaskIntoConstraints = false
        
        controlsContainerView.addSubview(graphiteControlsButton)
        
        NSLayoutConstraint.activate([
            graphiteControlsButton.topAnchor.constraint(equalTo: controlsContainerView.topAnchor),
            graphiteControlsButton.leadingAnchor.constraint(equalTo: colourfulControlsButton.trailingAnchor, constant: 15),
            graphiteControlsButton.widthAnchor.constraint(equalTo: controlsContainerView.widthAnchor, multiplier: 0.333, constant: -10),
            graphiteControlsButton.heightAnchor.constraint(equalTo: controlsContainerView.heightAnchor)
        ])
    }
    
    private func setupNoneButton() {
        let controls = CacheManager.shared.preferredControlsStyle
        let image = UIImage(named: "NoneControls")
        noneControlsButton = UIButton()
        noneControlsButton.toolTip = "No Window Controls"
        noneControlsButton.addTarget(self, action: #selector(controlsTapped(_:)), for: .touchUpInside)
        noneControlsButton.setImage(image, for: .normal)
        noneControlsButton.clipsToBounds = true
        noneControlsButton.layer.cornerCurve = .continuous
        noneControlsButton.layer.cornerRadius = 5
        noneControlsButton.layer.borderColor = controls == 2 ? UIColor.systemTint.cgColor : UIColor(named: "Border")!.cgColor
        noneControlsButton.layer.borderWidth = controls == 2 ? 2 : 1
        noneControlsButton.tag = 2
        noneControlsButton.isUserInteractionEnabled = true
        noneControlsButton.translatesAutoresizingMaskIntoConstraints = false
        
        controlsContainerView.addSubview(noneControlsButton)
        
        NSLayoutConstraint.activate([
            noneControlsButton.topAnchor.constraint(equalTo: controlsContainerView.topAnchor),
            noneControlsButton.leadingAnchor.constraint(equalTo: graphiteControlsButton.trailingAnchor, constant: 15),
            noneControlsButton.widthAnchor.constraint(equalTo: controlsContainerView.widthAnchor, multiplier: 0.333, constant: -10),
            noneControlsButton.heightAnchor.constraint(equalTo: controlsContainerView.heightAnchor)
        ])
    }
    
    private func setupControlsLabels() {
        colourfulLabel = UILabel()
        colourfulLabel.text = "Multicolour"
        colourfulLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(colourfulLabel)
        
        NSLayoutConstraint.activate([
            colourfulLabel.topAnchor.constraint(equalTo: colourfulControlsButton.bottomAnchor, constant: 8),
            colourfulLabel.centerXAnchor.constraint(equalTo: colourfulControlsButton.centerXAnchor)
        ])
        
        graphiteLabel = UILabel()
        graphiteLabel.text = "Graphite"
        graphiteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(graphiteLabel)
        
        NSLayoutConstraint.activate([
            graphiteLabel.topAnchor.constraint(equalTo: graphiteControlsButton.bottomAnchor, constant: 8),
            graphiteLabel.centerXAnchor.constraint(equalTo: graphiteControlsButton.centerXAnchor)
        ])
        
        noneLabel = UILabel()
        noneLabel.text = "None"
        noneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(noneLabel)
        
        NSLayoutConstraint.activate([
            noneLabel.topAnchor.constraint(equalTo: noneControlsButton.bottomAnchor, constant: 8),
            noneLabel.centerXAnchor.constraint(equalTo: noneControlsButton.centerXAnchor)
        ])
    }
    
    @objc private func controlsTapped(_ sender: UIButton) {
        CacheManager.shared.setPreferredControlStyle(to: sender.tag)
        updateControlsButtons()
        
        switch sender.tag {
        case 0:
            parent?.canvas?.updateWindowControls(with: .colourful)
        case 1:
            parent?.canvas?.updateWindowControls(with: .graphite)
        case 2:
            parent?.canvas?.updateWindowControls(with: .none)
        default:
            break
        }
        
        parent?.canvas?.updateWindowControlsSymbols()
        
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    private func updateControlsButtons() {
        let buttons: [UIButton] = [
            colourfulControlsButton,
            graphiteControlsButton,
            noneControlsButton
        ]
        
        let controls = CacheManager.shared.preferredControlsStyle
        for button in buttons {
            button.layer.borderColor = controls == button.tag ? UIColor.systemTint.cgColor : UIColor(named: "Border")?.cgColor
            button.layer.borderWidth = controls == button.tag ? 2 : 1
        }
    }
    
    private func setupShowControlsSymbols() {
        controlsSymbolsSwitch = UISwitch()
        controlsSymbolsSwitch.title = "Show Controls Symbols"
        controlsSymbolsSwitch.toolTip = "Show Window Controls Symbols"
        controlsSymbolsSwitch.isOn = CacheManager.shared.showControlsSymbols
        controlsSymbolsSwitch.translatesAutoresizingMaskIntoConstraints = false
        controlsSymbolsSwitch.addTarget(self, action: #selector(controlsSymbolsSwitched(_:)), for: .valueChanged)
        
        addSubview(controlsSymbolsSwitch)
        
        NSLayoutConstraint.activate([
            controlsSymbolsSwitch.leadingAnchor.constraint(equalTo: colourfulControlsButton.leadingAnchor),
            controlsSymbolsSwitch.topAnchor.constraint(equalTo: colourfulLabel.bottomAnchor, constant: 10)
        ])
    }
    
    @objc private func controlsSymbolsSwitched(_ sender: UISwitch) {
        CacheManager.shared.setShowControlsSymbols(to: sender.isOn)
        parent?.canvas?.updateWindowControlsSymbols()
    }
    
    private func setupOpacityLabel() {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "Divider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: controlsSymbolsSwitch.bottomAnchor, constant: 10),
            divider.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        opacityLabel = UILabel()
        opacityLabel.text = "Opacity:"
        opacityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(opacityLabel)
        
        NSLayoutConstraint.activate([
            opacityLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            opacityLabel.leadingAnchor.constraint(equalTo: divider.leadingAnchor, constant: 2)
        ])
        
        setupOpacitySlider()
    }
    
    private func setupOpacitySlider() {
        opacityMinButton = UIButton()
        opacityMinButton.toolTip = "Decrease Window Opacity"
        opacityMinButton.tintColor = .label
        opacityMinButton.setImage(UIImage(systemName: "circle.lefthalf.filled"), for: .normal)
        opacityMinButton.addTarget(self, action: #selector(decreaseOpacity), for: .touchUpInside)
        opacityMinButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(opacityMinButton)
        
        NSLayoutConstraint.activate([
            opacityMinButton.topAnchor.constraint(equalTo: opacityLabel.bottomAnchor, constant: 12),
            opacityMinButton.leadingAnchor.constraint(equalTo: opacityLabel.leadingAnchor, constant: 0)
        ])
        
        opacitySlider = UISlider()
        opacitySlider.toolTip = "Window Opacity"
        opacitySlider.minimumValue = 0
        opacitySlider.maximumValue = 1
        opacitySlider.value = CacheManager.shared.preferredWindowOpacity
        opacitySlider.addTarget(self, action: #selector(opacityValueChanged(_:)), for: .valueChanged)
        opacitySlider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(opacitySlider)
        
        NSLayoutConstraint.activate([
            opacitySlider.centerYAnchor.constraint(equalTo: opacityMinButton.centerYAnchor, constant: 0),
            opacitySlider.leadingAnchor.constraint(equalTo: opacityMinButton.trailingAnchor, constant: 10),
            opacitySlider.widthAnchor.constraint(equalToConstant: 234)
        ])
        
        opacityMaxButton = UIButton()
        opacityMaxButton.toolTip = "Increase Window Opacity"
        opacityMaxButton.tintColor = .label
        opacityMaxButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        opacityMaxButton.addTarget(self, action: #selector(increaseOpacity), for: .touchUpInside)
        opacityMaxButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(opacityMaxButton)
        
        NSLayoutConstraint.activate([
            opacityMaxButton.centerYAnchor.constraint(equalTo: opacitySlider.centerYAnchor),
            opacityMaxButton.leadingAnchor.constraint(equalTo: opacitySlider.trailingAnchor, constant: 10)
        ])
    }
    
    @objc func decreaseOpacity() {
        opacitySlider.value -= 0.1
        parent?.canvas?.updateWindowUnderlay(opacity: opacitySlider.value)
        CacheManager.shared.setPreferredWindowOpacity(to: opacitySlider.value)
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    @objc func increaseOpacity() {
        opacitySlider.value += 0.1
        parent?.canvas?.updateWindowUnderlay(opacity: opacitySlider.value)
        CacheManager.shared.setPreferredWindowOpacity(to: opacitySlider.value)
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    @objc func opacityValueChanged(_ sender: UISlider) {
        parent?.canvas?.updateWindowUnderlay(opacity: opacitySlider.value)
        CacheManager.shared.setPreferredWindowOpacity(to: opacitySlider.value)
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    private func setupPadding() {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "Divider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: opacitySlider.bottomAnchor, constant: 10),
            divider.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let paddingLabel = UILabel()
        paddingLabel.text = "Padding:"
        paddingLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(paddingLabel)

        NSLayoutConstraint.activate([
            paddingLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            paddingLabel.leadingAnchor.constraint(equalTo: colourfulControlsButton.leadingAnchor)
        ])

        horizontalLabel = UILabel()
        horizontalLabel.text = "􀥖" //"􀫼"
        horizontalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        verticalLabel = UILabel()
        verticalLabel.text = "􀥛" //"􀫺"
        verticalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(horizontalLabel)
        addSubview(verticalLabel)
        
        let items = ["16", "32", "64", "96", "128"]
        let hSelection = items.firstIndex(of: String(CacheManager.shared.preferredHorizontalPadding)) ?? 2
        let vSelection = items.firstIndex(of: String(CacheManager.shared.preferredVerticalPadding)) ?? 2
        
        horizontalPaddingSegmentedControl = UISegmentedControl(items: items)
        horizontalPaddingSegmentedControl.toolTip = "Horizontal Window Padding"
        horizontalPaddingSegmentedControl.tag = 0
        horizontalPaddingSegmentedControl.selectedSegmentIndex = hSelection
        horizontalPaddingSegmentedControl.addTarget(self, action: #selector(updatePadding(_:)), for: .valueChanged)
        horizontalPaddingSegmentedControl.translatesAutoresizingMaskIntoConstraints = false

        addSubview(horizontalPaddingSegmentedControl)

        NSLayoutConstraint.activate([
            horizontalLabel.leadingAnchor.constraint(equalTo: paddingLabel.leadingAnchor, constant: 1),
            horizontalPaddingSegmentedControl.topAnchor.constraint(equalTo: paddingLabel.bottomAnchor, constant: 10),
            horizontalPaddingSegmentedControl.leadingAnchor.constraint(equalTo: horizontalLabel.trailingAnchor, constant: 10),
            horizontalPaddingSegmentedControl.widthAnchor.constraint(equalToConstant: 236), // 255
            horizontalLabel.centerYAnchor.constraint(equalTo: horizontalPaddingSegmentedControl.centerYAnchor)
        ])
        
        verticalPaddingSegmentedControl = UISegmentedControl(items: items)
        verticalPaddingSegmentedControl.toolTip = "Vertical Window Padding"
        verticalPaddingSegmentedControl.tag = 1
        verticalPaddingSegmentedControl.selectedSegmentIndex = vSelection
        verticalPaddingSegmentedControl.addTarget(self, action: #selector(updatePadding(_:)), for: .valueChanged)
        verticalPaddingSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(verticalPaddingSegmentedControl)
        
        NSLayoutConstraint.activate([
            verticalLabel.leadingAnchor.constraint(equalTo: paddingLabel.leadingAnchor, constant: 1),
            verticalPaddingSegmentedControl.topAnchor.constraint(equalTo: horizontalPaddingSegmentedControl.bottomAnchor, constant: 12),
            verticalPaddingSegmentedControl.leadingAnchor.constraint(equalTo: verticalLabel.trailingAnchor, constant: 10),
            verticalPaddingSegmentedControl.widthAnchor.constraint(equalToConstant: 236), // 255
            verticalLabel.centerYAnchor.constraint(equalTo: verticalPaddingSegmentedControl.centerYAnchor)
        ])
    }
    
    @objc private func updatePadding(_ sender: UISegmentedControl) {
        let values: [CGFloat] = [16, 32, 64, 96, 128]
        let padding = values[sender.selectedSegmentIndex]
        
        var edges: [PaddingSides] = []
        
        if CacheManager.shared.prefersMatchedPadding {
            horizontalPaddingSegmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
            verticalPaddingSegmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
            
            CacheManager.shared.setPreferredHorizontalPadding(to: Int(padding))
            CacheManager.shared.setPreferredVerticalPadding(to: Int(padding))
            edges = [.vertical, .horizontal]
        } else {
            if sender.tag == 0 {
                CacheManager.shared.setPreferredHorizontalPadding(to: Int(padding))
                edges = [.horizontal]
            } else {
                CacheManager.shared.setPreferredVerticalPadding(to: Int(padding))
                edges = [.vertical]
            }
        }
        
        parent?.canvas?.updateWindowPadding(withPadding: padding, onEdges: edges)
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    private func setupPaddingLinkButton() {
        linkSwitch = UISwitch()
        linkSwitch.isOn = CacheManager.shared.prefersMatchedPadding
        linkSwitch.toolTip = "Lock Horizontal and Vertical Padding"
        linkSwitch.translatesAutoresizingMaskIntoConstraints = false
        linkSwitch.addTarget(self, action: #selector(linkTapped(_:)), for: .valueChanged)
        
        addSubview(linkSwitch)
        
        NSLayoutConstraint.activate([
            linkSwitch.trailingAnchor.constraint(equalTo: noneControlsButton.trailingAnchor),
            linkSwitch.centerYAnchor.constraint(equalTo: horizontalPaddingSegmentedControl.centerYAnchor, constant: 17)
        ])
        
        linkImageView = UIImageView()
        linkImageView.image = UIImage(named: "PaddingLink")
        linkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(linkImageView)
        bringSubviewToFront(linkSwitch)
        
        NSLayoutConstraint.activate([
            linkImageView.trailingAnchor.constraint(equalTo: linkSwitch.centerXAnchor, constant: 1),
            linkImageView.centerYAnchor.constraint(equalTo: linkSwitch.centerYAnchor, constant: 0)
        ])
    }
    
    @objc private func linkTapped(_ sender: UISwitch) {
        if sender.isOn {
            CacheManager.shared.setPreferredMatchedPadding(to: true)
            verticalPaddingSegmentedControl.selectedSegmentIndex = horizontalPaddingSegmentedControl.selectedSegmentIndex
            
            updatePadding(horizontalPaddingSegmentedControl)
        } else {
            CacheManager.shared.setPreferredMatchedPadding(to: false)
        }

        PresetManager.shared.handleCustomIfNeeded()
    }
    
    @objc private func updateUI() {
        titleTextField.text = CacheManager.shared.preferredTitle
        showIconSwitch.isOn = CacheManager.shared.prefersIconVisible
        updateAppearanceButtons()
        updateControlsButtons()
        controlsSymbolsSwitch.isOn = CacheManager.shared.showControlsSymbols
        opacitySlider.setValue(CacheManager.shared.preferredWindowOpacity, animated: false)
        
        let values = [16, 32, 64, 96, 128]
        let hPadding = values.firstIndex(of: CacheManager.shared.preferredHorizontalPadding)
        let VPadding = values.firstIndex(of: CacheManager.shared.preferredVerticalPadding)
        horizontalPaddingSegmentedControl.selectedSegmentIndex = hPadding ?? 2
        verticalPaddingSegmentedControl.selectedSegmentIndex = VPadding ?? 2
        linkSwitch.isOn = CacheManager.shared.prefersMatchedPadding
    }
    
    @objc private func updateTintColours() {
        let buttons: [UIButton] = [
            automaticAppearanceButton,
            lightAppearanceButton,
            darkAppearanceButton,
            
            colourfulControlsButton,
            graphiteControlsButton,
            noneControlsButton
        ]
        
        for button in buttons {
            if button.layer.borderWidth == 2 {
                button.layer.borderColor = UIColor.systemTint.cgColor
            }
        }
    }
}
