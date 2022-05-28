//
//  HSVSliderView.swift
//  Snippet
//
//  Created by Seb Vidal on 05/02/2022.
//

import UIKit

class HSVSliderView: UIView {
    weak var parent: ColourPickerViewController?
    
    private var hueGradient: CAGradientLayer!
    private var hsvSliderView: UIView!
    private var gripView: UIView!
    private var gripViewColour: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        setupView()
        setupGradient()
        setupGripView()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        guard let parent = parent else {
            return
        }
        
        let posX = (parent.hue / 360) * 248
        gripView.frame =  CGRect(x: posX - 6.5, y: -2.5, width: 13, height: 30)
        gripViewColour.backgroundColor = UIColor(cgColor: HSV(h: Float(parent.hue), s: 1, v: 1).cgColor)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            hsvSliderView.layer.borderColor = UIColor(named: "Border")?.cgColor
            gripView.layer.borderColor = UIColor.systemFill.cgColor
        }
    }
    
    private func setupView() {
        hsvSliderView = UIView()
        hsvSliderView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hsvSliderView)
        
        NSLayoutConstraint.activate([
            hsvSliderView.topAnchor.constraint(equalTo: topAnchor),
            hsvSliderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hsvSliderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hsvSliderView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        hsvSliderView.layer.cornerCurve = .continuous
        hsvSliderView.layer.cornerRadius = 5
        hsvSliderView.layer.borderWidth = 1
        hsvSliderView.layer.borderColor = UIColor(named: "Border")?.cgColor
        hsvSliderView.clipsToBounds = true
    }
    
    private func setupGradient() {
        hueGradient = CAGradientLayer()
        hueGradient.colors = [
            UIColor(hue: 0 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 30 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 60 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 90 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 120 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 150 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 180 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 210 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 240 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 270 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 300 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 330 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor,
            UIColor(hue: 360 / 360, saturation: 1, brightness: 1, alpha: 1).cgColor
        ]
        hueGradient.startPoint = CGPoint(x: 0, y: 0.5)
        hueGradient.endPoint = CGPoint(x: 1, y: 0.5)
        hueGradient.frame = CGRect(x: 0, y: 0, width: 248, height: 25)
        
        hsvSliderView.layer.insertSublayer(hueGradient, at: 0)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tapGesture)
        
        let dragGesture = UILongPressGestureRecognizer(target: self, action: #selector(panAction(_:)))
        dragGesture.minimumPressDuration = 0.0
        gripView.addGestureRecognizer(dragGesture)
    }
    
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        gripView.frame = CGRect(x: sender.location(in: self).x - 6.5, y: -2.5, width: 13, height: 30)
        gripViewColour.backgroundColor = UIColor(hue: (1 / 248) * sender.location(in: self).x , saturation: 1, brightness: 1, alpha: 1)

        if let parent = parent {
            parent.updateGradientSliderColours(hue: (360 / 248) * sender.location(in: self).x)
        }
    }
    
    @objc private func panAction(_ sender: UILongPressGestureRecognizer) {
        var x: CGFloat {
            let offset = sender.location(in: hsvSliderView).x

            if offset <= 0 {
                return 0
            } else if offset > 248 {
                return 248
            } else {
                return offset
            }
        }

        gripView.frame = CGRect(x: x - 6.5, y: -2.5, width: 13, height: 30)
        gripViewColour.backgroundColor = UIColor(hue: (1 / 248) * x, saturation: 1, brightness: 1, alpha: 1)
    
        if let parent = parent {
            parent.updateGradientSliderColours(hue: (360 / 248) * x)
        }
    }
    
    private func setupGripView() {
        gripView = UIView()
        gripView.backgroundColor = .white
        gripView.frame = CGRect(x: -6.5, y: -2.5, width: 13, height: 30)
        gripView.layer.cornerCurve = .continuous
        gripView.layer.cornerRadius = 6.5
        gripView.layer.borderWidth = 1
        gripView.layer.borderColor = UIColor.red.cgColor
        gripView.clipsToBounds = true
        
        addSubview(gripView)
        
        gripViewColour = UIView()
        gripViewColour.frame = CGRect(x: 3, y: 3, width: 7, height: 24)
        gripViewColour.backgroundColor = .red
        gripViewColour.clipsToBounds = true
        gripViewColour.layer.cornerCurve = .continuous
        gripViewColour.layer.cornerRadius = 3.5
        
        gripView.addSubview(gripViewColour)
    }
    
    func updateHue(to hue: CGFloat) {
        let x = Double((hue / 360) * 248)
        gripView.frame = CGRect(x: x - 6.5, y: -2.5, width: 13, height: 30)
        gripViewColour.backgroundColor = UIColor(hue: (1 / 248) * x, saturation: 1, brightness: 1, alpha: 1)
    }
}
