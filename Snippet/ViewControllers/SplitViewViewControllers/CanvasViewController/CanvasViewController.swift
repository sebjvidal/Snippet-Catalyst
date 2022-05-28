//
//  CanvasViewController.swift
//  Snippet
//
//  Created by Seb Vidal on 30/01/2022.
//

import UIKit
import Splash

class CanvasViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    private var scrollView: UIScrollView!
    private var backgroundView: SNImageView!
    private var transparentView: UIView!
    private var gradientLayer: CAGradientLayer?
    
    private var sparky: UIImageView?
    private var windowContainer: UIView!
    private var window: UIVisualEffectView!
    private var windowUnderlay: UIView!
    
    private var theme: Theme = CacheManager.shared.preferredTheme
    private var language: Grammar = CacheManager.shared.preferredLanguage
    private var editorContainer: UIView!
    private var lineNumberGutter: UITextView!
    private var textEditor: SNTextView!
    
    private var closeButton: UIImageView!
    private var minimiseButton: UIImageView!
    private var restoreButton: UIImageView!
    private var closeSymbol: UIImageView!
    private var minimiseSymbol: UIImageView!
    private var restoreSymbol: UIImageView!
    
    private var windowTitle: UILabel!
    private var windowIcon: UIImageView!
    private var windowStackView: UIStackView!
    
    private var zoomContainerView: UIView!
    private var zoomDarkImageView: UIImageView!
    private var zoomImageView: UIImageView!
    private var zoomOverlay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPresetObserver()
        setupScrollView()
        setupBackgroundView()
        setupTransparentView()
        setupWindowContainerView()
        setupWindowVisualEffectView()
        setupWindowUnderlay()
        setupWindowBorder()
        setupWindowControls()
        setupWindowControlsSymbols()
        setupWindowTitle()
        setupEditorContainer()
        setupLineNumberGutter()
        setupTextEditor()
        setupSparky()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if CacheManager.shared.preferredSize != 0 {
            layoutBackgroundSize()
            updateBackgroundPosition()
        } else {
            updateBackgroundFit()
        }

        updateScrollViewContentSize()
        updateLineNumbers()
        
        if CacheManager.shared.preferredBackgroundValue == 2 {
            setupGradient()
        }
        
        nudgeSparky()
    }
    
    private func layoutBackgroundSize() {
        let hPadding = CGFloat(CacheManager.shared.preferredHorizontalPadding * 4)
        let vPadding = CGFloat(CacheManager.shared.preferredVerticalPadding * 4)
        
        let size = Size.defaults[CacheManager.shared.preferredSize]
        let aspectRatio = CGFloat(size.width) / CGFloat(size.height)
        let ratioAspect = CGFloat(size.height) / CGFloat(size.width)
        
        if aspectRatio.isNaN || ratioAspect.isNaN {
            return
        }
        
        // MARK: Handle backgroundView size
        if window.frame.height + vPadding > backgroundView.frame.height {
            let height = window.frame.height + vPadding
            let width = height * aspectRatio
            
            backgroundView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        } else if window.frame.height + vPadding < backgroundView.frame.height {
            let height = window.frame.height + vPadding
            let width = height * aspectRatio
            
            backgroundView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
        
        if window.frame.width + hPadding > backgroundView.frame.width {
            let width = window.frame.width + hPadding
            let height = width * ratioAspect
            
            backgroundView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
    }
    
    private func updateBackgroundPosition() {
        // MARK: Handle backgroundView position
        let width = backgroundView.frame.width
        let height = backgroundView.frame.height
        
        if backgroundView.frame.width < scrollView.frame.width {
            backgroundView.frame = CGRect(x: (scrollView.frame.width / 2) - (width / 2), y: backgroundView.frame.minY, width: width, height: height)
        } else {
            backgroundView.frame = CGRect(x: 0, y: backgroundView.frame.minY, width: width, height: height)
        }
        
        if backgroundView.frame.height < scrollView.frame.height {
            backgroundView.frame = CGRect(x: backgroundView.frame.minX, y: (scrollView.frame.height / 2) - (height / 2), width: width, height: height)
        } else {
            backgroundView.frame = CGRect(x: backgroundView.frame.minX, y: 0, width: width, height: height)
        }
    }
    
    private func updateBackgroundFit() {
        let hPadding = CGFloat(CacheManager.shared.preferredHorizontalPadding * 4)
        let vPadding = CGFloat(CacheManager.shared.preferredVerticalPadding * 4)
        
        // MARK: Handle "Fit" aspect ratio
        if window.frame.width + hPadding < scrollView.frame.width {
            backgroundView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: backgroundView.frame.height)
        } else {
            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.width + hPadding, height: backgroundView.frame.height)
        }
        
        // MARK: Handle scrollView offset
        if window.frame.height + vPadding < scrollView.frame.height {
            backgroundView.frame = CGRect(x: 0, y: 0, width: backgroundView.frame.width, height: scrollView.frame.height)
        } else {
            backgroundView.frame = CGRect(x: 0, y: 0, width: backgroundView.frame.width, height: window.frame.height + vPadding)
        }
    }
    
    private func updateScrollViewContentSize() {
        // MARK: Handle scrollView contentSize
        scrollView.contentSize = CGSize(
            width: backgroundView.frame.width > scrollView.frame.width ? backgroundView.frame.width : scrollView.frame.width,
            height: backgroundView.frame.height > scrollView.frame.height ? backgroundView.frame.height : scrollView.frame.height
        )
    }
    
    private func nudgeSparky() {
        guard let sparky = sparky else {
            return
        }
        
        let intrinsic = sparky.intrinsicContentSize
        let topDistance = windowContainer.frame.minY

        var y: Double {
            if (topDistance - 10) < intrinsic.height {
                return 10
            } else {
                return topDistance - intrinsic.height
            }
        }

        var height: Double {
            if (topDistance - 10) < intrinsic.height {
                return topDistance - 10.0
            } else {
                return intrinsic.height
            }
        }
        
        var width: Double {
            if (topDistance - 10) < intrinsic.height {
                return height * 1.546
            } else {
                return intrinsic.width
            }
        }
        
        var x: Double {
            return (backgroundView.frame.width / 2) + (window.frame.width / 2) - width - 20
        }
        
        sparky.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centreScrollView(animated: false)
        scrollView.flashScrollIndicators()
    }
    
    func centreScrollView(animated: Bool = true) {
        let xPos: CGFloat
        
        if scrollView.contentSize.width > scrollView.frame.width {
            xPos = scrollView.contentSize.width / 2 - scrollView.frame.width / 2
        } else {
            xPos = 0
        }
        
        scrollView.setContentOffset(CGPoint(x: xPos, y: scrollView.contentOffset.y), animated: animated)
    }
    
    // MARK: Light/Dark Mode Support
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            textViewDidChange(textEditor)
            scrollView.layer.borderColor = UIColor(named: "Border")!.cgColor
        }
    }
    
    func addPresetObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(presetChanged), name: Notification.Name("PresetChanged"), object: nil)
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.layer.cornerCurve = .continuous
        scrollView.layer.cornerRadius = 4
        scrollView.layer.borderWidth = 1
        scrollView.layer.borderColor = UIColor(named: "Border")!.cgColor
        scrollView.backgroundColor = UIColor(named: "ScrollViewBackground")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.delegate = self

        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18)
        ])
    }

    func setupBackgroundView() {
        backgroundView = SNImageView(image: nil)
        backgroundView.parent = self
        backgroundView.clipsToBounds = true
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.isUserInteractionEnabled = true
        backgroundView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        scrollView.addSubview(backgroundView)
        
        switch CacheManager.shared.preferredAppearance {
        case 0:
            backgroundView.overrideUserInterfaceStyle = .unspecified
        case 1:
            backgroundView.overrideUserInterfaceStyle = .light
        case 2:
            backgroundView.overrideUserInterfaceStyle = .dark
        default:
            break
        }
    }
    
    func setupTransparentView() {
        transparentView = UIView()
        transparentView.layer.cornerCurve = .continuous
        transparentView.layer.cornerRadius = 4
        transparentView.clipsToBounds = true
        transparentView.isHidden = true
        transparentView.backgroundColor = UIColor(patternImage: UIImage(named: "Checkers")!)
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(transparentView)
        view.sendSubviewToBack(transparentView)
        
        NSLayoutConstraint.activate([
            transparentView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            transparentView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            transparentView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
    }

    func setupWindowContainerView() {
        windowContainer = UIView()
        windowContainer.backgroundColor = .clear
        windowContainer.translatesAutoresizingMaskIntoConstraints = false
        
        windowContainer.layer.shadowColor = UIColor.black.cgColor
        windowContainer.layer.shadowOffset = CGSize(width: 0, height: 12.5)
        windowContainer.layer.shadowRadius = 15
        windowContainer.layer.shadowOpacity = 0.35
        
        backgroundView.addSubview(windowContainer)
        
        NSLayoutConstraint.activate([
            windowContainer.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            windowContainer.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
    }
    
    private var windowConstraints: [NSLayoutConstraint] = []
    
    func updateWindowConstraints() {
        for constraint in windowConstraints {
            backgroundView.removeConstraint(constraint)
        }
        
        if CacheManager.shared.windowContentMode != 0 {
            windowConstraints = [
                windowContainer.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 128),
                windowContainer.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 128),
                windowContainer.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -128),
                windowContainer.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -128)
            ]
            
            NSLayoutConstraint.activate(windowConstraints)
        }
    }
    
    func setupWindowVisualEffectView() {
        let effect = UIBlurEffect(style: .systemThickMaterial)
        window = UIVisualEffectView(effect: effect)
        window.layer.cornerCurve = .continuous
        window.layer.cornerRadius = 11.5
        window.clipsToBounds = true
        window.translatesAutoresizingMaskIntoConstraints = false
        
        windowContainer.addSubview(window)
        
        NSLayoutConstraint.activate([
            window.topAnchor.constraint(equalTo: windowContainer.topAnchor),
            window.leadingAnchor.constraint(equalTo: windowContainer.leadingAnchor),
            window.trailingAnchor.constraint(equalTo: windowContainer.trailingAnchor),
            window.bottomAnchor.constraint(equalTo: windowContainer.bottomAnchor)
        ])
    }
    
    func setupWindowUnderlay() {
        windowUnderlay = UIView()
        windowUnderlay.backgroundColor = .secondarySystemBackground
        windowUnderlay.layer.cornerCurve = .continuous
        windowUnderlay.layer.cornerRadius = 11.5
        windowUnderlay.clipsToBounds = true
        windowUnderlay.alpha = CGFloat(CacheManager.shared.preferredWindowOpacity)
        windowUnderlay.layer.shouldRasterize = true
        windowUnderlay.translatesAutoresizingMaskIntoConstraints = false

        backgroundView.addSubview(windowUnderlay)

        NSLayoutConstraint.activate([
            windowUnderlay.topAnchor.constraint(equalTo: window.topAnchor),
            windowUnderlay.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            windowUnderlay.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            windowUnderlay.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
    }
    
    func setupWindowBorder() {
        let windowBorder = UIImageView(image: UIImage(named: "WindowBorder"))
        windowBorder.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(windowBorder)
        
        NSLayoutConstraint.activate([
            windowBorder.topAnchor.constraint(equalTo: windowContainer.topAnchor),
            windowBorder.leadingAnchor.constraint(equalTo: windowContainer.leadingAnchor),
            windowBorder.trailingAnchor.constraint(equalTo: windowContainer.trailingAnchor),
            windowBorder.bottomAnchor.constraint(equalTo: windowContainer.bottomAnchor)
        ])
    }
    
    func setupWindowControls() {
        let controls = CacheManager.shared.preferredControlsStyle
        
        closeButton = UIImageView()
        closeButton.image = controls == 0 ? UIImage(named: "Close") : controls == 1 ? UIImage(named: "Graphite") : nil
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: window.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        minimiseButton = UIImageView()
        minimiseButton.image = controls == 0 ? UIImage(named: "Minimise") : controls == 1 ? UIImage(named: "Graphite") : nil
        minimiseButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(minimiseButton)
        
        NSLayoutConstraint.activate([
            minimiseButton.topAnchor.constraint(equalTo: window.topAnchor, constant: 20),
            minimiseButton.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 7.5)
        ])
        
        restoreButton = UIImageView()
        restoreButton.image = controls == 0 ? UIImage(named: "Restore") : controls == 1 ? UIImage(named: "Graphite") : nil
        restoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(restoreButton)
        
        NSLayoutConstraint.activate([
            restoreButton.topAnchor.constraint(equalTo: window.topAnchor, constant: 20),
            restoreButton.leadingAnchor.constraint(equalTo: minimiseButton.trailingAnchor, constant: 7.5)
        ])
    }
    
    func setupWindowControlsSymbols() {
        closeSymbol = UIImageView()
        closeSymbol.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(closeSymbol)
        
        NSLayoutConstraint.activate([
            closeSymbol.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            closeSymbol.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor)
        ])
        
        minimiseSymbol = UIImageView()
        minimiseSymbol.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(minimiseSymbol)
        
        NSLayoutConstraint.activate([
            minimiseSymbol.centerYAnchor.constraint(equalTo: minimiseButton.centerYAnchor),
            minimiseSymbol.centerXAnchor.constraint(equalTo: minimiseButton.centerXAnchor)
        ])
        
        restoreSymbol = UIImageView()
        restoreSymbol.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(restoreSymbol)
        
        NSLayoutConstraint.activate([
            restoreSymbol.centerYAnchor.constraint(equalTo: restoreButton.centerYAnchor),
            restoreSymbol.centerXAnchor.constraint(equalTo: restoreButton.centerXAnchor)
        ])
        
        updateWindowControlsSymbols()
    }
    
    func updateWindowControlsSymbols() {
        switch CacheManager.shared.preferredControlsStyle {
        case 1:
            closeSymbol.image = UIImage(named: "CloseIcon-Graphite")
            minimiseSymbol.image = UIImage(named: "MinimiseIcon-Graphite")
            restoreSymbol.image = UIImage(named: "RestoreIcon-Graphite")
        case 2:
            closeSymbol.image = nil
            minimiseSymbol.image = nil
            restoreSymbol.image = nil
        default:
            closeSymbol.image = UIImage(named: "CloseIcon")
            minimiseSymbol.image = UIImage(named: "MinimiseIcon")
            restoreSymbol.image = UIImage(named: "RestoreIcon")
        }
        
        closeSymbol.isHidden = !CacheManager.shared.showControlsSymbols
        minimiseSymbol.isHidden = !CacheManager.shared.showControlsSymbols
        restoreSymbol.isHidden = !CacheManager.shared.showControlsSymbols
    }
    
    func setupWindowTitle() {
        windowTitle = UILabel()
        windowTitle.text = CacheManager.shared.preferredTitle
        windowTitle.textColor = .secondaryLabel
        windowTitle.translatesAutoresizingMaskIntoConstraints = false
        
        windowIcon = UIImageView()
        windowIcon.contentMode = .scaleAspectFit
        windowIcon.image = UIImage(named: "\(CacheManager.shared.preferredLanguageName)Icon")
        
        windowStackView = UIStackView()
        
        if CacheManager.shared.prefersIconVisible {
            windowStackView.addArrangedSubview(windowIcon)
        }
        
        windowStackView.addArrangedSubview(windowTitle)
        windowStackView.axis = .horizontal
        windowStackView.spacing = 8
        windowStackView.alignment = .center
        windowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(windowStackView)
        
        NSLayoutConstraint.activate([
            windowStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            windowStackView.centerYAnchor.constraint(equalTo: window.topAnchor, constant: 26)
        ])
    }
    
    func setupEditorContainer() {
        editorContainer = UIView()
//        editorContainer.backgroundColor = .systemTeal
        editorContainer.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(editorContainer)
        
        NSLayoutConstraint.activate([
            editorContainer.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            editorContainer.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 16),
            editorContainer.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -16),
            editorContainer.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -10)
        ])
    }
    
    func setupLineNumberGutter() {
        lineNumberGutter = UITextView()
        lineNumberGutter.isEditable = false
        lineNumberGutter.textAlignment = .right
        lineNumberGutter.isScrollEnabled = false
        lineNumberGutter.backgroundColor = .clear
        lineNumberGutter.textColor = .secondaryLabel
        lineNumberGutter.isUserInteractionEnabled = false
        lineNumberGutter.isHidden = !CacheManager.shared.showLineNumbers
        lineNumberGutter.font = UIFont(name: "SFMono-Regular", size: 15)
        lineNumberGutter.translatesAutoresizingMaskIntoConstraints = false
        
        lineNumberGutter.font = UIFont(
            name: CacheManager.shared.preferredFontName,
            size: CacheManager.shared.preferredFontSize
        )
        
        editorContainer.addSubview(lineNumberGutter)
        
        NSLayoutConstraint.activate([
            lineNumberGutter.topAnchor.constraint(equalTo: editorContainer.topAnchor),
            lineNumberGutter.leadingAnchor.constraint(equalTo: editorContainer.leadingAnchor)
        ])
    }
    
    func updateLineNumbers() {
        var text = ""
        let lines = textEditor.text.components(separatedBy: "\n")
        let offset = CacheManager.shared.lineNumberStart
        let chars = String(lines.count + offset - 1).count

        for (index, _) in lines.enumerated() {
            var number = "\(index + offset)"
            
            while number.count < chars {
                number = "0" + number
            }
            
            text += "\(number)\n"
        }
        
        lineNumberGutter.text = text
    }
    
    func updateLineNumberVisibility() {
        textEditorLeadingAnchor?.isActive = false
        
        if CacheManager.shared.showLineNumbers {
            lineNumberGutter.isHidden = false
            textEditorLeadingAnchor = textEditor.leadingAnchor.constraint(equalTo: lineNumberGutter.trailingAnchor, constant: 8)
        } else {
            lineNumberGutter.isHidden = true
            textEditorLeadingAnchor = textEditor.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 16)
        }
        
        textEditorLeadingAnchor?.isActive = true
    }
    
    var textEditorLeadingAnchor: NSLayoutConstraint?
    
    func setupTextEditor() {
        let fontSize = CacheManager.shared.preferredFontSize
        
        textEditor = SNTextView()
        textEditor.parent = self
        textEditor.delegate = self
        textEditor.isScrollEnabled = false
        textEditor.backgroundColor = .clear
        textEditor.smartQuotesType = .no
        textEditor.smartDashesType = .no
        textEditor.smartInsertDeleteType = .no
        textEditor.autocorrectionType = .no
        textEditor.autocapitalizationType = .none
        textEditor.spellCheckingType = .no
        textEditor.isUserInteractionEnabled = true
        textEditor.font = UIFont(name: "SFMono-Regular", size: fontSize)
        textEditor.translatesAutoresizingMaskIntoConstraints = false
        textEditor.text = CacheManager.shared.editorText
        
        editorContainer.addSubview(textEditor)
        
        if CacheManager.shared.showLineNumbers {
            textEditorLeadingAnchor = textEditor.leadingAnchor.constraint(equalTo: lineNumberGutter.trailingAnchor, constant: 8)
        } else {
            textEditorLeadingAnchor = textEditor.leadingAnchor.constraint(equalTo: editorContainer.leadingAnchor)
        }
        
        NSLayoutConstraint.activate([
            textEditor.topAnchor.constraint(equalTo: editorContainer.topAnchor),
            textEditor.trailingAnchor.constraint(equalTo: editorContainer.trailingAnchor),
            textEditor.bottomAnchor.constraint(equalTo: editorContainer.bottomAnchor),
            textEditor.widthAnchor.constraint(greaterThanOrEqualToConstant: 250),
            textEditorLeadingAnchor!
        ])
        
        textViewDidChange(textEditor)
        
        #warning("Experimental highlighting code")
//        let rect = UIView()
//        rect.backgroundColor = UIColor(displayP3Red: 252/255, green: 235/255, blue: 180/255, alpha: 0.5)
//        rect.translatesAutoresizingMaskIntoConstraints = false
//
//        backgroundView.addSubview(rect)
//
//        NSLayoutConstraint.activate([
//            rect.widthAnchor.constraint(equalTo: window.widthAnchor, constant: -2),
//            rect.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 1),
//            rect.heightAnchor.constraint(equalToConstant: 18),
//            rect.topAnchor.constraint(equalTo: textEditor.topAnchor, constant: 7 + (18 * 15))
//        ])
//
//        backgroundView.bringSubviewToFront(textEditor)
//        backgroundView.bringSubviewToFront(lineNumberGutter)
    }
    
    private var shouldMove = false
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let code = textView.text else {
            return true
        }
        
        let datum = textView.beginningOfDocument
        if let range = textView.selectedTextRange {
            let start = textView.offset(from: datum, to: range.start)
            let end = textView.offset(from: datum, to: range.end)
            
            if start != end && text == "\t" {
                let startIndex = code.index(code.startIndex, offsetBy: start)
                let endIndex = code.index(code.startIndex, offsetBy: end - 1)
                let closedRange = startIndex...endIndex
                let selection = String(code[closedRange]).replacingOccurrences(of: "\n", with: "\n    ")
                
                undoTextFieldEdit(textEditor.text.replacingCharacters(in: closedRange, with: "    " + selection))
                updateTextView()
                textEditor.selectedTextRange = textEditor.textRange(
                    from: textEditor.position(from: range.start, offset: 0)!,
                    to: textEditor.position(from: range.end, offset: selection.components(separatedBy: "\n").count * 4)!
                )
                
                return false
            }
        }
        
        if text == "\t" {
            shouldMove = true
        }
        
        return true
    }
    
    @objc func undoTextFieldEdit(_ string: String?) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(undoTextFieldEdit(_:)), object: textEditor.text)
        textEditor.text = string
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let startPosition = textView.beginningOfDocument
        if let selectedRange = textView.selectedTextRange {
            var cursorPosition = textView.offset(from: startPosition, to: selectedRange.start)
            
            if shouldMove {
                cursorPosition += 3
                shouldMove = false
            }
            
            guard let code = textView.text?.replacingOccurrences(of: "\t", with: "    ") else {
                return
            }
            
            CacheManager.shared.setEditorText(to: code)
            
            let format = AttributedStringOutputFormat(theme: theme, appearance: backgroundView.traitCollection.userInterfaceStyle)
            let highlighter = SyntaxHighlighter(format: format, grammar: language)
            let attributedString = highlighter.highlight(code)
            textView.attributedText = attributedString
            
            if let newPosition = textView.position(from: startPosition, offset: cursorPosition) {
                textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    func resignTextViewFirstResponder() {
        textEditor.resignFirstResponder()
    }
    
    func setupSparky() {
        sparky = UIImageView(image: UIImage(named: "Sparky"))
        sparky!.contentMode = .scaleAspectFit
        sparky!.alpha = PresetManager.shared.selectedPresetName == "Firebase" ? 1 : 0
        
        backgroundView.addSubview(sparky!)
        backgroundView.sendSubviewToBack(sparky!)

    }
    
    func updateWindowPadding(withPadding padding: CGFloat, onEdges edges: [PaddingSides]) {
        viewDidLayoutSubviews()
        centreScrollView(animated: false)
    }
    
    func updateWindowControls(with colourScheme: ControlColourScheme) {
        switch colourScheme {
        case .colourful:
            closeButton.image = UIImage(named: "Close")
            minimiseButton.image = UIImage(named: "Minimise")
            restoreButton.image = UIImage(named: "Restore")
        case .graphite:
            closeButton.image = UIImage(named: "Graphite")
            minimiseButton.image = UIImage(named: "Graphite")
            restoreButton.image = UIImage(named: "Graphite")
        case .none:
            closeButton.image = nil
            minimiseButton.image = nil
            restoreButton.image = nil
        }
    }
    
    func windowTitleText() -> String {
        return windowTitle.text ?? "Untitled"
    }
    
    func toggleIcon(on isOn: Bool) {
        if isOn {
            windowStackView.insertArrangedSubview(windowIcon, at: 0)
        } else {
            windowIcon.removeFromSuperview()
        }
    }
    
    func updateAppearance(to appearance: UIUserInterfaceStyle) {
        backgroundView.overrideUserInterfaceStyle = appearance
        updateTextView()
    }
    
    func updateTextView() {
        textViewDidChange(textEditor)
    }
    
    func updateFont(to font: UIFont, adjustingScrollViewPosition adjustScrollViewPosition: Bool = true) {
        textEditor.font = font
        lineNumberGutter.font = font
        updateTheme()
        
        textEditor.previousText = ""
        textEditor.setFont(to: font)
    }
    
    func updateTheme(adjustingScrollViewPosition adjustScrollViewPosition: Bool = true) {
        theme = CacheManager.shared.preferredTheme
    }
    
    func updateLanguage() {
        language = CacheManager.shared.preferredLanguage
        updateTextView()
    }
    
    func updateWindowUnderlay(opacity: Float) {
        windowUnderlay.alpha = CGFloat(opacity)
    }
    
    func updateWindowTitleIcon() {
        windowIcon.image = UIImage(named: "\(CacheManager.shared.preferredLanguageName)Icon")
    }
    
    func setNoneBackground() {
        transparentView.isHidden = false
        backgroundView.image = nil
        backgroundView.backgroundColor = UIColor.clear
        
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    func setSolidColour(colour: CGColor) {
        transparentView.isHidden = true
        backgroundView.image = nil
        backgroundView.backgroundColor = UIColor(cgColor: colour)
        
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    func setGradient(colours: [CGColor]) {
        transparentView.isHidden = true
        backgroundView.image = nil
        backgroundView.backgroundColor = .clear
        
        setupGradient(withColours: colours)
    }
    
    func setImage(image: UIImage?) {
        transparentView.isHidden = true
        backgroundView.image = image
        backgroundView.backgroundColor = .clear
        
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    func setupGradient(withColours colours: [CGColor] = []) {
        var gradientColours = colours
        if colours.isEmpty {
            for colour in CacheManager.shared.gradientHSVs {
                gradientColours.append(colour.cgColor)
            }
        }
        
        if let layer = gradientLayer {
            layer.removeFromSuperlayer()
        }

        gradientLayer = CAGradientLayer()
        gradientLayer!.colors = gradientColours
        gradientLayer!.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer!.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer!.locations = CacheManager.shared.gradientLocations
        gradientLayer!.frame = backgroundView.bounds
        gradientLayer!.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        
        backgroundView.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    func setWindowTitleText(to string: String?) {
        windowTitle.text = string ?? "Untitled"
    }
    
    func updateBackgroundSize() {
        CATransaction.setDisableActions(true)
        backgroundView.frame = CGRect()
        viewDidLayoutSubviews()
        
        if backgroundView.frame.width > scrollView.frame.width {
            scrollView.flashScrollIndicators()
            scrollView.contentOffset = CGPoint(
                x: (scrollView.contentSize.width - scrollView.frame.width) / 2,
                y: scrollView.contentOffset.y
            )
        }
    }
    
    func canvasImage() -> UIImage {
        textEditor.resignFirstResponder()
        
        let scale = UserDefaults.standard.float(forKey: "imageOutputScale")

        UIGraphicsBeginImageContextWithOptions(backgroundView.bounds.size, false, CGFloat(scale))
        backgroundView.drawHierarchy(in: backgroundView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? UIImage()
    }
    
    func textImage() -> UIImage {
        textEditor.resignFirstResponder()
        
        let scale = UserDefaults.standard.float(forKey: "imageOutputScale")
        
        UIGraphicsBeginImageContextWithOptions(editorContainer.bounds.size, false, CGFloat(scale))
        editorContainer.drawHierarchy(in: editorContainer.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    func showCopiedAlert(withMessage message: String = "Copied to Clipboard") {
        let copiedContainer = UIView()
        copiedContainer.alpha = 1
        copiedContainer.layer.cornerCurve = .continuous
        copiedContainer.layer.cornerRadius = 10
        copiedContainer.layer.shadowRadius = 7.5
        copiedContainer.layer.shadowOpacity = 0.5
        copiedContainer.layer.shadowOffset = CGSize(width: 0, height: 5)
        copiedContainer.layer.shadowColor = UIColor.black.cgColor
        copiedContainer.layer.borderWidth = 1
        copiedContainer.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
        copiedContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(copiedContainer)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        visualEffectView.layer.masksToBounds = true
        visualEffectView.layer.cornerCurve = .continuous
        visualEffectView.layer.cornerRadius = 10
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        copiedContainer.addSubview(visualEffectView)
        
        let label = UILabel()
        label.text = message
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        copiedContainer.addSubview(label)
        
        NSLayoutConstraint.activate([
            copiedContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            copiedContainer.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            copiedContainer.widthAnchor.constraint(equalTo: label.widthAnchor, constant: 30),
            copiedContainer.heightAnchor.constraint(equalTo: label.heightAnchor, constant: 20),
            
            visualEffectView.topAnchor.constraint(equalTo: copiedContainer.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: copiedContainer.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: copiedContainer.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: copiedContainer.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: visualEffectView.centerYAnchor)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.5) {
                copiedContainer.alpha = 0
            } completion: { _ in
                copiedContainer.removeFromSuperview()
            }
        }
    }
    
    func previewImage() -> UIImage {
        textEditor.resignFirstResponder()
        
        UIGraphicsBeginImageContextWithOptions(backgroundView.bounds.size, true, 0.5)
        backgroundView.drawHierarchy(in: backgroundView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    @objc private func presetChanged() {
        let name = PresetManager.shared.selectedPresetName
        let data: [String: Any] = {
            if let json = PresetManager.shared.presets[name] as? [String: Any] {
                return json
            }
            
            return PresetManager.shared.defaultPreset
        }()
        
        handleSizeSettings(data: data)
        handleWindowSettings(data: data)
        handleEditorSettings(data: data)
        handleBackgroundSettings(data: data)
    
        updateSettingsUI()
        
        DispatchQueue.main.async { [weak self] in
            self?.centreScrollView(animated: false)
        }
        
        sparky?.alpha = name == "Firebase" ? 1 : 0
    }
    
    private func handleWindowSettings(data: [String: Any]) {
        if let title = data["title"] as? String {
            CacheManager.shared.setPreferredTitle(to: title)
            setWindowTitleText(to: title)
        }
        
        if let showIcon = data["showIcon"] as? Bool {
            CacheManager.shared.setPreferredIconVisibility(to: showIcon)
            toggleIcon(on: showIcon)
        }
        
        if let appearance = data["appearance"] as? Int {
            CacheManager.shared.setPreferredAppearance(to: appearance)
            updateAppearance(to: appearance.toUIUserInterfaceStyle())
        }
        
        if let controls = data["controls"] as? Int {
            CacheManager.shared.setPreferredControlStyle(to: controls)
            updateWindowControls(with: controls.toControlColourScheme())
        }
        
        if let symbols = data["symbols"] as? Bool {
            CacheManager.shared.setShowControlsSymbols(to: symbols)
            updateWindowControlsSymbols()
        }
        
        if let opacity = data["opacity"] as? Double {
            CacheManager.shared.setPreferredWindowOpacity(to: Float(opacity))
            updateWindowUnderlay(opacity: Float(opacity))
        }
        
        if let hPadding = data["hPadding"] as? Int {
            CacheManager.shared.setPreferredHorizontalPadding(to: hPadding)
            updateWindowPadding(withPadding: CGFloat(hPadding), onEdges: [.horizontal])
        }
        
        if let vPadding = data["vPadding"] as? Int {
            CacheManager.shared.setPreferredVerticalPadding(to: vPadding)
            updateWindowPadding(withPadding: CGFloat(vPadding), onEdges: [.vertical])
        }
        
        if let matchedPadding = data["matchedPadding"] as? Bool {
            CacheManager.shared.setPreferredMatchedPadding(to: matchedPadding)
        }
    }
    
    private func handleEditorSettings(data: [String: Any]) {
        if let language = data["language"] as? String {
            CacheManager.shared.setPreferredLanguageName(to: language)
            self.language = CacheManager.shared.preferredLanguage
        }
        
        if let theme = data["theme"] as? String {
            CacheManager.shared.setPreferredThemeName(to: theme)
            updateTheme(adjustingScrollViewPosition: false)
            updateTextView()
        }
        
        if let font = data["font"] as? String {
            if let size = data["fontSize"] as? Double {
                CacheManager.shared.setPreferredFontName(to: font)
                CacheManager.shared.setPreferredFontSize(to: CGFloat(size))
                
                let font = UIFont(name: font, size: CGFloat(size))
                updateFont(to: font ?? .systemFont(ofSize: 15), adjustingScrollViewPosition: false)
            }
        }
        
        if let showLineNumbers = data["showLineNumbers"] as? Bool {
            CacheManager.shared.setShowLineNumbers(to: showLineNumbers)
        } else {
            CacheManager.shared.setShowLineNumbers(to: false)
        }
        
        if let lineNumberStart = data["lineNumberStart"] as? Int {
            CacheManager.shared.setLineNumberStart(to: lineNumberStart)
        } else {
            CacheManager.shared.setLineNumberStart(to: 1)
        }
        
        updateLineNumbers()
        updateLineNumberVisibility()
    }
    
    private func handleBackgroundSettings(data: [String: Any]) {
        if let type = data["backgroundType"] as? Int {
            switch type {
            case 1:
                handleSolidColourBackground(type: type, data: data)
            case 2:
                handleGradientBackground(data: data)
            case 3:
                handleImageBackground(data: data)
            default:
                handleNoneBackground()
            }
        }
    }
    
    private func handleNoneBackground() {
        CacheManager.shared.setPreferredBackgroundType(to: "None")
        setNoneBackground()
    }
    
    private func handleSolidColourBackground(type: Int, data: [String: Any]) {
        CacheManager.shared.setPreferredBackgroundType(to: "Solid Colour")
        
        if let value = data["backgroundValue"] as? Int {
            CacheManager.shared.setPreferredPresetSolidColour(to: value)
            CacheManager.shared.setRecentSolidColourPreset(to: value)
            setSolidColour(colour: value.toPresetSolidColour())
        } else if let value = data["backgroundValue"] as? [CGFloat] {
            let hsv = type.toCustomSolidColour(withComponents: value)
            CacheManager.shared.setPreferredCustomSolidHSV(to: hsv)
            CacheManager.shared.setPreferredPresetSolidColour(to: 6)
            setSolidColour(colour: hsv.cgColor)
        }
    }
    
    private func handleGradientBackground(data: [String: Any]) {
        CacheManager.shared.setPreferredBackgroundType(to: "Gradient")
        
        if let value = data["backgroundValue"] as? Int {
            CacheManager.shared.setRecentGradientPreset(to: value)
            CacheManager.shared.setGradientHSVs(to: value.toPresetGradientHSV())
            CacheManager.shared.setGradientLocations(to: [0, 1])
            setGradient(colours: value.toPresetGradient())
        } else if let gradient = data["backgroundValue"] as? [Any] {
            if gradient.indices.contains(1) {
                if let locations = gradient[0] as? [CGFloat] {
                    if locations.count >= 2 {
                        CacheManager.shared.setGradientLocations(to: locations)
                    }
                }
                
                if let colours = gradient[1] as? [[NSNumber]] {
                    var HSVs: [HSV] = []
                    for colour in colours {
                        if colour.indices.contains(2) {
                            let hue = Float(truncating: colour[0])
                            let saturation = Float(truncating: colour[1])
                            let brightness = Float(truncating: colour[2])
                            let hsv = HSV(h: hue, s: saturation, v: brightness)
                            HSVs.append(hsv)
                        }
                    }
                    
                    CacheManager.shared.setGradientHSVs(to: HSVs)
                    CacheManager.shared.setRecentGradientPreset(to: 6)
                }
                
                setGradient(colours: CacheManager.shared.gradientColours)
            }
        }
    }
    
    private func handleImageBackground(data: [String: Any]) {
        CacheManager.shared.setPreferredBackgroundType(to: "Image")
        
        if let value = data["backgroundValue"] as? Int {
            if UIImage.presetNames.indices.contains(value) {
                CacheManager.shared.setPresetBackgroundImage(to: UIImage.presetNames[value])
                CacheManager.shared.setPrefersCustomImage(to: false)
                
                Task {
                    let image = await CacheManager.shared.recentPresetBackgroundImage()
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.setImage(image: image)
                    }
                }
            }
        } else if let value = data["backgroundValue"] as? String {
            CacheManager.shared.setPrefersCustomImage(to: true)
            CacheManager.shared.setCustomImagePath(to: value)
            setImage(image: UIImage(contentsOfFile: value))
        }
    }
    
    private func loadCachedImageWith(name: String) -> UIImage? {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = path.appendingPathComponent("/Wallpapers/\(name).jpg")
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                
                return image
            }
        }
        
        return nil
    }
    
    private func handleSizeSettings(data: [String: Any]) {
        if let value = data["aspectRatio"] as? Int {
            CacheManager.shared.setupPreferredSize(to: value)
        } else {
            CacheManager.shared.setupPreferredSize(to: 0)
        }
        
        updateBackgroundSize()
    }
    
    private func updateSettingsUI() {
        NotificationCenter.default.post(name: NSNotification.Name("UpdateUI"), object: nil)
    }
    
//    private func setupZoomView() {
//        zoomContainerView = UIView()
//        zoomContainerView.backgroundColor = .black
//        zoomContainerView.layer.cornerCurve = .continuous
//        zoomContainerView.layer.cornerRadius = 2.5
//        zoomContainerView.layer.shadowOpacity = 0.5
//        zoomContainerView.layer.shadowRadius = 10
//        zoomContainerView.layer.shadowOffset = CGSize(width: 0, height: 5)
//        zoomContainerView.clipsToBounds = true
//        zoomContainerView.layer.masksToBounds = false
//
//        view.addSubview(zoomContainerView)
//
//        zoomDarkImageView = UIImageView()
//        zoomDarkImageView.alpha = 0.5
//        zoomDarkImageView.clipsToBounds = true
//        zoomDarkImageView.layer.cornerCurve = .continuous
//        zoomDarkImageView.layer.cornerRadius = 2.5
//        zoomDarkImageView.contentMode = .scaleAspectFill
//        zoomDarkImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        zoomContainerView.addSubview(zoomDarkImageView)
//
//        NSLayoutConstraint.activate([
//            zoomDarkImageView.topAnchor.constraint(equalTo: zoomContainerView.topAnchor),
//            zoomDarkImageView.leadingAnchor.constraint(equalTo: zoomContainerView.leadingAnchor),
//            zoomDarkImageView.trailingAnchor.constraint(equalTo: zoomContainerView.trailingAnchor),
//            zoomDarkImageView.bottomAnchor.constraint(equalTo: zoomContainerView.bottomAnchor)
//        ])
//
//        zoomImageView = UIImageView()
//        zoomImageView.clipsToBounds = true
//        zoomImageView.layer.cornerCurve = .continuous
//        zoomImageView.layer.cornerRadius = 2.5
//        zoomImageView.contentMode = .scaleAspectFill
//        zoomImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        zoomContainerView.addSubview(zoomImageView)
//
//        NSLayoutConstraint.activate([
//            zoomImageView.topAnchor.constraint(equalTo: zoomContainerView.topAnchor),
//            zoomImageView.leadingAnchor.constraint(equalTo: zoomContainerView.leadingAnchor),
//            zoomImageView.trailingAnchor.constraint(equalTo: zoomContainerView.trailingAnchor),
//            zoomImageView.bottomAnchor.constraint(equalTo: zoomContainerView.bottomAnchor)
//        ])
//
//        setupZoomOverlay()
//    }
//
//    private func setupZoomOverlay() {
//        zoomOverlay = UIView()
//        zoomOverlay.backgroundColor = .systemCyan
//
//        zoomImageView.addSubview(zoomOverlay)
//        zoomImageView.mask = zoomOverlay
//    }
//
//    func updateZoomOverview() {
//        updateZoomOverlay()
//
//        let size = Size.defaults[CacheManager.shared.preferredSize]
//        let aspectRatio = size.width / size.height
//
//        let width = scrollView.contentSize.width < scrollView.contentSize.height ? 150.0 : 150.0 * Double(aspectRatio)
//        let height = scrollView.contentSize.height < scrollView.contentSize.width ? 150.0 : 150.0 / Double(aspectRatio)
//        let x = scrollView.frame.minX + 10
//        let y = scrollView.frame.maxY - height - 10
//
//        zoomContainerView.frame = CGRect(x: x, y: y, width: width.isNaN ? 0 : width, height: height.isNaN ? 0 : height)
//    }
//
//    private func updateZoomOverlay() {
//        let x = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.width)
//        let y = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.height)
//        let width = zoomImageView.frame.width * (scrollView.frame.width / scrollView.contentSize.width)
//        let height = zoomImageView.frame.height * (scrollView.frame.height / scrollView.contentSize.height)
//
//        zoomOverlay.frame = CGRect(
//            x: x.isNaN ? 0 : (zoomImageView.frame.width - width) * x,
//            y: y.isNaN ? 0 : (zoomImageView.frame.height - height) * y,
//            width: width, height: height
//        )
//    }
//
//    private func updateZoomImageWith(image: UIImage) {
//        zoomImageView.image = image
//        zoomDarkImageView.image = image
//    }
}
