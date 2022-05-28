//
//  SceneDelegate.swift
//  Snippet
//
//  Created by Seb Vidal on 30/01/2022.
//

import UIKit
import AppKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, NSToolbarDelegate, UIActivityItemsConfigurationReading {
    var window: UIWindow?
    var toolbar: NSToolbar!
    
    fileprivate let backgroundViewController = BackgroundViewController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = backgroundViewController
            self.window = window
            window.makeKeyAndVisible()
        }
        
        #if targetEnvironment(macCatalyst)
        setupToolbar()
        #endif
    }
    
    #if targetEnvironment(macCatalyst)
    func setupToolbar() {
        toolbar = NSToolbar()
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        window?.windowScene?.titlebar?.toolbar = toolbar
        window?.windowScene?.titlebar?.toolbarStyle = .unified
        window?.windowScene?.titlebar?.titleVisibility = .hidden
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier("presets"),
            NSToolbarItem.Identifier("add"),
            .flexibleSpace,
            NSToolbarItem.Identifier("copyButton"),
            NSToolbarItem.Identifier("shareButton"),
            NSToolbarItem.Identifier.primarySidebarTrackingSeparatorItemIdentifier,
            .flexibleSpace,
            .flexibleSpace,
            NSToolbarItem.Identifier("tabGroup"),
            .flexibleSpace
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarDefaultItemIdentifiers(toolbar)
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case NSToolbarItem.Identifier("presets"):
            let titles = PresetManager.shared.presetNames
            let selection = titles.firstIndex(of: PresetManager.shared.selectedPresetName) ?? 0
            let toolbarItem = NSToolbarItemGroup(itemIdentifier: itemIdentifier, titles: titles, selectionMode: .selectOne, labels: titles, target: self, action: #selector(presetChanged))
            toolbarItem.toolTip = "Presets"
            toolbarItem.selectedIndex = selection
            toolbarItem.controlRepresentation = .collapsed
  
            return toolbarItem
        case NSToolbarItem.Identifier("add"):
            let newAction = UIAction(title: "Save New Preset", image: UIImage(systemName: "plus")) { [weak self] _ in self?.newPreset() }
            let deleteAction = UIAction(title: "Delete Selected Preset", image: UIImage(systemName: "trash")) { [weak self] _ in self?.deletePreset() }
            
            if let group = toolbar.items[0] as? NSToolbarItemGroup {
                if ["Default"].contains(group.subitems[group.selectedIndex].title) {
                    deleteAction.attributes = [.disabled]
                }
            }
            
            let menu = UIMenu(title: "Presets", children: [newAction, deleteAction])
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newPreset))
            let toolbarItem = NSMenuToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barButtonItem)
            toolbarItem.itemMenu = menu
            toolbarItem.toolTip = "New Preset"
            toolbarItem.showsIndicator = true
            toolbarItem.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(scale: .default))
            
            return toolbarItem
        case NSToolbarItem.Identifier("copyButton"):
            let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold, scale: .default)
            let barButtonitem = UIBarButtonItem(image: UIImage(systemName: "doc.on.clipboard", withConfiguration: config), style: .plain, target: self, action: #selector(copyItem))
            let toolBarItem = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barButtonitem)
            toolBarItem.toolTip = "Copy to Clipboard"
            
            return toolBarItem
        case NSToolbarItem.Identifier("shareButton"):
            let barButtonItem = NSSharingServicePickerToolbarItem(itemIdentifier: itemIdentifier)
            barButtonItem.activityItemsConfiguration = self
            barButtonItem.toolTip = "Share"
            
            return barButtonItem
        case NSToolbarItem.Identifier("tabGroup"):
            let images = [
                UIImage(systemName: "macwindow")!,
                UIImage(systemName: "text.alignleft")!,
                UIImage(systemName: "square.2.stack.3d")!,
                UIImage(systemName: "rectangle.3.group")!,
//                UIImage(systemName: "checkmark.seal")!
            ]
            
            let group = NSToolbarItemGroup(itemIdentifier: itemIdentifier, images: images, selectionMode: .selectOne, labels: [], target: self, action: #selector(tabTapped(_:)))
            group.setSelected(true, at: 0)
            group.subitems[0].toolTip = "Window"
            group.subitems[1].toolTip = "Editor"
            group.subitems[2].toolTip = "Background"
            group.subitems[3].toolTip = "Canvas Size"
//            group.subitems[4].toolTip = "Watermark"
            
            return group
        default:
            break
        }
        
        return NSToolbarItem(itemIdentifier: itemIdentifier)
    }
    
    @objc func presetChanged() {
        guard let toolbarItem = toolbar.items[0] as? NSToolbarItemGroup else {
            return
        }
        
        let name = toolbarItem.subitems[toolbarItem.selectedIndex].title
        PresetManager.shared.setSelectedPreset(to: name)
        updateAddToolbarItem()
        NotificationCenter.default.post(name: NSNotification.Name("PresetChanged"), object: nil)
    }
    
    @objc func newPreset() {
        let presetViewController = NewPresetViewController()
        presetViewController.presetSource = backgroundViewController
        presetViewController.preferredContentSize = CGSize(width: 500, height: 178)
        
        backgroundViewController.present(presetViewController, animated: true)
    }
    
    @objc func deletePreset() {
        guard let toolbarItem = toolbar.items[0] as? NSToolbarItemGroup else {
            return
        }
        
        let title = "Are you sure you want to delete \"\(toolbarItem.subitems[toolbarItem.selectedIndex].title)\"?"
        let message = "This preset will be deleted permanently. You can't undo this action."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in self?.deletePresetData() })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in return })
        alert.preferredAction = alert.actions.last
        
        backgroundViewController.present(alert, animated: true)
    }
    
    func deletePresetData() {
        guard let toolbarItem = toolbar.items[0] as? NSToolbarItemGroup else {
            return
        }
        
        let name = toolbarItem.subitems[toolbarItem.selectedIndex].title
        PresetManager.shared.deletePreset(named: name)
        PresetManager.shared.setSelectedPreset(to: "Default")
        updatePresetToolbarItem()
        updateAddToolbarItem()
        presetChanged()
    }
    
    func updatePresetToolbarItem() {
        toolbar.removeItem(at: 0)
        toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier("presets"), at: 0)
    }
    
    func updateAddToolbarItem() {
        toolbar.removeItem(at: 1)
        toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier("add"), at: 1)
    }
    
    @objc private func copyItem() {
        backgroundViewController.canvasViewController.showCopiedAlert()
        backgroundViewController.canvasViewController.resignTextViewFirstResponder()

        let image = backgroundViewController.canvasViewController.canvasImage()
        
        if let data = image.pngData() {
            UIPasteboard.general.setData(data, forPasteboardType: "public.png")
        }
    }
    
    var itemProvider: NSItemProvider {
        let canvasItemProvider = CanvasItemProvider()
        canvasItemProvider.canvasViewController = backgroundViewController.canvasViewController
        
        let itemProvider = NSItemProvider(object: canvasItemProvider)
        itemProvider.registerObject(canvasItemProvider, visibility: .ownProcess)

        return itemProvider
    }
    
    var itemProvidersForActivityItemsConfiguration: [NSItemProvider] {
        return [itemProvider]
    }
    
    var applicationActivitiesForActivityItemsConfiguration: [UIActivity]? {
        let vc = backgroundViewController
        
        return [
            SavePngActivity(vc),
            SaveJpegActivity(vc),
            CopyToClipboardActivity(vc),
            CopyTextToClipboardActivity(vc)
        ]
    }
    
    @objc func tabTapped(_ sender: NSToolbarItemGroup) {
        backgroundViewController.settingsViewController.updateTab(to: sender.selectedIndex)
    }
    #endif
}

class CanvasItemProvider: NSObject, NSItemProviderWriting {
    weak var canvasViewController: CanvasViewController?
    
    static var writableTypeIdentifiersForItemProvider: [String] = ["public.png"]
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let image = canvasViewController?.canvasImage()
        let data = image?.pngData()
        
        completionHandler(data, nil)
        
        return nil
    }
}
