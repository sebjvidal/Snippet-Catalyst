//
//  GradientTableViewCell.swift
//  Snippet
//
//  Created by Seb Vidal on 12/02/2022.
//

import UIKit

class GradientTableViewCell: UITableViewCell, SettingsTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var parent: SettingsViewController?
    var cellHeight: CGFloat = 272
    
    private var presetLabel: UILabel!
    private var presetContainer: UICollectionView!
    fileprivate var presetButtons: [UIButton] = []
    
    private var customLabel: UILabel!
    private var customGradientView: UIView!
    fileprivate var customGradientLayer: CAGradientLayer!
    private var customGradientGrip1: GripView!
    private var customGradientGrip2: GripView!
    
    private var customGradientGrips: [GripView] = []
    private var customGradientLocations: [NSNumber] = []
    private var customGradientColours: [HSV] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addObservers()
        setupPresetLabel()
        setupPresetsContainer()
        setupCustomLabel()
        setupGradientSlider()
        setupGradientGrips()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            for presetButton in presetButtons {
                if presetButton.layer.borderWidth == 2 {
                    presetButton.layer.borderColor = UIColor.systemTint.cgColor
                } else {
                    presetButton.layer.borderColor = UIColor(named: "Border")?.cgColor
                }
            }
            
            customGradientView.layer.borderColor = UIColor(named: "Border")?.cgColor
        }
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
    
    private func setupPresetsContainer() {
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
        presetContainer.register(PresetGradientCollectionViewCell.self, forCellWithReuseIdentifier: "PresetGradientCell")
        presetContainer.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(presetContainer)
        
        NSLayoutConstraint.activate([
            presetContainer.topAnchor.constraint(equalTo: presetLabel.bottomAnchor, constant: 10),
            presetContainer.leadingAnchor.constraint(equalTo: presetLabel.leadingAnchor),
            presetContainer.widthAnchor.constraint(equalToConstant: 284),
            presetContainer.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SnippetGradient.presets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = presetContainer.dequeueReusableCell(withReuseIdentifier: "PresetGradientCell", for: indexPath) as! PresetGradientCollectionViewCell
        cell.gradient = SnippetGradient.presets[indexPath.row]
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
            customLabel.leadingAnchor.constraint(equalTo: divider.leadingAnchor, constant: 1)
        ])
    }
    
    private func setupGradientSlider() {
        customGradientView = UIView()
        customGradientView.layer.masksToBounds = true
        customGradientView.layer.cornerCurve = .continuous
        customGradientView.layer.cornerRadius = 5
        customGradientView.layer.borderWidth = 1
        customGradientView.layer.borderColor = UIColor(named: "Border")?.cgColor
        customGradientView.translatesAutoresizingMaskIntoConstraints = false
        customGradientView.addInteraction(UIToolTipInteraction(defaultToolTip: "Custom Gradient"))
        
        addSubview(customGradientView)
        
        NSLayoutConstraint.activate([
            customGradientView.topAnchor.constraint(equalTo: customLabel.bottomAnchor, constant: 10),
            customGradientView.leadingAnchor.constraint(equalTo: customLabel.leadingAnchor, constant: -1),
            customGradientView.widthAnchor.constraint(equalToConstant: 286),
            customGradientView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupGradient() {
        if let layer = customGradientLayer {
            layer.removeFromSuperlayer()
        }
        
        var colours: [CGColor] = []
        
        for colour in CacheManager.shared.gradientHSVs {
            colours.append(colour.cgColor)
        }
        
        customGradientLayer = CAGradientLayer()
        customGradientLayer.colors = colours
        customGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        customGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        customGradientLayer.locations = CacheManager.shared.gradientLocations
        customGradientLayer.frame = customGradientView.bounds
        
        customGradientView.layer.insertSublayer(customGradientLayer, at: 0)
    }
    
    fileprivate func setupGradientGrips() {
        for grip in customGradientGrips {
            grip.removeFromSuperview()
        }
        
        customGradientGrips.removeAll()
        
        customGradientLocations = CacheManager.shared.gradientLocations
        customGradientColours = CacheManager.shared.gradientHSVs
        
        for (index, location) in customGradientLocations.enumerated() {
            let colour = customGradientColours[index].cgColor
            let gripView = GripView()
            gripView.parent = self
            gripView.setPreviewColour(to: UIColor(cgColor: colour))
            gripView.translatesAutoresizingMaskIntoConstraints = false
            gripView.addInteraction(UIToolTipInteraction(defaultToolTip: "Colour \(index + 1)"))
            
            addSubview(gripView)
            
            NSLayoutConstraint.activate([
                gripView.topAnchor.constraint(equalTo: customGradientView.bottomAnchor, constant: -8),
                gripView.leadingAnchor.constraint(equalTo: customGradientView.leadingAnchor, constant: (285 * CGFloat(truncating: location)) - 7)
            ])
            
            customGradientGrips.append(gripView)
        }
    }
    
    func gripIndex(of grip: GripView) -> Int? {
        return customGradientGrips.firstIndex(of: grip)
    }
    
    func updateGradientColour(at index: Int, to colour: HSV) {
        guard let layer = customGradientLayer else {
            return
        }
        
        if var colours = layer.colors as? [CGColor] {
            CATransaction.setDisableActions(true)
            
            colours[index] = colour.cgColor
            layer.colors = colours
            
            var cacheColours = CacheManager.shared.gradientHSVs
            cacheColours[index] = colour
            
            CacheManager.shared.setGradientHSVs(to: cacheColours)
            
            if let parent = parent {
                parent.updateBackground(to: .gradient(colours: colours))
            }
        }
        
        CacheManager.shared.setRecentGradientPreset(to: 6)
        
        for button in presetButtons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(named: "Border")?.cgColor
        }
        
        PresetManager.shared.handleCustomIfNeeded()
    }
    
    @objc private func updateUI() {
        let preset = PresetManager.shared.selectedPreset
        
        guard preset["backgroundType"] as? Int == 2 else {
            return
        }
        
        if let value = preset["backgroundValue"] as? Int {
            for (index, button) in presetButtons.enumerated() {
                button.layer.borderColor = index == value ? UIColor.systemTint.cgColor : UIColor(named: "Border")?.cgColor
                button.layer.borderWidth = index == value ? 2 : 1
            }
        } else if let _ = preset["backgroundValue"] as? [Any] {
            for button in presetButtons {
                button.layer.borderColor = UIColor(named: "Border")?.cgColor
                button.layer.borderWidth = 1
            }
        }
        
        setupGradient()
        setupGradientGrips()
    }
    
    @objc private func updateTintColours() {
        for presetButton in presetButtons {
            if presetButton.layer.borderWidth == 2 {
                presetButton.layer.borderColor = UIColor.systemTint.cgColor
            }
        }
    }
}

fileprivate class PresetGradientCollectionViewCell: UICollectionViewCell {
    weak var collectionView: GradientTableViewCell!
    var gradient: SnippetGradient!
    var indexPath: IndexPath!
    var button: UIButton!
    
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
        let frame = CGRect(x: 0, y: 0, width: 83, height: 57)
        let gradientView = UIView(frame: frame)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradient.colour1.cgColor,
                                gradient.colour2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = gradientView.bounds
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        let image = image(from: gradientView)
        
        button = UIButton()
        button.backgroundColor = .red
        button.setImage(image, for: .normal)
        button.backgroundColor = .blue
        button.frame = bounds
        button.addTarget(self, action: #selector(backgroundButtonTapped), for: .touchUpInside)
        
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 5
        button.layer.borderWidth = CacheManager.shared.recentGradientPreset == indexPath.row ? 2 : 1
        button.layer.borderColor = CacheManager.shared.recentGradientPreset == indexPath.row ? UIColor.systemTint.cgColor : UIColor(named: "Border")?.cgColor
        button.layer.masksToBounds = true
        button.toolTip = "Preset Gradient \(indexPath.row + 1)"
        
        collectionView.presetButtons.append(button)
        
        addSubview(button)
    }
    
    @objc func backgroundButtonTapped() {
        guard let collectionView = collectionView else {
            return
        }
        
        let colours = [gradient.colour1.cgColor, gradient.colour2.cgColor]
        collectionView.parent?.updateBackground(to: .gradient(colours: colours))
        
        if let gradientLayer = collectionView.customGradientLayer {
            CATransaction.setDisableActions(true)
            gradientLayer.colors = colours
        }
        
        CacheManager.shared.setGradientLocations(to: [0, 1])
        CacheManager.shared.setGradientHSVs(to: [gradient.colour1, gradient.colour2])
        CacheManager.shared.setRecentGradientPreset(to: indexPath.row)
        
        for button in collectionView.presetButtons {
            button.layer.borderColor = UIColor(named: "Border")?.cgColor
            button.layer.borderWidth = 1
        }
        
        button.layer.borderColor = UIColor.systemTint.cgColor
        button.layer.borderWidth = 2
        
        collectionView.setupGradientGrips()
        PresetManager.shared.handleCustomIfNeeded()
    }
}
