//
//  AKIntegrator.swift
//  Snippet
//
//  Created by Seb Vidal on 15/05/2022.
//

import UIKit
import AppKit

final class AKIntegrator {
    static let shared = AKIntegrator()
    private var integrator = NSObject()
    
    private init() {
        guard
            let window = UIApplication.shared.currentWindow,
            let nsWindow = _nsWindow(from: window)
        else {
            return
        }
        
        let path: String = Bundle.main.builtInPlugInsURL!.appendingPathComponent("AppKitIntegration.bundle").path
        let bundle = Bundle(path: path)
        
        let principleClass: NSObject.Type = bundle?.principalClass as! NSObject.Type
        integrator = principleClass.init()
        integrator.perform(Selector("setWindow:"), with: nsWindow)
    }
    
    private func _nsWindow(from window: UIWindow) -> AnyObject? {
        guard let nsWindows = NSClassFromString("NSApplication")?.value(forKeyPath: "sharedApplication.windows") as? [AnyObject] else {
            return nil
        }
        
        for nsWindow in nsWindows {
            let uiWindows = nsWindow.value(forKeyPath: "uiWindows") as? [UIWindow] ?? []
            
            if uiWindows.contains(window) {
                return nsWindow
            }
        }
        
        return nil
    }
    
    func showWelcomeWindow() {
        integrator.perform(Selector(("showWelcomeWindow")))
    }
    
    func showThemeOverwriteAlert(_ target: NSObject, name: String) {
        integrator.perform(Selector(("setTarget:")), with: target)
        integrator.perform(Selector(("showThemeOverwriteAlert:")), with: name)
    }
    
    func showPresetOverwriteAlert(_ target: NSObject, name: String) {
        integrator.perform(Selector(("setTarget:")), with: target)
        integrator.perform(Selector(("showPresetOverwriteAlert:")), with: name)
    }
}
