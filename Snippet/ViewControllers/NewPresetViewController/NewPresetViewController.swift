//
//  NewPresetViewController.swift
//  Snippet
//
//  Created by Seb Vidal on 20/03/2022.
//

import UIKit

class NewPresetViewController: UIViewController, UITextFieldDelegate {
    weak var presetSource: BackgroundViewController?
    
    private var titleLabel: UILabel!
    private var nameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var nameTextField: UITextField!
    private var cancelButton: UIButton!
    private var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleLabel()
        setupNameLabel()
        setupButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
        nameTextField.selectAll(self)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            guard let key = press.key else {
                continue
            }
            
            if key.charactersIgnoringModifiers == UIKeyCommand.inputEscape {
                dismiss(animated: true)
            }
            
            if key.keyCode.rawValue == 40 {
                save()
            }
        }
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "New Preset"
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12)
        ])
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Choose a name for your new Preset."
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
        
        nameTextField = UITextField()
        nameTextField.delegate = self
        nameTextField.borderStyle = .roundedRect
        nameTextField.text = "My Preset"
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let banned = ["", "Default", "Custom"]
        saveButton.isEnabled = !banned.contains(textField.text!)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        dismiss(animated: true)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        save()
        return true
    }
    
    private func setupButtons() {
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
        let presets = PresetManager.shared.presets
        
        if presets.keys.contains(nameTextField.text!) {
            AKIntegrator.shared.showPresetOverwriteAlert(self, name: nameTextField.text!)
        } else {
            saveData()
        }
    }
    
    @objc private func saveData() {
        PresetManager.shared.savePreset(named: nameTextField.text!)
        PresetManager.shared.setSelectedPreset(to: nameTextField.text!)
        PresetManager.shared.deletePreset(named: "Custom")
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.updatePresetToolbarItem()
            sceneDelegate.updateAddToolbarItem()
            sceneDelegate.presetChanged()
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
