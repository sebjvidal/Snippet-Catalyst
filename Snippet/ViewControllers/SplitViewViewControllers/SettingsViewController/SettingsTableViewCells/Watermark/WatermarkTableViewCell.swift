//
//  WatermarkTableViewCell.swift
//  Snippet
//
//  Created by Seb Vidal on 28/03/2022.
//

import UIKit

class WatermarkTableViewCell: UITableViewCell, SettingsTableViewCell {
    var cellHeight: CGFloat = 300
    weak var parent: SettingsViewController?
    
    private var cellHeading: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addObservers()
        setupCellHeading()
        tempFunc()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("UpdateUI"), object: nil)
    }
    
    private func setupCellHeading() {
        cellHeading = UILabel()
        cellHeading.text = "Watermark"
        cellHeading.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        cellHeading.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cellHeading)
        
        NSLayoutConstraint.activate([
            cellHeading.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            cellHeading.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func tempFunc() {
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
    }
    
    @objc private func updateUI() {}
}
