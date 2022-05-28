//
//  SettingsViewController.swift
//  Snippet
//
//  Created by Seb Vidal on 03/02/2022.
//

import UIKit
import Darwin

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var canvas: CanvasViewController?
    
    private var divider: UIView!
    private var tableView: UITableView!
    private var tableViewSelection: Int = 0
    private let tableViewCells: [SettingsTableViewCell] = [
        WindowTableViewCell(),
        LanguageTableViewCell(),
        BackgroundTableViewCell(),
        SizesTableViewCell(),
        WatermarkTableViewCell()
    ]
    
    private var tableViewAccessorySelection: Int = CacheManager.shared.preferredBackgroundValue
    private var tableViewAccessoryCells: [SettingsTableViewCell] = [
        SolidColourTableViewCell(),
        GradientTableViewCell(),
        ImageTableViewCell()
    ]
    
    var preferredSolidColour: CGColor!
    var preferredGradient: [CGColor]!
    var preferredImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        setupDivider()
        setupTableView()
    }
    
    private func loadPreferredSolidColour() {
        let index = CacheManager.shared.preferredPresetSolidColour
        
        if index < 6 {
            preferredSolidColour = CGColor.presets[index]
        } else {
            preferredSolidColour = CacheManager.shared.preferredCustomSolidColour
        }
        
        if tableViewAccessorySelection == 1 {
            updateBackground(to: .solid(colour: preferredSolidColour))
        }
    }
    
    private func loadPreferredGradient() {
        preferredGradient = CacheManager.shared.gradientColours
        
        if tableViewAccessorySelection == 2 {
            updateBackground(to: .gradient(colours: preferredGradient))
        }
    }
    
    private func loadPreferredImage() {
        Task {
            if CacheManager.shared.prefersCustomImage {
                preferredImage = CacheManager.shared.recentCustomImage
            } else {
                let image = await CacheManager.shared.recentPresetBackgroundImage()
                preferredImage = image
            }
            
            DispatchQueue.main.async { [unowned self] in
                if self.tableViewAccessorySelection == 3 {
                    self.updateBackground(to: .image(image: preferredImage))
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPreferredSolidColour()
        loadPreferredGradient()
        loadPreferredImage()
        
        if tableViewAccessorySelection == 0 {
            updateBackground(to: BackgroundContent.none)
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("UpdateUI"), object: nil)
    }
    
    func updateTab(to id: Int) {
        tableViewSelection = id
        tableView.reloadData()
    }
    
    func setupDivider() {
        divider = UIView()
        divider.backgroundColor = UIColor(named: "ToolbarDivider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: view.topAnchor),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.widthAnchor.constraint(equalToConstant: 322),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewSelection == 2 {
            if tableViewAccessorySelection == 0 {
                return 1
            } else {
                return 2
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell: SettingsTableViewCell!

        if indexPath.row == 0 {
            tableViewCell = tableViewCells[tableViewSelection]
        } else {
            tableViewCell = tableViewAccessoryCells[tableViewAccessorySelection - 1]
        }
        
        tableViewCell.parent = self
        
        let cell = tableViewCell as! UITableViewCell
        if tableView.numberOfRows(inSection: indexPath.section) == 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            if indexPath.row == 0 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let cell = tableViewCells[tableViewSelection]
            
            return cell.cellHeight
        } else {
            let cell = tableViewAccessoryCells[tableViewAccessorySelection - 1]
            
            return cell.cellHeight
        }
    }
    
    func updateAccessorySelection(with value: Int) {
        switch value {
        case 0:
            updateBackground(to: BackgroundContent.none)
        case 1:
            updateBackground(to: .solid(colour: preferredSolidColour))
        case 2:
            updateBackground(to: .gradient(colours: CacheManager.shared.gradientColours))
        case 3:
            updateBackground(to: .image(image: preferredImage!))
        default:
            break
        }
        
        tableViewAccessorySelection = value
        tableView.reloadData()
    }
    
    func updateBackground(to type: BackgroundContent) {
        switch type {
        case .none:
            canvas?.setNoneBackground()
        case .solid(let colour):
            preferredSolidColour = colour
            canvas?.setSolidColour(colour: colour)
        case .gradient(let colours):
            preferredGradient = colours
            canvas?.setGradient(colours: colours)
        case .image(let image):
            preferredImage = image
            canvas?.setImage(image: image)
        }
    }
    
    func updateBackground(to type: BackgroundType) {
        switch type {
        case .none:
            canvas?.setNoneBackground()
        case .solid:
            canvas?.setSolidColour(colour: preferredSolidColour)
        case .gradient:
            canvas?.setGradient(colours: preferredGradient)
        case .image:
            canvas?.setImage(image: preferredImage)
        }
    }
    
    @objc private func updateUI() {
        tableViewAccessorySelection = CacheManager.shared.preferredBackgroundValue
        tableView.reloadData()
    }
}
