//
//  CopyToClipboard.swift
//  Snippet
//
//  Created by Seb Vidal on 02/02/2022.
//

import UIKit

class CopyToClipboardActivity: UIActivity {
    weak var rootViewController: BackgroundViewController?
    
    init(_ rootViewController: BackgroundViewController) {
        self.rootViewController = rootViewController
    }
    
    override var activityTitle: String? {
        return "Copy to Clipboard"
    }
    
    override var activityImage: UIImage? {
        return UIImage(systemName: "doc.on.clipboard")
    }
    
    var activityCategory: UIActivity.Category {
        return .share
    }
    
    override var activityType: UIActivity.ActivityType {
        return UIActivity.ActivityType.copyToClipboard
    }
    
    override var activityViewController: UIViewController? {
        return nil
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        rootViewController?.canvasViewController.showCopiedAlert()
        rootViewController?.canvasViewController.resignTextViewFirstResponder()
        if let image = rootViewController?.canvasViewController.canvasImage(),
           let data = image.pngData() {
            UIPasteboard.general.setData(data, forPasteboardType: "public.png")
        }
    }
}

extension UIActivity.ActivityType {
    static let copyToClipboard = UIActivity.ActivityType("com.sebvidal.Snippet.copyToClipboard")
}
