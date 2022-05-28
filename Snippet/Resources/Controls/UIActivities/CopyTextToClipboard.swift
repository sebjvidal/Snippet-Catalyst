//
//  CopyTextToClipboard.swift
//  Snippet
//
//  Created by Seb Vidal on 21/05/2022.
//

import UIKit

class CopyTextToClipboardActivity: UIActivity {
    weak var rootViewController: BackgroundViewController?
    
    init(_ rootViewController: BackgroundViewController) {
        self.rootViewController = rootViewController
    }
    
    override var activityTitle: String? {
        return "Copy Text to Clipboard"
    }
    
    override var activityImage: UIImage? {
        return UIImage(named: "text.doc.on.clipboard")
    }
    
    var activityCategory: UIActivity.Category {
        return .share
    }
    
    override var activityType: UIActivity.ActivityType {
        return UIActivity.ActivityType.copyTextToClipboard
    }
    
    override var activityViewController: UIViewController? {
        return nil
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        let message = "Copied Text to Clipboard"
        
        rootViewController?.canvasViewController.showCopiedAlert(withMessage: message)
        rootViewController?.canvasViewController.resignTextViewFirstResponder()
        if let image = rootViewController?.canvasViewController.textImage(),
           let data = image.pngData() {
            UIPasteboard.general.setData(data, forPasteboardType: "public.png")
        }
    }
}

extension UIActivity.ActivityType {
    static let copyTextToClipboard = UIActivity.ActivityType("com.sebvidal.Snippet.copyTextToClipboard")
}
