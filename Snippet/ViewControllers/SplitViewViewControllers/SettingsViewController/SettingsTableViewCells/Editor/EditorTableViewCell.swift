//
//  EditorTableViewCell.swift
//  Snippet
//
//  Created by Seb Vidal on 31/01/2022.
//

import UIKit
import SwiftUI
import Splash

class LanguageTableViewCell: UITableViewCell, SettingsTableViewCell, ObservableObject, UITextFieldDelegate {
    weak var parent: SettingsViewController?
    var cellHeight: CGFloat = 416
    
    private var cellHeading: UILabel!
    
    private var languageLabel: UILabel!
    private var languagePicker: UIButton!
    
    private var themeLabel: UILabel!
    private var themePicker: UIButton!
    private var newThemeButton: UIButton!
    private var importThemeButton: UIButton!
    private var editThemeButon: UIButton!
    private var deleteThemeButton: UIButton!
    
    private var fontLabel: UILabel!
    private var fontPicker: UIButton!
    
    private var increaseFontButton: UIButton!
    private var fontSlider: UISlider!
    private var decreaseFontButton: UIButton!
    private var fontTextField: UITextField!
    
    private var lineNumbersLabel: UILabel!
    private var showLineNumbersSwitch: UISwitch!
    private var startAtLabel: UILabel!
    private var startAtTextField: UITextField!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addObservers()
        setupCellHeading()
        setupLanguageLabel()
        setupLanguagePicker()
        setupThemePicker()
        setupThemeButtons()
        setupFontLabel()
        setupFontPicker()
        setupFontSize()
        setupLineNumbers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("UpdateUI"), object: nil)
    }
    
    func setupCellHeading() {
        cellHeading = UILabel()
        cellHeading.text = "Editor"
        cellHeading.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        cellHeading.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cellHeading)
        
        NSLayoutConstraint.activate([
            cellHeading.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            cellHeading.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    func setupLanguageLabel() {
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
        
        languageLabel = UILabel()
        languageLabel.text = "Language:"
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(languageLabel)
        
        NSLayoutConstraint.activate([
            languageLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            languageLabel.leadingAnchor.constraint(equalTo: cellHeading.leadingAnchor, constant: 2)
        ])
    }
    
    func setupLanguagePicker() {
        languagePicker = UIButton(type: .system)
        languagePicker.showsMenuAsPrimaryAction = true
        languagePicker.changesSelectionAsPrimaryAction = true
        languagePicker.translatesAutoresizingMaskIntoConstraints = false
        languagePicker.toolTip = "Programming Language"
        
        contentView.addSubview(languagePicker)
        
        NSLayoutConstraint.activate([
            languagePicker.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 10),
            languagePicker.leadingAnchor.constraint(equalTo: languageLabel.leadingAnchor),
            languagePicker.widthAnchor.constraint(equalToConstant: 284)
        ])
    
        setupLanguages()
    }
    
    func setupLanguages() {
        let languages = CacheManager.shared.languages.keys.sorted()
        var children: [UIAction] = []
        
        for language in languages {
            let action = UIAction(title: language) { [weak self] _ in
                CacheManager.shared.setPreferredLanguageName(to: language)
                PresetManager.shared.handleCustomIfNeeded()
                
                self?.parent?.canvas?.updateLanguage()
                self?.parent?.canvas?.updateWindowTitleIcon()
            }
            
            action.state = CacheManager.shared.preferredLanguageName == language ? .on : .off
            children.append(action)
        }
        
        let menu = UIMenu(title: "Languages", children: children)
        languagePicker.menu = menu
    }

    func setupThemePicker() {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "Divider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: languagePicker.bottomAnchor, constant: 14),
            divider.leadingAnchor.constraint(equalTo: languageLabel.leadingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        themeLabel = UILabel()
        themeLabel.text = "Theme:"
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(themeLabel)
        
        NSLayoutConstraint.activate([
            themeLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            themeLabel.leadingAnchor.constraint(equalTo: divider.leadingAnchor, constant: 2)
        ])
        
        themePicker = UIButton(type: .system)
        themePicker.showsMenuAsPrimaryAction = true
        themePicker.changesSelectionAsPrimaryAction = true
        themePicker.translatesAutoresizingMaskIntoConstraints = false
        themePicker.toolTip = "Syntax Highlighting Theme"
        
        contentView.addSubview(themePicker)

        NSLayoutConstraint.activate([
            themePicker.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 10),
            themePicker.leadingAnchor.constraint(equalTo: themeLabel.leadingAnchor),
            themePicker.widthAnchor.constraint(equalToConstant: 282) // 284
        ])
    }
    
    private func themes() -> [String] {
        var names: [String] = []
        let json = CacheManager.shared.themesJson

        for theme in json {
            names.append(theme.key)
        }
        
        return names
    }
    
    func updateThemes() {
        var defaults: [UIAction] = [UIAction(title: "Default", attributes: .disabled, handler: { _ in })]
        var customs: [UIAction] = [UIAction(title: "Custom", attributes: .disabled, handler: { _ in })]
        
        for _default in Theme.defaults {
            let action = UIAction(title: _default) { [weak self] _ in
                self?.setTheme(to: _default)
                PresetManager.shared.handleCustomIfNeeded()
            }
            
            action.state = CacheManager.shared.preferredThemeName == _default ? .on : .off
            defaults.append(action)
        }
        
        for custom in themes().sorted() {
            let action = UIAction(title: custom) { [weak self] _ in
                self?.setTheme(to: custom)
                PresetManager.shared.handleCustomIfNeeded()
            }
            
            action.state = CacheManager.shared.preferredThemeName == custom ? .on : .off
            customs.append(action)
        }

        let defaultMenu = UIMenu(title: "Default", options: [.displayInline], children: defaults)
        let customMenu = UIMenu(title: "Custom", options: .displayInline, children: customs)
        var children = [defaultMenu]
        
        if !themes().isEmpty {
            children.append(customMenu)
        }
        
        let menu = UIMenu(title: "Themes", children: children)
        themePicker.menu = menu
        
        editThemeButon.isEnabled = !Theme.defaults.contains(CacheManager.shared.preferredThemeName)
        deleteThemeButton.isEnabled = !Theme.defaults.contains(CacheManager.shared.preferredThemeName)
    }
    
    func setTheme(to theme: String) {
        CacheManager.shared.setPreferredThemeName(to: theme)
        parent?.canvas?.updateTheme()
        parent?.canvas?.updateTextView()
        
        updateThemeControls()
    }
    
    func updateThemeControls() {
        editThemeButon.isEnabled = !Theme.defaults.contains(CacheManager.shared.preferredThemeName)
        deleteThemeButton.isEnabled = !Theme.defaults.contains(CacheManager.shared.preferredThemeName)
    }
    
    func setupThemeButtons() {
        newThemeButton = UIButton(type: .system)
        newThemeButton.toolTip = "New Theme"
        newThemeButton.setTitle("􀅼 New", for: .normal)
        newThemeButton.translatesAutoresizingMaskIntoConstraints = false
        newThemeButton.addTarget(self, action: #selector(newTheme(_:)), for: .touchUpInside)
        
        addSubview(newThemeButton)
        
        NSLayoutConstraint.activate([
            newThemeButton.topAnchor.constraint(equalTo: themePicker.bottomAnchor, constant: 10),
            newThemeButton.leadingAnchor.constraint(equalTo: themePicker.leadingAnchor),
            newThemeButton.widthAnchor.constraint(equalToConstant: 87)
        ])
        
        editThemeButon = UIButton(type: .system)
        editThemeButon.toolTip = "Edit Selected Theme"
        editThemeButon.setTitle("􀈊 Edit", for: .normal)
        editThemeButon.translatesAutoresizingMaskIntoConstraints = false
        editThemeButon.addTarget(self, action: #selector(editTheme(_:)), for: .touchUpInside)
        editThemeButon.isEnabled = !Theme.defaults.contains(CacheManager.shared.preferredThemeName)
        
        addSubview(editThemeButon)
        
        NSLayoutConstraint.activate([
            editThemeButon.topAnchor.constraint(equalTo: newThemeButton.topAnchor),
            editThemeButon.leadingAnchor.constraint(equalTo: newThemeButton.trailingAnchor, constant: 10),
            editThemeButon.widthAnchor.constraint(equalToConstant: 87)
        ])
        
        deleteThemeButton = UIButton(type: .system)
        deleteThemeButton.toolTip = "Delete Selected Theme"
        deleteThemeButton.setTitle("􀈑 Delete", for: .normal)
        deleteThemeButton.translatesAutoresizingMaskIntoConstraints = false
        deleteThemeButton.addTarget(self, action: #selector(deleteTheme(_:)), for: .touchUpInside)
        deleteThemeButton.isEnabled = !Theme.defaults.contains(CacheManager.shared.preferredThemeName)
        
        addSubview(deleteThemeButton)
        
        NSLayoutConstraint.activate([
            deleteThemeButton.topAnchor.constraint(equalTo: editThemeButon.topAnchor),
            deleteThemeButton.leadingAnchor.constraint(equalTo: editThemeButon.trailingAnchor, constant: 10),
            deleteThemeButton.widthAnchor.constraint(equalToConstant: 87)
        ])
        
        updateThemes()
    }
    
    @objc private func newTheme(_ sender: UIButton) {
        guard let parent = parent else {
            return
        }

        let vc = ThemeImporterViewController()
        vc.parentCell = self

        parent.present(vc, animated: true)
    }
    
    @objc private func editTheme(_ sender: UIButton) {
        guard let parent = parent else {
            return
        }
        
        let vc = ThemeImporterViewController()
        vc.parentCell = self
        vc.editingTheme = CacheManager.shared.preferredThemeName
        
        parent.present(vc, animated: true)
    }
    
    @objc private func deleteTheme(_ sender: UIButton) {
        let title = "Are you sure you want to delete \"\(CacheManager.shared.preferredThemeName)\"?"
        let message = "This theme will be deleted permanently. You can't undo this action."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in self?.deleteThemeData() })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in return })
        alert.preferredAction = alert.actions.last
        
        guard let parent = parent else {
            return
        }
        
        parent.present(alert, animated: true)
    }
    
    private func deleteThemeData() {
        let theme = CacheManager.shared.preferredThemeName
        var json = CacheManager.shared.themesJson
        json[theme] = nil
        
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = path.appendingPathComponent("themes.txt")
            
            do {
                if try url.checkResourceIsReachable() {
                    try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted).write(to: url)
                }
            } catch {
                print("Failed to delete theme.")
            }
        }
        
        CacheManager.shared.setPreferredThemeName(to: "Xcode")
        parent?.canvas?.updateTheme()
        parent?.canvas?.updateTextView()
        updateThemes()
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    func setupFontLabel() {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "Divider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: newThemeButton.bottomAnchor, constant: 14),
            divider.leadingAnchor.constraint(equalTo: themePicker.leadingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        fontLabel = UILabel()
        fontLabel.text = "Font:"
        fontLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(fontLabel)
        
        NSLayoutConstraint.activate([
            fontLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            fontLabel.leadingAnchor.constraint(equalTo: divider.leadingAnchor)
        ])
    }
    
    func setupFontPicker() {
        fontPicker = UIButton(type: .system)
        fontPicker.changesSelectionAsPrimaryAction = true
        fontPicker.showsMenuAsPrimaryAction = true
        fontPicker.translatesAutoresizingMaskIntoConstraints = false
        fontPicker.toolTip = "Font"
        
        contentView.addSubview(fontPicker)
        
        NSLayoutConstraint.activate([
            fontPicker.topAnchor.constraint(equalTo: fontLabel.bottomAnchor, constant: 10),
            fontPicker.leadingAnchor.constraint(equalTo: fontLabel.leadingAnchor),
            fontPicker.widthAnchor.constraint(equalToConstant: 282)
        ])
        
        updateFonts()
    }
    
    func updateFonts() {
        let fonts = [
            "Andale Mono": "AndaleMono",
            "Anonymous Pro": "AnonymousPro",
            "Courier New": "CourierNewPSMT",
            "Fira Code": "FiraCode-Regular",
            "JetBrains Mono": "JetBrainsMono-Regular",
            "Menlo": "Menlo-Regular",
            "PT Mono": "PTMono-Regular",
            "Roboto Mono": "RobotoMono-Regular",
            "SF Mono": "SFMono-Regular",
            "Source Code Pro": "SourceCodePro-Regular",
            "Ubuntu Mono": "UbuntuMono-Regular"
        ]
        
        var children: [UIAction] = []
        
        for font in fonts.sorted(by: { $0.key < $1.key }) {
            let action = UIAction(title: font.key) { [weak self] _ in
                CacheManager.shared.setPreferredFontName(to: font.value)
                PresetManager.shared.handleCustomIfNeeded()
                self?.parent?.canvas?.updateTheme()
                self?.parent?.canvas?.updateTextView()
                self?.parent?.canvas?.updateFont(to: UIFont(name: font.value, size: CacheManager.shared.preferredFontSize)!)
            }
            
            action.state = CacheManager.shared.preferredFontName == font.value ? .on : .off
            children.append(action)
        }
        
        let menu = UIMenu(title: "Fonts", children: children)
        fontPicker.menu = menu
    }
    
    func setupFontSize() {
        fontTextField = UITextField()
        fontTextField.borderStyle = .roundedRect
        fontTextField.textAlignment = .center
        fontTextField.delegate = self
        fontTextField.text = "\(Int(CacheManager.shared.preferredFontSize))"
        fontTextField.translatesAutoresizingMaskIntoConstraints = false
        fontTextField.toolTip = "Font Size"
        
        addSubview(fontTextField)
        
        NSLayoutConstraint.activate([
            fontTextField.trailingAnchor.constraint(equalTo: fontPicker.trailingAnchor),
            fontTextField.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        decreaseFontButton = UIButton()
        decreaseFontButton.titleLabel?.font = .systemFont(ofSize: 11)
        decreaseFontButton.setTitle("Aa", for: .normal)
        decreaseFontButton.setTitleColor(.label, for: .normal)
        decreaseFontButton.translatesAutoresizingMaskIntoConstraints = false
        decreaseFontButton.addTarget(self, action: #selector(decreaseSlider), for: .touchUpInside)
        decreaseFontButton.toolTip = "Decrease Font Size"
        
        addSubview(decreaseFontButton)
        
        NSLayoutConstraint.activate([
            decreaseFontButton.topAnchor.constraint(equalTo: fontPicker.bottomAnchor, constant: 10),
            decreaseFontButton.leadingAnchor.constraint(equalTo: fontPicker.leadingAnchor, constant: -1)
        ])
        
        increaseFontButton = UIButton()
        increaseFontButton.titleLabel?.font = .systemFont(ofSize: 15)
        increaseFontButton.setTitle("Aa", for: .normal)
        increaseFontButton.setTitleColor(.label, for: .normal)
        increaseFontButton.translatesAutoresizingMaskIntoConstraints = false
        increaseFontButton.addTarget(self, action: #selector(increaseSlider), for: .touchUpInside)
        increaseFontButton.toolTip = "Increase Font Size"
        
        addSubview(increaseFontButton)
        
        NSLayoutConstraint.activate([
            increaseFontButton.centerYAnchor.constraint(equalTo: decreaseFontButton.centerYAnchor),
            increaseFontButton.trailingAnchor.constraint(equalTo: fontTextField.leadingAnchor, constant: -10)
        ])
        
        fontSlider = UISlider()
        fontSlider.minimumValue = 10
        fontSlider.maximumValue = 50
        fontSlider.value = Float(CacheManager.shared.preferredFontSize)
        fontSlider.translatesAutoresizingMaskIntoConstraints = false
        fontSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        fontSlider.toolTip = "Font Size"
        
        addSubview(fontSlider)
        
        NSLayoutConstraint.activate([
            fontSlider.leadingAnchor.constraint(equalTo: decreaseFontButton.trailingAnchor, constant: 6),
            fontSlider.trailingAnchor.constraint(equalTo: increaseFontButton.leadingAnchor, constant: -10),
            fontSlider.centerYAnchor.constraint(equalTo: decreaseFontButton.centerYAnchor),
            fontSlider.centerYAnchor.constraint(equalTo: fontTextField.centerYAnchor)
        ])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 0 {
            if textField.text == "" {
                textField.text = "15"
            }
            
            if var size = Float(textField.text ?? "") {
                if size < 10.0 {
                    size = 10.0
                } else if size > 50.0 {
                    size = 50.0
                }
                
                fontSlider.setValue(size, animated: true)
                updateFont(withSize: size)
            }
        } else {
            if textField.text == "" {
                textField.text = "1"
            }
            
            CacheManager.shared.setLineNumberStart(to: Int(Float(textField.text!) ?? 1.0))
            PresetManager.shared.handleCustomIfNeeded()
            parent?.canvas?.updateLineNumbers()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        let size = sender.value
        updateFont(withSize: size)
    }
    
    @objc func decreaseSlider() {
        fontSlider.setValue(fontSlider.value - 1, animated: true)
        updateFont(withSize: fontSlider.value)
    }
    
    @objc func increaseSlider() {
        fontSlider.setValue(fontSlider.value + 1, animated: true)
        updateFont(withSize: fontSlider.value)
    }
    
    func updateFont(withSize size: Float) {
        if let font = UIFont(name: CacheManager.shared.preferredFontName, size: CGFloat(Int(size))) {
            CacheManager.shared.setPreferredFontSize(to: CGFloat(Int(size)))
            PresetManager.shared.handleCustomIfNeeded()
            parent?.canvas?.updateFont(to: font)
        }
        
        fontTextField.text = "\(Int(size))"
    }
    
    private func setupLineNumbers() {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "Divider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: fontTextField.bottomAnchor, constant: 14),
            divider.leadingAnchor.constraint(equalTo: themePicker.leadingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        lineNumbersLabel = UILabel()
        lineNumbersLabel.text = "Line Numbers:"
        lineNumbersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lineNumbersLabel)
        
        NSLayoutConstraint.activate([
            lineNumbersLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            lineNumbersLabel.leadingAnchor.constraint(equalTo: divider.leadingAnchor)
        ])
        
        showLineNumbersSwitch = UISwitch()
        showLineNumbersSwitch.title = "Show Line Numbers"
        showLineNumbersSwitch.toolTip = "Show Line Numbers"
        showLineNumbersSwitch.isOn = CacheManager.shared.showLineNumbers
        showLineNumbersSwitch.addTarget(self, action: #selector(toggleLineNumbers(_:)), for: .valueChanged)
        showLineNumbersSwitch.translatesAutoresizingMaskIntoConstraints = false
    
        addSubview(showLineNumbersSwitch)
        
        NSLayoutConstraint.activate([
            showLineNumbersSwitch.topAnchor.constraint(equalTo: lineNumbersLabel.bottomAnchor, constant: 10),
            showLineNumbersSwitch.leadingAnchor.constraint(equalTo: lineNumbersLabel.leadingAnchor)
        ])
        
        startAtLabel = UILabel()
        startAtLabel.text = "Start at:"
        startAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(startAtLabel)
        
        NSLayoutConstraint.activate([
            startAtLabel.leadingAnchor.constraint(equalTo: showLineNumbersSwitch.leadingAnchor)
        ])
        
        startAtTextField = UITextField()
        startAtTextField.tag = 1
        startAtTextField.borderStyle = .roundedRect
        startAtTextField.delegate = self
        startAtTextField.text = "\(CacheManager.shared.lineNumberStart)"
        startAtTextField.textAlignment = .center
        startAtTextField.translatesAutoresizingMaskIntoConstraints = false
        startAtTextField.toolTip = "Start at Line Numer"
        
        addSubview(startAtTextField)
        
        NSLayoutConstraint.activate([
            startAtTextField.topAnchor.constraint(equalTo: showLineNumbersSwitch.bottomAnchor, constant: 10),
            startAtTextField.leadingAnchor.constraint(equalTo: startAtLabel.trailingAnchor, constant: 10),
            startAtTextField.centerYAnchor.constraint(equalTo: startAtLabel.centerYAnchor),
            startAtTextField.widthAnchor.constraint(equalToConstant: 84)
        ])
    }
    
    @objc private func toggleLineNumbers(_ sender: UISwitch) {
        CacheManager.shared.setShowLineNumbers(to: sender.isOn)
        PresetManager.shared.handleCustomIfNeeded()
        parent?.canvas?.updateLineNumberVisibility()
    }

    @objc private func updateUI() {
        setupLanguages()
        updateThemes()
        updateFonts()
        updateThemeControls()
        fontSlider.setValue(Float(CacheManager.shared.preferredFontSize), animated: false)
        fontTextField.text = "\(Int(CacheManager.shared.preferredFontSize))"
        showLineNumbersSwitch.isOn = CacheManager.shared.showLineNumbers
        startAtTextField.text = "\(CacheManager.shared.lineNumberStart)"
    }
}
