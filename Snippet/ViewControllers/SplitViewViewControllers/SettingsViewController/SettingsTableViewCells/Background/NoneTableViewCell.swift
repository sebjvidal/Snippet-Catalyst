//
//  NoneTableViewCell.swift
//  Snippet
//
//  Created by Seb Vidal on 04/02/2022.
//

import UIKit

class NoneTableViewCell: UITableViewCell, SettingsTableViewCell {
    weak var parent: SettingsViewController?
    var cellHeight: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
