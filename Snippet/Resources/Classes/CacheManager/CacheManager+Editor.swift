//
//  CacheManager+Themes.swift
//  Snippet
//
//  Created by Seb Vidal on 10/04/2022.
//

import UIKit
import Splash

extension CacheManager {
    // MARK: Language Name
    var preferredLanguageName: String {
        _loadPreferredLanguageName()
    }
    
    private func _loadPreferredLanguageName() -> String {
        if let language = defaults.string(forKey: "language") {
            return language
        }
        
        return "Swift"
    }
    
    func setPreferredLanguageName(to string: String) {
        defaults.set(string, forKey: "language")
    }
    
    // MARK: Language
    var preferredLanguage: Grammar {
        _loadPreferredLanguage()
    }
    
    private func _loadPreferredLanguage() -> Grammar {
        return languages[preferredLanguageName] ?? SwiftGrammar()
    }
    
    // MARK: Languages
    var languages: [String: Grammar] {
        _languages()
    }
    
    private func _languages() -> [String: Grammar] {
        [
            "CSS": CssGrammar(),
            "Swift": SwiftGrammar(),
            "Python": PythonGrammar(),
            "JavaScript": JavaScriptGrammar(),
            "TypeScript": TypeScriptGrammar()
        ]
    }
    
    // MARK: Themes JSON
    var themesJson: [String: Any] {
        _loadPreferredThemesJson()
    }
    
    private func _loadPreferredThemesJson() -> [String: Any] {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = path.appendingPathComponent("themes.txt")
            do {
                if try url.checkResourceIsReachable() {
                    if let json = try? JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any] {
                        return json
                    }
                }
            } catch {
                return [:]
            }
        }
        
        return [:]
    }
    
    // MARK: Theme Name
    var preferredThemeName: String {
        _loadPreferredThemeName()
    }
    
    private func _loadPreferredThemeName() -> String {
        return defaults.string(forKey: "theme") ?? "Xcode"
    }
    
    // MARK: Preferred Theme
    var preferredTheme: Theme {
        _loadPreferredTheme()
    }
    
    private func _loadPreferredTheme() -> Theme {
        let name = _loadPreferredThemeName()
        let font = _loadPreferredFont()
        
        if let theme = Theme.default(forKey: name, withFont: font) {
            return theme
        }
        
        let json = _loadPreferredThemesJson()
        let theme = Theme.from(json, named: name, withFont: font)
        
        return theme
    }
    
    func setPreferredThemeName(to theme: String) {
        defaults.set(theme, forKey: "theme")
    }
    
    // MARK: Font
    var preferredFont: Font {
        _loadPreferredFont()
    }
    
    private func _loadPreferredFont() -> Font {
        let name = _loadPreferredFontName()
        let size = _loadPreferredFontSize()
        var font = Font(size: size)
        font.resource = .preloaded(UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size))
        
        return font
    }
    
    // MARK: Font Name
    var preferredFontName: String {
        _loadPreferredFontName()
    }
    
    private func _loadPreferredFontName() -> String {
        return defaults.string(forKey: "font") ?? "SFMono-Regular"
    }
    
    func setPreferredFontName(to string: String) {
        defaults.set(string, forKey: "font")
    }
    
    // MARK: Font Size
    var preferredFontSize: CGFloat {
        _loadPreferredFontSize()
    }
    
    private func _loadPreferredFontSize() -> CGFloat {
        if defaults.keyExists(key: "fontSize") {
            return CGFloat(defaults.float(forKey: "fontSize"))
        }
        
        return 15
    }
    
    func setPreferredFontSize(to size: CGFloat) {
        defaults.set(Float(size), forKey: "fontSize")
    }
    
    // MARK: Line Numbers
    var showLineNumbers: Bool {
        _loadShowLineNumbers()
    }
    
    private func _loadShowLineNumbers() -> Bool {
        if defaults.keyExists(key: "showLineNumbers") {
            return defaults.bool(forKey: "showLineNumbers")
        }
        
        return true
    }
    
    func setShowLineNumbers(to bool: Bool) {
        defaults.set(bool, forKey: "showLineNumbers")
    }
    
    var lineNumberStart: Int {
        _loadLineNumberStart()
    }
    
    private func _loadLineNumberStart() -> Int {
        if defaults.keyExists(key: "lineStart") {
            return defaults.integer(forKey: "lineStart")
        }
        
        return 1
    }
    
    func setLineNumberStart(to int: Int) {
        defaults.set(int, forKey: "lineStart")
    }
}
