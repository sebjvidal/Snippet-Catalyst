//
//  DocumentPickerViewController.swift
//  Snippet
//
//  Created by Seb Vidal on 08/02/2022.
//

import UIKit
import UniformTypeIdentifiers

class DocumentPickerViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate {
    private let onPick: (URL) -> ()
    
    init(supportedTypes: [UTType], directorURL url: URL?, onPick: @escaping (URL) -> Void) {
        self.onPick = onPick
        
        super.init(forOpeningContentTypes: supportedTypes, asCopy: false)
        directoryURL = url
        allowsMultipleSelection = false
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        onPick(urls.first!)
    }
}
