//
//  BackgroundViewController.swift
//  Snippet
//
//  Created by Seb Vidal on 30/01/2022.
//

import UIKit

class BackgroundViewController: UIViewController, UIDocumentPickerDelegate {
    let backgroundSplitViewController = UISplitViewController(style: .doubleColumn)
    let canvasViewController = CanvasViewController()
    let settingsViewController = SettingsViewController()
    
    var appKitIntegration: NSObject!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        backgroundSplitViewController.viewControllers = [
            canvasViewController,
            settingsViewController
        ]
        backgroundSplitViewController.primaryBackgroundStyle = .sidebar
        
        canvasViewController.navigationController?.isNavigationBarHidden = true
        
        settingsViewController.navigationController?.isNavigationBarHidden = true
        settingsViewController.view.backgroundColor = .systemBackground
        settingsViewController.canvas = canvasViewController
        
        
        backgroundSplitViewController.preferredPrimaryColumnWidthFraction = 0.5
        
        addChild(backgroundSplitViewController)
        view.addSubview(backgroundSplitViewController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleFirstLaunch()
    }
    
    override func viewDidLayoutSubviews() {
        backgroundSplitViewController.minimumPrimaryColumnWidth = view.bounds.width
        backgroundSplitViewController.maximumPrimaryColumnWidth = view.bounds.width - 322
        backgroundSplitViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.height)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesBegan(presses, with: event)
        
        for press in presses {
            guard let key = press.key else {
                continue
            }
            
            if key.keyCode.rawValue == 6 && key.modifierFlags == [.command] {
                canvasViewController.showCopiedAlert()
                canvasViewController.resignTextViewFirstResponder()
                
                let image = canvasViewController.canvasImage()
                if let data = image.pngData() {
                    UIPasteboard.general.setData(data, forPasteboardType: "public.png")
                }
            }
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let ext = urls.first?.pathExtension.uppercased() else {
            return
        }
        
        canvasViewController.showCopiedAlert(withMessage: "Saved as \(ext)")
    }
    
    private func handleFirstLaunch() {
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            AKIntegrator.shared.showWelcomeWindow()
        }
    }
}
