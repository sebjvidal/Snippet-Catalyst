//
//  SettingsTableViewCell.swift
//  Snippet
//
//  Created by Seb Vidal on 31/01/2022.
//

import UIKit

protocol SettingsTableViewCell {
    var parent: SettingsViewController? { get set }
    var cellHeight: CGFloat { get set }
}
