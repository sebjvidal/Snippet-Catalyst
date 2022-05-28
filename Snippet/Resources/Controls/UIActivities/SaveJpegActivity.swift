//
//  SaveJpegActivity.swift
//  Snippet
//
//  Created by Seb Vidal on 10/03/2022.
//

import Foundation

import UIKit

class SaveJpegActivity: UIActivity {
    unowned var rootViewController: BackgroundViewController!
    
    init(_ rootViewController: BackgroundViewController) {
        self.rootViewController = rootViewController
    }
    
    override var activityTitle: String? {
        return "Save as JPEG"
    }
    
    override var activityImage: UIImage? {
        return UIImage(systemName: "folder")
    }
    
    var activityCategory: UIActivity.Category {
        return .share
    }
    
    override var activityType: UIActivity.ActivityType {
        return UIActivity.ActivityType.saveJpegActivity
    }
    
    override var activityViewController: UIViewController? {
        return nil
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        rootViewController.canvasViewController.resignTextViewFirstResponder()
        let image = rootViewController.canvasViewController.canvasImage()
        var title = rootViewController.canvasViewController.windowTitleText()
        
        if title.isEmpty {
            title = "Untitled"
        }
        
        guard let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        let fileManager = FileManager.default
        
        do {
            let fileURL = fileManager.temporaryDirectory.appendingPathComponent("\(title).jpeg")
            
            try data.write(to: fileURL)
            
            let controller = UIDocumentPickerViewController(forExporting: [fileURL])
            controller.delegate = rootViewController
            rootViewController.present(controller, animated: true)
        } catch {
            print("Error creating file")
        }
    }
}

extension UIActivity.ActivityType {
    static let saveJpegActivity = UIActivity.ActivityType("com.sebvidal.Snippet.saveJpegAction")
}
