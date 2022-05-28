//
//  ImageTableViewCell.swift
//  Snippet
//
//  Created by Seb Vidal on 06/02/2022.
//

import UIKit
import CoreGraphics

class ImageTableViewCell: UITableViewCell, SettingsTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    weak var parent: SettingsViewController?
    var cellHeight: CGFloat = 430
    
    private var presetLabel: UILabel!
    private var presetContainer: UICollectionView!
    fileprivate var buttons: [UIButton] = []
    
    private var customImage: UIImage?
    private var customLabel: UILabel!
    fileprivate var customButton: UIButton!
    private var uploadButton: UIButton!
    private var removeButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addObservers()
        setupPresetLabel()
        setupPresetsContainer()
        setupCustomLabel()
        setupCustomButton()
        setupUploadButton()
        setupRemoveButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            for button in buttons {
                if button.layer.borderWidth == 2 {
                    button.layer.borderColor = UIColor.systemTint.cgColor
                } else {
                    button.layer.borderColor = UIColor(named: "Border")?.cgColor
                }
            }
            
            if customButton.layer.borderWidth == 2 {
                customButton.layer.borderColor = UIColor.systemTint.cgColor
            } else {
                customButton.layer.borderColor = UIColor(named: "Border")?.cgColor
            }
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("UpdateUI"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTintColours), name: Notification.Name("NSSystemColorsDidChangeNotification"), object: nil)
    }
    
    func setupPresetLabel() {
        presetLabel = UILabel()
        presetLabel.text = "Presets:"
        presetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(presetLabel)
        
        NSLayoutConstraint.activate([
            presetLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            presetLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19)
        ])
    }
    
    func setupPresetsContainer() {
        let cellWidth: Double = 250 / 3
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: cellWidth, height: 57)
        
        presetContainer = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        presetContainer.collectionViewLayout = layout
        presetContainer.delegate = self
        presetContainer.dataSource = self
        presetContainer.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        presetContainer.register(PresetImageCollectionViewCell.self, forCellWithReuseIdentifier: "PresetImageCell")
        presetContainer.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(presetContainer)
        
        NSLayoutConstraint.activate([
            presetContainer.topAnchor.constraint(equalTo: presetLabel.bottomAnchor, constant: 10),
            presetContainer.leadingAnchor.constraint(equalTo: presetLabel.leadingAnchor),
            presetContainer.widthAnchor.constraint(equalToConstant: 284),
            presetContainer.heightAnchor.constraint(equalToConstant: 276)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UIImage.presets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = presetContainer.dequeueReusableCell(withReuseIdentifier: "PresetImageCell", for: indexPath) as! PresetImageCollectionViewCell
        cell.image = UIImage.presets[indexPath.row]
        cell.name = UIImage.presetNames[indexPath.row]
        cell.collectionView = self
        cell.indexPath = indexPath
        cell.setupCell()

        return cell
    }
    
    private func setupCustomLabel() {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "Divider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: presetContainer.bottomAnchor, constant: 12),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        customLabel = UILabel()
        customLabel.text = "Custom:"
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(customLabel)
        
        NSLayoutConstraint.activate([
            customLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            customLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19)
        ])
    }
    
    private func setupCustomButton() {
        customButton = UIButton()
        customButton.imageView?.contentMode = .scaleAspectFill
        customButton.layer.cornerCurve = .continuous
        customButton.layer.cornerRadius = 5
        customButton.layer.borderColor = shouldHighlight() ? UIColor.systemTint.cgColor : UIColor(named: "Border")?.cgColor
        customButton.layer.borderWidth = shouldHighlight() ? 2 : 1
        customButton.clipsToBounds = true
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        
        addSubview(customButton)
        
        NSLayoutConstraint.activate([
            customButton.topAnchor.constraint(equalTo: customLabel.bottomAnchor, constant: 10),
            customButton.leadingAnchor.constraint(equalTo: customLabel.leadingAnchor),
            customButton.widthAnchor.constraint(equalToConstant: 83),
            customButton.heightAnchor.constraint(equalToConstant: 57)
        ])
        
        if let image = CacheManager.shared.recentCustomImage {
            customButton.setImage(thumbnailImage(from: image), for: .normal)
        }
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 25)
        let cameraSymbol = UIImage(systemName: "camera.fill", withConfiguration: configuration)
        let cameraImage = UIImageView(image: cameraSymbol)
        cameraImage.tintColor = .tertiaryLabel
        cameraImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cameraImage)
        
        NSLayoutConstraint.activate([
            cameraImage.centerXAnchor.constraint(equalTo: customButton.centerXAnchor),
            cameraImage.centerYAnchor.constraint(equalTo: customButton.centerYAnchor, constant: -1)
        ])
        
        sendSubviewToBack(cameraImage)
    }
    
    private func thumbnailImage(from image: UIImage) -> UIImage {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 83, height: 57)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        return Snippet.image(from: imageView)
    }
    
    private func shouldHighlight() -> Bool {
        if CacheManager.shared.prefersCustomImage {
            if let _ = CacheManager.shared.recentCustomImage {
                return true
            }
        }
        
        return false
    }
    
    @objc private func customButtonTapped() {
        guard let image = CacheManager.shared.recentCustomImage else {
            return
        }
        
        parent?.updateBackground(to: .image(image: image))
        
        for button in buttons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(named: "Border")?.cgColor
        }
        
        customButton.layer.borderColor = UIColor.systemTint.cgColor
        customButton.layer.borderWidth = 2
        
        CacheManager.shared.setPrefersCustomImage(to: true)
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    private func setupUploadButton() {
        uploadButton = UIButton(type: .system)
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped(_:)), for: .touchUpInside)
        
        addSubview(uploadButton)
        
        NSLayoutConstraint.activate([
            uploadButton.topAnchor.constraint(equalTo: customButton.topAnchor, constant: 1),
            uploadButton.leadingAnchor.constraint(equalTo: customButton.trailingAnchor, constant: 14),
            uploadButton.widthAnchor.constraint(equalToConstant: 83)
        ])
    }
    
    @objc private func uploadButtonTapped(_ sender: UIButton) {
        let directory = URL(fileURLWithPath: "/System/Library/Desktop Pictures")
        let documentPicker = DocumentPickerViewController(supportedTypes: [.image], directorURL: directory) { [weak self] url in
            guard let self = self, let image = UIImage(contentsOfFile: url.path) else {
                return
            }
            
            CacheManager.shared.setCustomImagePath(to: url.path)
            
            self.customImage = image
            self.customButton.layer.borderColor = UIColor.systemTint.cgColor
            self.customButton.layer.borderWidth = 2
            self.customButton.setImage(self.thumbnailImage(from: image), for: .normal)
            self.parent?.updateBackground(to: .image(image: image))
            
            for button in self.buttons {
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor(named: "Border")?.cgColor
            }
            
            PresetManager.shared.handleCustomIfNeeded()
        }
        
        parent?.present(documentPicker, animated: true)
    }
    
    private func setupRemoveButton() {
        removeButton = UIButton(type: .system)
        removeButton.setTitle("Remove", for: .normal)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
        
        addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            removeButton.bottomAnchor.constraint(equalTo: customButton.bottomAnchor, constant: -1),
            removeButton.leadingAnchor.constraint(equalTo: customButton.trailingAnchor, constant: 14),
            removeButton.widthAnchor.constraint(equalToConstant: 83)
        ])
    }
    
    @objc private func removeImage() {
        customImage = nil
        customButton.layer.borderWidth = 1
        customButton.layer.borderColor = UIColor(named: "Border")?.cgColor
        customButton.setImage(nil, for: .normal)
        
        Task {
            let image = await CacheManager.shared.recentPresetBackgroundImage()
            
            DispatchQueue.main.async { [weak self] in
                self?.parent?.updateBackground(to: .image(image: image))
            }
        }
        
        let index = CacheManager.shared.recentPresetBackgroundImageIndex
        buttons[index].layer.borderWidth = 2
        buttons[index].layer.borderColor = UIColor.systemTint.cgColor
        
        CacheManager.shared.setCustomImagePath(to: "")
        CacheManager.shared.setPrefersCustomImage(to: false)
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    @objc private func updateUI() {
        guard PresetManager.shared.selectedPreset["backgroundType"] as? Int == 3 else {
            return
        }
        
        
        if let value = PresetManager.shared.selectedPreset["backgroundValue"] as? Int {
            customButton.layer.borderWidth = 1
            customButton.layer.borderColor = UIColor(named: "Border")?.cgColor
            
            for (index, button) in buttons.enumerated() {
                button.layer.borderColor = index == value ? UIColor.systemTint.cgColor : UIColor(named: "Border")?.cgColor
                button.layer.borderWidth = index == value ? 2 : 1
            }
        } else if let path = PresetManager.shared.selectedPreset["backgroundValue"] as? String {
            for button in buttons {
                button.layer.borderColor = UIColor(named: "Border")?.cgColor
                button.layer.borderWidth = 1
            }
            
            customButton.setImage(UIImage(contentsOfFile: path), for: .normal)
            customButton.layer.borderColor = UIColor.systemTint.cgColor
            customButton.layer.borderWidth = 2
        }
    }
    
    @objc private func updateTintColours() {
        for button in buttons {
            if button.layer.borderWidth == 2 {
                button.layer.borderColor = UIColor.systemTint.cgColor
            }
        }
        
        if customButton.layer.borderWidth == 2 {
            customButton.layer.borderColor = UIColor.systemTint.cgColor
        }
    }
}

class PresetImageCollectionViewCell: UICollectionViewCell {
    weak var collectionView: ImageTableViewCell!
    var name: String!
    var image: UIImage!
    var button: UIButton!
    var indexPath: IndexPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if layer.borderWidth == 1 {
                layer.borderColor = UIColor(named: "Border")?.cgColor
            } else {
                layer.borderColor = UIColor.systemTint.cgColor
            }
        }
    }
    
    func setupCell() {
        button = UIButton()
        button.backgroundColor = .red
        button.setImage(image, for: .normal)
        button.frame = bounds
        button.addTarget(self, action: #selector(backgroundButtonTapped), for: .touchUpInside)
        button.toolTip = name.map {
            var value = ""
            for (index, char) in $0.enumerated() {
                if char == "-" { break }
                
                if index == 0 { value += "\(char)" } else {
                    if char.isUppercase { value += " " }; value += "\(char)"
                }
            }
            
            return value
        }
        
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 5
        button.layer.borderWidth = shouldHighlight() ? 2 : 1
        button.layer.borderColor = shouldHighlight() ? UIColor.systemTint.cgColor : UIColor(named: "Border")?.cgColor
        button.layer.masksToBounds = true
        
        collectionView.buttons.append(button)
        
        addSubview(button)
    }
    
    private func shouldHighlight() -> Bool {
        if CacheManager.shared.prefersCustomImage {
            return false
        }
        
        if CacheManager.shared.recentPresetBackgroundImageIndex == indexPath.row {
            return true
        }
        
        return false
    }
    
    @objc private func backgroundButtonTapped() {
        guard let collectionView = collectionView else {
            return
        }

        CacheManager.shared.setPresetBackgroundImage(to: name)
        PresetManager.shared.handleCustomIfNeeded()

        Task {
            let image = await CacheManager.shared.recentPresetBackgroundImage()
            
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.parent?.updateBackground(to: .image(image: image))
            }
        }

        for button in collectionView.buttons {
            button.layer.borderColor = UIColor(named: "Border")?.cgColor
            button.layer.borderWidth = 1
        }

        button.layer.borderColor = UIColor.systemTint.cgColor
        button.layer.borderWidth = 2

        collectionView.customButton.layer.borderWidth = 1
        collectionView.customButton.layer.borderColor = UIColor(named: "Border")?.cgColor
    }
}
