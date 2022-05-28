//
//  AppKitIntegration.swift
//  AppKitIntegration
//
//  Created by Seb Vidal on 13/05/2022.
//

import Cocoa

@objc class AppKitIntegration: NSObject {
    private var target: NSObject?
    private var _nsWindow: NSWindow?
    private var _window: AnyObject? {
        get { return _nsWindow }
        set { _nsWindow = nsWindowBridge(for: newValue) }
    }
    
    private var contentView: NSView? {
        return _nsWindow?.contentView
    }
    
    private func nsWindowBridge(for object: AnyObject?) -> NSWindow? {
        return object as? NSWindow
    }
    
    public override init() {
        super.init()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    @objc public func setWindow(_ window: AnyObject?) {
        self._window = window
    }
    
    @objc public func setTarget(_ target: NSObject) {
        self.target = target
    }
    
    @objc public func showWelcomeWindow() {
        let welcomeViewController = WelcomeViewController()
//        welcomeViewController.resiz
        _nsWindow?.preventsApplicationTerminationWhenModal = false
        _nsWindow?.contentViewController?.presentAsSheet(welcomeViewController)
    }
    
    @objc public func showThemeOverwriteAlert(_ name: String) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = "\"\(name)\" already exsists. Do you want to replace it?"
        alert.informativeText = "A theme with the same name already exists. Replacing it will override its current contents."
        alert.addButton(withTitle: "Replace")
        alert.addButton(withTitle: "Cancel")
        alert.buttons.first?.hasDestructiveAction = true
        alert.buttons.first?.keyEquivalent = ""
        alert.buttons.last?.keyEquivalent = "\r"
        
        alert.beginSheetModal(for: _nsWindow!) { [weak self] response in
            if response.rawValue == 1000 {
                self?.target?.perform(Selector(("saveData")))
            }
        }
        
        alert.accessoryView?.addSubview(alert.buttons.last!)
        
        dump(alert.buttons.last?.superview)
    }
    
    @objc public func showPresetOverwriteAlert(_ name: String) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = "\"\(name)\" already exsists. Do you want to replace it?"
        alert.informativeText = "A preset with the same name already exists. Replacing it will override its current contents."
        alert.addButton(withTitle: "Replace")
        alert.addButton(withTitle: "Cancel")
        alert.buttons.first?.hasDestructiveAction = true
        alert.buttons.first?.keyEquivalent = ""
        alert.buttons.last?.keyEquivalent = "\r"
        
        alert.beginSheetModal(for: _nsWindow!) { [weak self] response in
            if response.rawValue == 1000 {
                self?.target?.perform(Selector(("saveData")))
            }
        }
    }
}
