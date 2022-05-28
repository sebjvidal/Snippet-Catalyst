//
//  SNTextView.swift
//  Snippet
//
//  Created by Seb Vidal on 21/04/2022.
//

import UIKit

class SNTextView: UITextView {
    weak var parent: CanvasViewController?
    
    var previousText = ""
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return  [UIKeyCommand(input: "\t", modifierFlags: .shift, action: #selector(deindent))]
    }
    
    @objc func deindent() {
        let datum = beginningOfDocument
        if let range = selectedTextRange {
            let start = offset(from: datum, to: range.start)
            let end = offset(from: datum, to: range.end)
            
            if start != end {
                let startIndex = text.index(text.startIndex, offsetBy: start)
                let endIndex = text.index(text.startIndex, offsetBy: end - 1)
                let closedRange = startIndex...endIndex
                var selection = String(text[closedRange]).replacingOccurrences(of: "\n    ", with: "\n")
                
                if selection.hasPrefix("    ") {
                    selection = String(selection.suffix(selection.count - 4))
                }
                
                text = text.replacingCharacters(in: closedRange, with: selection)
                parent?.updateTextView()
                
                selectedTextRange = textRange(
                    from: position(from: range.start, offset: 0)!,
                    to: position(from: range.end, offset: -(selection.components(separatedBy: "\n").count * 4))!
                )
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        parent?.viewDidLayoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if text != previousText {
            parent?.centreScrollView(animated: false)
            previousText = text
        }
    }
    
    func setFont(to font: UIFont) {
        self.font = font
        layoutSubviews()
    }
}
