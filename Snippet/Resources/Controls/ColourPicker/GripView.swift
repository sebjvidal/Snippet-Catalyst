//
//  GripView.swift
//  Snippet
//
//  Created by Seb Vidal on 13/02/2022.
//

import UIKit

class GripView: UIView, ColourPickerDelegate {
    weak var parent: GradientTableViewCell!
    private var imageView: UIImageView!
    private var previewView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupImageView()
        _setupGripPreview()
        _setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setupImageView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Grip")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func _setupGripPreview() {
        previewView = UIView()
        previewView.layer.masksToBounds = true
        previewView.layer.cornerCurve = .continuous
        previewView.layer.cornerRadius = 1.5
        previewView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(previewView)
        
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            previewView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            previewView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            previewView.heightAnchor.constraint(equalTo: previewView.widthAnchor)
        ])
    }
    
    private func _setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(_tapped(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func _tapped(_ sender: UITapGestureRecognizer) {
        guard
            let parent = parent.parent,
            let index = self.parent.gripIndex(of: self)
        else {
            return
        }
        
        let colourPicker = ColourPickerViewController()
        colourPicker.delegate = self
        colourPicker.modalPresentationStyle = .popover
        colourPicker.popoverPresentationController?.permittedArrowDirections = .up
        colourPicker.preferredContentSize = CGSize(width: 282, height: 448)
        colourPicker.popoverPresentationController?.sourceView = self
        
        let hsv = CacheManager.shared.gradientHSVs[index]
        colourPicker.hue = CGFloat(hsv.h)
        colourPicker.saturation = CGFloat(hsv.s)
        colourPicker.brightness = CGFloat(hsv.v)
        
        parent.present(colourPicker, animated: true)
    }
    
    func setPreviewColour(to colour: UIColor) {
        previewView.backgroundColor = colour
    }
    
    func colourDidChange(withHue hue: Float, saturation: Float, brightness: Float, source: UIView?) {
        let hsv = HSV(h: hue, s: saturation, v: brightness)
        setPreviewColour(to: UIColor(cgColor: hsv.cgColor))
        
        guard
            let parent = parent,
            let index = parent.gripIndex(of: self)
        else {
            return
        }
        
        parent.updateGradientColour(at: index, to: hsv)
    }
}
