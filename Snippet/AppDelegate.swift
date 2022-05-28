//
//  AppDelegate.swift
//  Snippet
//
//  Created by Seb Vidal on 30/01/2022.
//

import UIKit
import AppKit

@main class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        
        // Edit
        builder.remove(menu: .spelling)
        builder.remove(menu: .substitutions)
        builder.remove(menu: .transformations)
        builder.remove(menu: .speech)
        
        // Format
        builder.remove(menu: .format)
        
        // View
        builder.remove(menu: .sidebar)
        builder.remove(menu: .toolbar)
        
        // Help
        builder.remove(menu: .help)
    }
}
 
