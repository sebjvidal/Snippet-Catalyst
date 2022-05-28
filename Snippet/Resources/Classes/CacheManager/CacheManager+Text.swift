//
//  CacheManager+Text.swift
//  Snippet
//
//  Created by Seb Vidal on 10/04/2022.
//

import Foundation

extension CacheManager {
    // MARK: Editor Text
    var editorText: String {
        _loadEditorText()
    }
    
    private func _loadEditorText() -> String {
        if defaults.keyExists(key: "editorText") {
            if defaults.string(forKey: "editorText") == "" {
                return zeroState
            } else {
                return defaults.string(forKey: "editorText") ?? zeroState
            }
        } else {
            return zeroState
        }
    }
    
    func setEditorText(to string: String) {
        defaults.set(string, forKey: "editorText")
    }
    
    // MARK: Zero State Text
    var zeroState: String {
        _loadZeroState()
    }
    
    private func _loadZeroState() -> String {
        return """
//
//  Untitled.swift
//  Snippet
//
//  Created by \(NSFullUserName()) on \(Date.now.formatted(date: .numeric, time: .omitted)).
//

import SwiftUI

struct Snippet: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Welcome to Snippet")
                .font(.title)
            
            Text("Create beautiful screenshots of your code!")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            Button("Get Started") {
                getStarted()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    func getStarted() {
        print("Start typing to create your first Snippet")
    }
}
"""
    }
}
