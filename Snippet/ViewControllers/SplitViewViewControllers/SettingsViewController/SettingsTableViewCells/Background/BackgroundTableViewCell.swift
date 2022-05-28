//
//  BackgroundTableViewCell.swift
//  Snippet
//
//  Created by Seb Vidal on 01/02/2022.
//

import UIKit
import SwiftUI

class BackgroundTableViewCell: UITableViewCell, SettingsTableViewCell {
    weak var parent: SettingsViewController?
    var cellHeight: CGFloat = 114
    
    private var cellHeading: UILabel!
    
    private var backgroundLabel: UILabel!
    private var backgroundPicker: UIButton!
    private var backgroundPickerOptions = [
        "None",
        "Solid Colour",
        "Gradient",
        "Image"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addObservers()
        setupCellHeading()
        setupBackgroundLabel()
        setupBackgroundComboBox()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("UpdateUI"), object: nil)
    }
    
    func setupCellHeading() {
        cellHeading = UILabel()
        cellHeading.text = "Background"
        cellHeading.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        cellHeading.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cellHeading)
        
        NSLayoutConstraint.activate([
            cellHeading.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            cellHeading.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }

    func setupBackgroundLabel() {
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
        
        backgroundLabel = UILabel()
        backgroundLabel.text = "Background:"
        backgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundLabel)
        
        NSLayoutConstraint.activate([
            backgroundLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            backgroundLabel.leadingAnchor.constraint(equalTo: cellHeading.leadingAnchor, constant: 2)
        ])
    }
    
    func setupBackgroundComboBox() {
        backgroundPicker = UIButton(type: .system)
        backgroundPicker.toolTip = "Background Type"
        backgroundPicker.showsMenuAsPrimaryAction = true
        backgroundPicker.changesSelectionAsPrimaryAction = true
        backgroundPicker.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(backgroundPicker)
        
        NSLayoutConstraint.activate([
            backgroundPicker.topAnchor.constraint(equalTo: backgroundLabel.bottomAnchor, constant: 10),
            backgroundPicker.leadingAnchor.constraint(equalTo: backgroundLabel.leadingAnchor),
            backgroundPicker.widthAnchor.constraint(equalToConstant: 284)
        ])
        
        updateBackgroundComboBox()
    }
    
    func updateBackgroundComboBox() {
        var children: [UIAction] = []
        
        for (index, option) in backgroundPickerOptions.enumerated() {
            let action = UIAction(title: option) { [weak self] _ in
                self?.parent?.updateAccessorySelection(with: index)
                CacheManager.shared.setPreferredBackgroundType(to: option)
                PresetManager.shared.handleCustomIfNeeded()
            }
            
            action.state = CacheManager.shared.preferredBackgroundType == option ? .on : .off
            
            children.append(action)
        }
        
        let menu = UIMenu(title: "Background", children: children)
        backgroundPicker.menu = menu
    }
    
    @objc private func updateUI() {
        updateBackgroundComboBox()
    }
}
