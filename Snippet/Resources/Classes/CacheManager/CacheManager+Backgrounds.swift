//
//  CacheManager+Backgrounds.swift
//  Snippet
//
//  Created by Seb Vidal on 10/04/2022.
//

import UIKit

extension CacheManager {
    var preferredBackgroundType: String {
        _loadPreferredBackgroundType()
    }
    
    var preferredBackgroundValue: Int {
        _loadPreferredBackgroundValue()
    }
    
    private func _loadPreferredBackgroundType() -> String {
        return defaults.string(forKey: "backgroundType") ?? "Gradient"
    }
    
    private func _loadPreferredBackgroundValue() -> Int {
        let string = _loadPreferredBackgroundType()
        
        switch string {
        case "None":
            return 0
        case "Solid Colour":
            return 1
        case "Gradient":
            return 2
        case "Image":
            return 3
        default:
            return 2
        }
    }
    
    func setPreferredBackgroundType(to string: String) {
        defaults.set(string, forKey: "backgroundType")
        
        switch string {
        case "None":
            defaults.set(0, forKey: "backgroundValue")
        case "Solid Colour":
            defaults.set(1, forKey: "backgroundValue")
        case "Gradient":
            defaults.set(2, forKey: "backgroundValue")
        case "Image":
            defaults.set(3, forKey: "backgroundValue")
        default:
            defaults.set(2, forKey: "backgroundValue")
        }
    }
    
    // MARK: Background - Recently Used Colours
    var recentColours: [[Float]] {
        _loadRecentColours()
    }
    
    private func _loadRecentColours() -> [[Float]] {
        if let recentColours = defaults.array(forKey: "recentColours") as? [[Float]] {
            return recentColours
        }
        
        return []
    }
    
    func addRecentColour(withComponents components: [Float]) {
        var recentColours = _loadRecentColours()
        recentColours.insert(components, at: 0)
        
        if recentColours.count > 16 {
            defaults.set(Array(recentColours[0...15]), forKey: "recentColours")
        } else {
            defaults.set(recentColours, forKey: "recentColours")
        }
    }
    
    // MARK: Background - Most Recent Preset Background
    //    var recentPresetBackgroundImage: UIImage {
    //        _loadRecentPresetBackgroundImage()
    //    }
    
    func recentPresetBackgroundImage() async -> UIImage {
        await _loadRecentPresetBackgroundImage()
    }
    
    func _loadRecentPresetBackgroundImage() async -> UIImage {
        let name = defaults.string(forKey: "mostRecentPresetBackgroundImage") ?? "SnowLeopard"
        
        if let image = _cachedBackgroundImageWith(name: name) {
            return image
        }
        
        if let image = await _downloadedBackgroundImageWith(name: name) {
            return image
        }
        
        return UIImage()
    }
    
    private func _cachedBackgroundImageWith(name: String) -> UIImage? {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            if let urls = UIImage.presetURLs[name] {
                if urls.count > 1 {
                    // Handle dynamic images
                    let light = path.appendingPathComponent("/Wallpapers/\(name)-Light.jpg")
                    let dark = path.appendingPathComponent("/Wallpapers/\(name)-Dark.jpg")
                    
                    if let lightData = try? Data(contentsOf: light), let darkData = try? Data(contentsOf: dark) {
                        if let image = UIImage(data: lightData), let darkImage = UIImage(data: darkData) {
                            image.imageAsset?.register(darkImage, with: .init(userInterfaceStyle: .dark))
                            
                            return image
                        }
                    }
                } else {
                    // Handle static images
                    let url = path.appendingPathComponent("/Wallpapers/\(name).jpg")
                    
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        return image
                    }
                }
            }
        }
        
        return nil
    }
    
    private func _downloadedBackgroundImageWith(name: String) async -> UIImage? {
        if let urlStrings = UIImage.presetURLs[name] {
            if urlStrings.count > 1 {
                guard
                    let light = try? await _downloadImageWith(url: urlStrings.first!, named: name + "-Light"),
                    let dark = try? await _downloadImageWith(url: urlStrings.last!, named: name + "-Dark")
                else {
                    return nil
                }
                
                light.imageAsset?.register(dark, with: .init(userInterfaceStyle: .dark))
                
                return light
            } else {
                guard let image = try? await _downloadImageWith(url: urlStrings.first!, named: name) else {
                    return nil
                }
                
                return image
            }
        }
        
        return nil
    }
    
    private func _downloadImageWith(url urlString: String, named name: String) async throws -> UIImage? {
        let url = URL(string: urlString)!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let (location, _) = try await session.download(from: url)
        
        if let data = try? Data(contentsOf: location), let image = UIImage(data: data) {
            if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                if !FileManager.default.fileExists(atPath: path.appendingPathComponent("Wallpapers").path) {
                    try? FileManager.default.createDirectory(at: path.appendingPathComponent("Wallpapers"), withIntermediateDirectories: true)
                }
                
                try data.write(to: path.appendingPathComponent("/Wallpapers/\(name).jpg"))
            }
            
            return image
        }
        
        return nil
    }
    
    func setPresetBackgroundImage(to string: String) {
        defaults.set(string, forKey: "mostRecentPresetBackgroundImage")
        setPrefersCustomImage(to: false)
    }
    
    var recentPresetBackgroundImageIndex: Int {
        _loadRecentPresetBackgroundImageIndex()
    }
    
    private func _loadRecentPresetBackgroundImageIndex() -> Int {
        let name = defaults.string(forKey: "mostRecentPresetBackgroundImage") ?? "SnowLeopard"
        if let index = UIImage.presetNames.firstIndex(of: name) {
            return index
        }
        
        return 0
    }
    
    // MARK: Background - Most Recent Custom Image
    var recentCustomImage: UIImage? {
        _loadMostRecentCustomImage()
    }
    
    private func _loadMostRecentCustomImage() -> UIImage? {
        if let path = defaults.string(forKey: "customImagePath") {
            return UIImage(contentsOfFile: URL(fileURLWithPath: path).path)
        }
        
        return nil
    }
    
    func setCustomImagePath(to string: String) {
        defaults.set(string, forKey: "customImagePath")
        setPrefersCustomImage(to: true)
    }
    
    // MARK: Background - Prefers Custom Background Image
    var prefersCustomImage: Bool {
        _loadPrefersCustomBackgroundImage()
    }
    
    private func _loadPrefersCustomBackgroundImage() -> Bool {
        return defaults.bool(forKey: "prefersCustomBackground")
    }
    
    func setPrefersCustomImage(to bool: Bool) {
        defaults.set(bool, forKey: "prefersCustomBackground")
    }
}
