//
//  SizesTableViewCell.swift
//  Snippet
//
//  Created by Seb Vidal on 17/03/2022.
//

import UIKit
import AppKit

class SizesTableViewCell: UITableViewCell, SettingsTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var parent: SettingsViewController?
    var cellHeight: CGFloat = 460
    var sizeButtons: [UIButton] = []
    
    private var cellHeading: UILabel!
    private var sizeLabel: UILabel!
    private var sizeCollectionView: UICollectionView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addObservers()
        setupCellHeading()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("UpdateUI"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTintColours), name: Notification.Name("NSSystemColorsDidChangeNotification"), object: nil)
    }
    
    private func setupCellHeading() {
        cellHeading = UILabel()
        cellHeading.text = "Canvas Size"
        cellHeading.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        cellHeading.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cellHeading)
        
        NSLayoutConstraint.activate([
            cellHeading.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            cellHeading.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func setupCollectionView() {
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
        
        sizeLabel = UILabel()
        sizeLabel.text = "Aspect Ratio:"
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sizeLabel)
        
        NSLayoutConstraint.activate([
            sizeLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            sizeLabel.leadingAnchor.constraint(equalTo: cellHeading.leadingAnchor, constant: 2)
        ])
        
        let cellWidth: Double = 250 / 3
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: cellWidth, height: 75)
        
        sizeCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        sizeCollectionView.collectionViewLayout = layout
        sizeCollectionView.delegate = self
        sizeCollectionView.dataSource = self
        sizeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        sizeCollectionView.register(SizesCollectionViewCell.self, forCellWithReuseIdentifier: "SizeCell")
        sizeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(sizeCollectionView)
        
        NSLayoutConstraint.activate([
            sizeCollectionView.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 10),
            sizeCollectionView.leadingAnchor.constraint(equalTo: sizeLabel.leadingAnchor),
            sizeCollectionView.widthAnchor.constraint(equalToConstant: 284),
            sizeCollectionView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Size.defaults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sizeCollectionView.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath) as! SizesCollectionViewCell
        cell.size = Size.defaults[indexPath.row]
        cell.indexPath = indexPath
        cell.collectionView = self
        cell.setupCell()
        
        return cell
    }
    
    @objc private func updateUI() {
        for (index, button) in sizeButtons.enumerated() {
            let value = CacheManager.shared.preferredSize
            button.layer.borderWidth = value == index ? 2 : 1
            button.layer.borderColor = value == index ? UIColor.systemTint.cgColor : UIColor(named: "Border")?.cgColor
        }
    }
    
    @objc private func updateTintColours() {
        for button in sizeButtons where button.layer.borderWidth == 2 {
            button.layer.borderColor = UIColor.systemTint.cgColor
        }
    }
}

struct Size {
    var name: String
    var image: String
    var width: Double
    var height: Double
    
    static let defaults: [Size] = [
        Size(name: "Fit", image: "Fit", width: 0, height: 0),
        Size(name: "1:1", image: "1-1", width: 1, height: 1),
        Size(name: "4:3", image: "4-3", width: 4, height: 3),
        Size(name: "3:4", image: "3-4", width: 3, height: 4),
        Size(name: "16:9", image: "16-9", width: 16, height: 9),
        Size(name: "9:16", image: "9-16", width: 9, height: 16),
        Size(name: "Twitter", image: "Twitter-Post", width: 16, height: 9),
        Size(name: "Twitter Banner", image: "Twitter-Banner", width: 3, height: 1),
        Size(name: "Pinterest", image: "Pinterest", width: 2, height: 3),
        Size(name: "Instagram\nPortrait", image: "Instagram-Portrait", width: 4, height: 5),
        Size(name: "Instagram\nLandscape", image: "Instagram-Landscape", width: 1.91, height: 1)
    ]
}

fileprivate class SizesCollectionViewCell: UICollectionViewCell {
    weak var collectionView: SizesTableViewCell!
    var indexPath: IndexPath!
    var size: Size!
    var button: UIButton!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if button.layer.borderWidth == 2 {
            button.layer.borderColor = UIColor.systemTint.cgColor
        } else {
            button.layer.borderColor = UIColor(named: "Border")!.cgColor
        }
    }
    
    func setupCell() {
        button = UIButton()
        button.toolTip = size.name
        button.setImage(UIImage(named: size.image), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 83, height: 57)
        button.addTarget(self, action: #selector(sizeButtonTapped), for: .touchUpInside)
        
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 5
        button.layer.borderWidth = shouldHighlight() ? 2 : 1
        button.layer.borderColor = shouldHighlight() ? UIColor.systemTint.cgColor : UIColor(named: "Border")?.cgColor
        button.layer.masksToBounds = true
        
        collectionView.sizeButtons.append(button)
        
        addSubview(button)
        
        label = UILabel()
        label.text = size.name
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc func sizeButtonTapped() {
        CacheManager.shared.setupPreferredSize(to: indexPath.row)
        PresetManager.shared.handleCustomIfNeeded()
        
        for button in collectionView.sizeButtons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(named: "Border")?.cgColor
        }
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemTint.cgColor
        
        collectionView.parent?.canvas?.updateBackgroundSize()
    }
    
    func shouldHighlight() -> Bool {
        return CacheManager.shared.preferredSize == indexPath.row
    }
}
