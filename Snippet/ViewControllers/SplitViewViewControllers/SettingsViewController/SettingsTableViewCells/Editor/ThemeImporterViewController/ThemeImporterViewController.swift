//
//  ThemeImporterViewController.swift
//  Snippet
//
//  Created by Seb Vidal on 19/02/3022.
//

import UIKit
import UniformTypeIdentifiers
import Splash
import AppKit

class ThemeImporterViewController: UIViewController {
    weak var parentCell: LanguageTableViewCell!
    var editingTheme: String? = nil
    
    private var titleLabel: UILabel!
    
    private var nameLabel: UILabel!
    private var nameDetail: UILabel!
    private var nameTextField: UITextField!
    private var nameEdited = false
    
    private var importLabel: UILabel!
    private var importDetail: UILabel!
    private var importTextField: UITextField!
    private var importButton: UIButton!
    
    private var syntaxLabel: UILabel!
    private var syntaxDetails: UILabel!
    private var syntaxTableView: UITableView!
    private let syntaxOptions: [SyntaxOption] = [
        SyntaxOption(name: "Plain Text", identifier: "xcode.syntax.plain"),
        SyntaxOption(name: "Comments", identifier: "xcode.syntax.comment"),
        SyntaxOption(name: "URLs", identifier: "xcode.syntax.url"),
        SyntaxOption(name: "Strings", identifier: "xcode.syntax.string"),
        SyntaxOption(name: "Numbers", identifier: "xcode.syntax.number"),
        SyntaxOption(name: "Keywords", identifier: "xcode.syntax.keyword"),
        SyntaxOption(name: "Type Declarations", identifier: "xcode.syntax.declaration.type"),
        SyntaxOption(name: "Other Declarations", identifier: "xcode.syntax.declaration.other"),
        SyntaxOption(name: "Built-in Type Names and Functions", identifier: "xcode.syntax.identifier.variable.system"), // xcode.syntax.identifier.type.system
        SyntaxOption(name: "Other Type Names", identifier: "xcode.syntax.identifier.type"),
        SyntaxOption(name: "Instance Variables and Functions", identifier: "xcode.syntax.identifier.function"),
        SyntaxOption(name: "Preprocessor Statements", identifier: "xcode.syntax.preprocessor")
    ]

    private var saveButton: UIButton!
    private var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupName()
        setupImportOptions()
        setupSaveCancel()
        setupTableView()
        
        if let name = editingTheme {
            beginEditingTheme(named: name)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        syntaxTableView.flashScrollIndicators()
        nameTextField.becomeFirstResponder()
        nameTextField.selectAll(self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            syntaxTableView.reloadData()
            syntaxTableView.layer.borderColor = UIColor(named: "EditorBorder")?.cgColor
        }
    }
    
    private func setupNavigationBar() {
        titleLabel = UILabel()
        titleLabel.text = "New Theme"
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ])
    }
    
    private func setupName() {
        nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12)
        ])
        
        nameDetail = UILabel()
        nameDetail.text = "Choose a name for your new Theme, as you'd like it to appear in the Editor pane."
        nameDetail.font = .systemFont(ofSize: 12)
        nameDetail.textColor = .secondaryLabel
        nameDetail.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameDetail)
        
        NSLayoutConstraint.activate([
            nameDetail.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            nameDetail.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
        
        nameTextField = UITextField()
        nameTextField.borderStyle = .roundedRect
        nameTextField.text = "My Theme"
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameDetail.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            nameTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func nameTextFieldDidChange(_ textField: UITextField) {
        if !nameEdited {
            nameEdited = true
        }
    }
    
    private func setupImportOptions() {
        importLabel = UILabel()
        importLabel.text = "Import from Xcode"
        importLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(importLabel)
        
        NSLayoutConstraint.activate([
            importLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            importLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20)
        ])
        
        importDetail = UILabel()
        importDetail.text = "Select an .xccolortheme file to create and modify a new Snippet Theme."
        importDetail.font = .systemFont(ofSize: 12)
        importDetail.textColor = .secondaryLabel
        importDetail.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(importDetail)
        
        NSLayoutConstraint.activate([
            importDetail.leadingAnchor.constraint(equalTo: importLabel.leadingAnchor),
            importDetail.topAnchor.constraint(equalTo: importLabel.bottomAnchor, constant: 6)
        ])
        
        importButton = UIButton(type: .system)
        importButton.setTitle("Import...", for: .normal)
        importButton.translatesAutoresizingMaskIntoConstraints = false
        importButton.addTarget(self, action: #selector(importTapped(_:)), for: .touchUpInside)
        
        view.addSubview(importButton)
        
        NSLayoutConstraint.activate([
            importButton.topAnchor.constraint(equalTo: importDetail.bottomAnchor, constant: 10),
            importButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            importButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        importTextField = UITextField()
        importTextField.borderStyle = .roundedRect
        importTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(importTextField)
        
        NSLayoutConstraint.activate([
            importTextField.topAnchor.constraint(equalTo: importDetail.bottomAnchor, constant: 9),
            importTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            importTextField.trailingAnchor.constraint(equalTo: importButton.leadingAnchor, constant: -16)
        ])
    }
    
    @objc private func importTapped(_ sender: UIButton) {
        let types: [UTType] = [.init(filenameExtension: "xccolortheme")!]
        let directory = URL(string: NSHomeDirectory() + "/Library/Developer/Xcode/UserData/FontAndColorThemes/")
        
        let documentPicker = DocumentPickerViewController(supportedTypes: types, directorURL: directory) { [weak self] url in
            guard let self = self else {
                return
            }
            
            self.importTextField.text = url.path
            
            if !self.nameEdited {
                var file = url.lastPathComponent
                file = file.replacingOccurrences(of: ".xccolortheme", with: "")
                file = file.replacingOccurrences(of: "(Dark)", with: "")
                file = file.replacingOccurrences(of: "(Light)", with: "")
                file = file.trimmingCharacters(in: .whitespaces)
                
                self.nameTextField.text = file
            }
            
            if let syntaxDictionary = NSDictionary(contentsOf: url) {
                self.loadColours(from: syntaxDictionary)
            }
        }
        
        present(documentPicker, animated: true)
    }
    
    private func loadColours(from dictionary: NSDictionary) {
        guard let syntaxColours = dictionary.value(forKey: "DVTSourceTextSyntaxColors") as? NSDictionary else {
            return
        }
        
        for option in syntaxOptions {
            guard let value = syntaxColours.value(forKey: option.identifier) as? String else {
                continue
            }
            
            let values = (value.split(separator: " ") as [NSString]).compactMap { CGFloat($0.floatValue) }
            let light = Color(red: values[0], green: values[1], blue: values[2])
            let dark = Color(red: values[0], green: values[1], blue: values[2])
            
            option.colour.light = light
            option.colour.dark = dark
        }
        
        syntaxTableView.reloadData()
    }

    private func setupSaveCancel() {
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.configuration = .borderedProminent()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            cancelButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -16),
            cancelButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func save() {
        if Theme.defaults.contains(nameTextField.text!) {
            showNameInUseDialogue()
            return
        }
        
        let existingThemes = CacheManager.shared.themesJson
        
        if let editingTheme = editingTheme {
            if nameTextField.text! == editingTheme {
                saveData()
                return
            }
        }
        
        if let _ = existingThemes[nameTextField.text!] {
            AKIntegrator.shared.showThemeOverwriteAlert(self, name: nameTextField.text!)
        } else {
            saveData()
        }
    }
    
    private func showNameInUseDialogue() {
        let title = "\"\(nameTextField.text!)\" is a default Theme."
        let message = "Overwriting default Themes is not allowed. Please choose a different name."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.preferredAction = alert.actions.first
        
        present(alert, animated: true)
    }
    
    @objc private func saveData() {
        let theme = themeJson()
        
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = path.appendingPathComponent("themes.txt")
            
            if FileManager.default.fileExists(atPath: url.path) {
                var themes = CacheManager.shared.themesJson
                themes[nameTextField.text!] = theme
                
                try? JSONSerialization.data(withJSONObject: themes, options: .prettyPrinted).write(to: url)
            } else {
                let themes = [nameTextField.text!: theme]
                try? JSONSerialization.data(withJSONObject: themes, options: .prettyPrinted).write(to: url)
            }
        }
        
        CacheManager.shared.setPreferredThemeName(to: nameTextField.text!)
        parentCell?.updateThemes()
        parentCell?.parent?.canvas?.updateTheme()
        PresetManager.shared.handleCustomIfNeeded()
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func themeJson() -> [String: Any] {
        var syntax: [String: Any] = [:]
        
        for option in syntaxOptions {
            let id = option.identifier
            let light = option.colour.light.cgColor.components!
            let dark = option.colour.dark.cgColor.components!
            syntax[id] = [
                "light": light,
                "dark": dark
            ]
        }
        
        return syntax
    }
    
    private func setupTableView() {
        syntaxLabel = UILabel()
        syntaxLabel.text = "Highlighting Colours"
        syntaxLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(syntaxLabel)
        
        NSLayoutConstraint.activate([
            syntaxLabel.topAnchor.constraint(equalTo: importTextField.bottomAnchor, constant: 20),
            syntaxLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        syntaxDetails = UILabel()
        syntaxDetails.translatesAutoresizingMaskIntoConstraints = false
        syntaxDetails.text = "Edit the syntax highlighting colours."
        syntaxDetails.font = .systemFont(ofSize: 12)
        syntaxDetails.textColor = .secondaryLabel
        
        view.addSubview(syntaxDetails)
        
        NSLayoutConstraint.activate([
            syntaxDetails.topAnchor.constraint(equalTo: syntaxLabel.bottomAnchor, constant: 8),
            syntaxDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        syntaxTableView = UITableView()
        syntaxTableView.delegate = self
        syntaxTableView.dataSource = self
        syntaxTableView.allowsSelection = false
        syntaxTableView.backgroundColor = UIColor(named: "EditorBackground")
        syntaxTableView.layer.cornerCurve = .continuous
        syntaxTableView.layer.cornerRadius = 5
        syntaxTableView.layer.borderWidth = 1
        syntaxTableView.layer.borderColor = UIColor(named: "EditorBorder")?.cgColor
        syntaxTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(syntaxTableView)
        
        NSLayoutConstraint.activate([
            syntaxTableView.topAnchor.constraint(equalTo: syntaxDetails.bottomAnchor, constant: 10),
            syntaxTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            syntaxTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            syntaxTableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -22)
        ])
    }
    
    func beginEditingTheme(named name: String) {
        let json = CacheManager.shared.themesJson
        if let theme = json[name] as? [String: Any] {
            for option in syntaxOptions {
                guard
                    let colours = theme[option.identifier] as? [String: Any],
                    let light = colours["light"] as? [CGFloat],
                    let dark = colours["dark"] as? [CGFloat]
                else {
                    return
                }
                
                let dynamic = DynamicColour(
                    light: Color(red: light[0], green: light[1], blue: light[2]),
                    dark: Color(red: dark[0], green: dark[1], blue: dark[2])
                )
                
                option.colour = dynamic
            }
            
            nameTextField.text = name
            syntaxTableView.reloadData()
        }
    }
}

extension ThemeImporterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return syntaxOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SyntaxColourCell()
        cell.syntax = syntaxOptions[indexPath.row]
        cell.parent = self
        cell.setupCell()
        
        return cell as UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
}

private class SyntaxColourCell: UITableViewCell {
    var syntax: SyntaxOption!
    private var syntaxLabel: UILabel!
    weak var parent: ThemeImporterViewController!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        setupSyntaxLabel()
        setupColourPickers()
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    private func setupSyntaxLabel() {
        syntaxLabel = UILabel()
        syntaxLabel.text = syntax.name
        syntaxLabel.font = UIFont(name: "sfmono-regular", size: 12)
        syntaxLabel.translatesAutoresizingMaskIntoConstraints = false
        syntaxLabel.textColor = traitCollection.userInterfaceStyle == .dark ? syntax.colour.dark : syntax.colour.light
        
        addSubview(syntaxLabel)
        
        NSLayoutConstraint.activate([
            syntaxLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            syntaxLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func setupColourPickers() {
        let darkColourPicker = ColourPicker()
        darkColourPicker.parent = self
        darkColourPicker.syntaxOption = syntax
        darkColourPicker.type = .dark
        darkColourPicker.setupColourPicker()
        darkColourPicker.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(darkColourPicker)
        
        NSLayoutConstraint.activate([
            darkColourPicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            darkColourPicker.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        let lightColourPicker = ColourPicker()
        lightColourPicker.parent = self
        lightColourPicker.syntaxOption = syntax
        lightColourPicker.type = .light
        lightColourPicker.setupColourPicker()
        lightColourPicker.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(lightColourPicker)
        
        NSLayoutConstraint.activate([
            lightColourPicker.trailingAnchor.constraint(equalTo: darkColourPicker.leadingAnchor, constant: -9),
            lightColourPicker.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func updateLabelColour(to colour: DynamicColour) {
        if traitCollection.userInterfaceStyle == .light {
            syntaxLabel.textColor = colour.light
        } else {
            syntaxLabel.textColor = colour.dark
        }
    }
}

private class SyntaxOption {
    var name: String
    var identifier: String
    var colour: DynamicColour = DynamicColour()
    
    init(name: String, identifier: String, colour: DynamicColour = DynamicColour()) {
        self.name = name
        self.identifier = identifier
        self.colour = colour
    }
}

private class ColourPicker: UIView, ColourPickerDelegate {
    weak var parent: SyntaxColourCell!
    var syntaxOption: SyntaxOption!
    var type: UIUserInterfaceStyle!
    
    private var imageView: UIImageView!
    private var colourView: UIView!
    private var picker: ColourPickerViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupColourPicker() {
        _setupImage()
        _setupTapGestures()
        _setupColourView()
        _setupPickerViewController()
    }
    
    private func _setupImage() {
        imageView = UIImageView()
        imageView.image = UIImage(named: "ColourPicker-Small")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func _setupTapGestures() {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tapGesture.minimumPressDuration = 0
        
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapped(_ tapGesture: UILongPressGestureRecognizer) {
        switch tapGesture.state {
        case .began:
            imageView.image = UIImage(named: "ColourPicker-Small-Depressed")
        case .ended:
            imageView.image = UIImage(named: "ColourPicker-Small")
            
            let colour = type == .light ? syntaxOption.colour.light : syntaxOption.colour.dark
            let cgColor = colour.cgColor
            let components = cgColor.components ?? [255, 1, 1]
            let hsv = RGB(r: Float(components[0]), g: Float(components[1]), b: Float(components[2])).hsv
            
            picker.hue = CGFloat(hsv.h)
            picker.saturation = CGFloat(hsv.s)
            picker.brightness = CGFloat(hsv.v)
            
            picker.modalPresentationStyle = .popover
            picker.popoverPresentationController?.permittedArrowDirections = .up
            picker.preferredContentSize = CGSize(width: 282, height: 448)
            picker.popoverPresentationController?.sourceView = self
            
            parent?.parent?.present(picker, animated: true)
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
    
    private func _setupColourView() {
        colourView = UIView()
        colourView.backgroundColor = type == .light ? syntaxOption.colour.light : syntaxOption.colour.dark
        colourView.layer.cornerCurve = .continuous
        colourView.layer.cornerRadius = 4
        colourView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addSubview(colourView)
        
        NSLayoutConstraint.activate([
            colourView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            colourView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            colourView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            colourView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func _setupPickerViewController() {
        picker = ColourPickerViewController()
        picker.delegate = self
    }
    
    func colourDidChange(withHue hue: Float, saturation: Float, brightness: Float, source: UIView?) {
        let hsv = HSV(h: hue, s: saturation, v: brightness)
        let rgb = hsv.rgb
        
        colourView.backgroundColor = hsv.uiColor
        
        if type == .light {
            syntaxOption.colour.light = Color(red: CGFloat(rgb.r), green: CGFloat(rgb.g), blue: CGFloat(rgb.b))
        } else {
            syntaxOption.colour.dark = Color(red: CGFloat(rgb.r), green: CGFloat(rgb.g), blue: CGFloat(rgb.b))
        }
        
        parent.updateLabelColour(to: syntaxOption.colour)
    }
}
