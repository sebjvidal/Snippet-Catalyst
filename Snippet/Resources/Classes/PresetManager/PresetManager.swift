//
//  PresetManager.swift
//  Snippet
//
//  Created by Seb Vidal on 21/03/2022.
//

import UIKit

class PresetManager {
    static let shared = PresetManager()
    private let defaults = UserDefaults.standard
    
    var selectedPreset: [String: Any] {
        if let current = _loadPresets()[selectedPresetName] as? [String: Any] {
            return current
        } else {
            return _defaultPreset()
        }
    }
    
    // Selected Preset name
    var selectedPresetName: String {
        return defaults.string(forKey: "preset") ?? "Default"
    }
    
    func setSelectedPreset(to name: String) {
        defaults.set(name, forKey: "preset")
    }
    
    // Default Preset data
    var defaultPreset: [String: Any] {
        _defaultPreset()
    }
    
    private func _defaultPreset() -> [String: Any] {
        return [
            "title": "Untitled",
            "showIcon": false,
            "appearance": 0,
            "controls": 0,
            "symbols": false,
            "opacity": 0.75,
            "vPadding": 64,
            "hPadding": 64,
            "matchedPadding": true,
            "language": "Swift",
            "theme": "Xcode",
            "font": "SFMono-Regular",
            "fontSize": 15.0,
            "backgroundType": 2,
            "backgroundValue": 0,
            "aspectRatio": 0,
            "showLineNumbers": false,
            "lineNumberStart": 1
        ]
    }
    
    // All custom Presets
    var presets: [String: Any] {
        var data = _loadPresets()
        data["Default"] = defaultPreset
        
        return data
    }
    
    private func _loadPresets() -> [String: Any] {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return [:]
        }
        
        let url = path.appendingPathComponent("presets.txt")
        
        if FileManager.default.fileExists(atPath: url.path) {
            if let json = try? JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any] {
                return json
            }
        } else {
            return [:]
        }
        
        return [:]
    }
    
    // All custom Preset names
    var presetNames: [String] {
        presets.keys.sorted()
    }
}

// MARK: PresetManager - Save new preset
extension PresetManager {
    func savePreset(named name: String) {
        let cache = CacheManager.shared
        let data: [String: Any] = [
            "title": cache.preferredTitle,
            "showIcon": cache.prefersIconVisible,
            "appearance": cache.preferredAppearance,
            "controls": cache.preferredControlsStyle,
            "symbols": cache.showControlsSymbols,
            "opacity": cache.preferredWindowOpacity,
            "vPadding": cache.preferredVerticalPadding,
            "hPadding": cache.preferredVerticalPadding,
            "matchedPadding": cache.prefersMatchedPadding,
            "language": cache.preferredLanguageName,
            "theme": cache.preferredThemeName,
            "font": cache.preferredFontName,
            "fontSize": cache.preferredFontSize,
            "backgroundType": cache.preferredBackgroundValue,
            "backgroundValue": _backgroundValue(),
            "aspectRatio": cache.preferredSize,
            "showLineNumbers": cache.showLineNumbers,
            "lineNumberStart": cache.lineNumberStart
        ]
        
        var existingJson = _loadPresets()
        existingJson[name] = data
        
        _savePresets(withData: existingJson)
    }
    
    private func _backgroundValue()  -> Any {
        let cache = CacheManager.shared
        let type = cache.preferredBackgroundValue
        
        switch type {
        case 1:
            if cache.preferredPresetSolidColour > 5 {
                return cache.preferredCustomSolidHSV
            } else {
                return cache.preferredPresetSolidColour
            }
        case 2:
            if cache.recentGradientPreset > 5 {
                return [cache.gradientLocations, cache.gradientValues]
            } else {
                return cache.recentGradientPreset
            }
        case 3:
            if cache.prefersCustomImage {
                return defaults.string(forKey: "customImagePath") ?? ""
            } else {
                return cache.recentPresetBackgroundImageIndex
            }
        default:
            return 0
        }
    }
    
    private func _savePresets(withData data: [String: Any]) {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = path.appendingPathComponent("presets.txt")
            
            try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted).write(to: url)
        }
    }
}

// MARK: PresetManager - Delete existing preset
extension PresetManager {
    func deletePreset(named name: String) {
        var data = _loadPresets()
        data[name] = nil
        
        _savePresets(withData: data)
    }
}

// MARK: PresetManager - Handle "Custom" switching
extension PresetManager {
    // Switch to a "Custom" preset if the selected preset is "Default".
    func handleCustomIfNeeded() {
        savePreset(named: "Custom")
        setSelectedPreset(to: "Custom")
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.updatePresetToolbarItem()
            sceneDelegate.updateAddToolbarItem()
        }
    }
}
