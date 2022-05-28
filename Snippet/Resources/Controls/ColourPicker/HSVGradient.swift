//
//  HSVGradient.swift
//  Snippet
//
//  Created by Seb Vidal on 06/02/2022.
//

import UIKit
import SwiftUI

class HsvViewModel: ObservableObject {
    @Published var hue: CGFloat = 0
}

class HSVGradient: UIView {
    weak var parent: ColourPickerViewController?
    private var viewModel: HsvViewModel!
    
    private var gradientView: _HSVGradient!
    private var gradientUIView: UIView!
    private var pickerView: UIView!
    private var pickerPreviewView: UIView!
    
    private var hue: CGFloat = 0
    private var saturation: CGFloat = 1
    private var brightness: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let parent = parent {
            hue = parent.hue
            saturation = parent.saturation
            brightness = parent.brightness
        }
        
        initViewModel()
        setupGradientView()
        setupPickerView()
    }
    
    private func initViewModel() {
        viewModel = HsvViewModel()
        
        guard let parent = parent else {
            return
        }

        viewModel.hue = parent.hue
    }
    
    private func setupGradientView() {
        gradientView = _HSVGradient(hsv: self.viewModel)
        
        let gradientViewHost = UIHostingController(rootView: gradientView)
        gradientUIView = gradientViewHost.view
        gradientUIView.clipsToBounds = true
        gradientUIView.layer.cornerCurve = .continuous
        gradientUIView.layer.cornerRadius = 5
        gradientUIView.layer.borderWidth = 1
        gradientUIView.layer.borderColor = UIColor(named: "Border")?.cgColor
        gradientUIView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(gradientUIView)
        
        NSLayoutConstraint.activate([
            gradientUIView.topAnchor.constraint(equalTo: topAnchor),
            gradientUIView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientUIView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientUIView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let dragGesture = UILongPressGestureRecognizer(target: self, action: #selector(gradientDragged(_:)))
        dragGesture.minimumPressDuration = 0
        gradientUIView.addGestureRecognizer(dragGesture)
    }
    
    @objc private func gradientDragged(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: gradientUIView)
        var x: CGFloat {
            let rawX = location.x - 7.5
            
            if rawX < -7.5 {
                return -7.5
            } else if rawX > 242.5 {
                return 242.5
            } else {
                return rawX
            }
        }
        
        var y: CGFloat {
            let rawY = location.y - 7.5
            
            if rawY < -7.5 {
                return -7.5
            } else if rawY > 242.5 {
                return 242.5
            } else {
                return rawY
            }
        }
        
        pickerView.frame = CGRect(x: x, y: y, width: 15, height: 15)
        
        saturation = 1 / 250 * (x + 7.5)
        brightness = 1 - (1 / 250 * (y + 7.5))
        
        let hsv = HSV(h: Float(viewModel.hue), s: Float(saturation), v: Float(brightness))
        let colour = UIColor(displayP3Red: CGFloat(hsv.rgb.r), green: CGFloat(hsv.rgb.g), blue: CGFloat(hsv.rgb.b), alpha: 1)
        pickerPreviewView.backgroundColor = colour
        
        if let parent = parent {
            parent.updateGradientSliderColours(saturation: saturation, brightness: brightness)
        }
    }
    
    private func setupPickerView() {
        guard let parent = parent else {
            return
        }

        let posX = ((parent.saturation / 1) * 250) - 7.5
        let posY = (250 - (parent.brightness / 1) * 250) - 7.5
        
        pickerView = UIView()
        pickerView.backgroundColor = .white
        pickerView.frame = CGRect(x: posX, y: posY, width: 15, height: 15)
        
        let innerBorder = UIView()
        innerBorder.backgroundColor = .black
        innerBorder.frame = CGRect(x: 1, y: 1, width: 13, height: 13)
        
        pickerView.addSubview(innerBorder)
        
        pickerPreviewView = UIView()
        pickerPreviewView.backgroundColor = UIColor(cgColor: HSV(h: Float(parent.hue), s: Float(parent.saturation), v: Float(parent.brightness)).cgColor)
        pickerPreviewView.frame = CGRect(x: 0.5, y: 0.5, width: 12, height: 12)
        
        innerBorder.addSubview(pickerPreviewView)
        gradientUIView.addSubview(pickerView)
    }
    
    func updateHue(to hue: CGFloat) {
        let hsv = HSV(h: Float(hue), s: Float(saturation), v: Float(brightness))
        let rgb = hsv.rgb
        
        self.hue = CGFloat(hsv.h)
        viewModel.hue = hue
        pickerPreviewView.backgroundColor = UIColor(displayP3Red: CGFloat(rgb.r), green: CGFloat(rgb.g), blue: CGFloat(rgb.b), alpha: 1)
    }
    
    func updateSaturation(to saturation: CGFloat, brightnessTo brightness: CGFloat) {
        self.saturation = saturation
        self.brightness = brightness
        
        let posX = ((saturation / 1) * 250) - 7.5
        let posY = (250 - (brightness / 1) * 250) - 7.5
        pickerView.frame = CGRect(x: posX, y: posY, width: 15, height: 15)
        
        pickerPreviewView.backgroundColor = UIColor(cgColor: HSV(h: Float(hue), s: Float(saturation), v: Float(brightness)).cgColor)
    }
}

struct _HSVGradient: View {
    @StateObject var hsv: HsvViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: hueSaturationGradient, startPoint: .leading, endPoint: .trailing)
            LinearGradient(gradient: brightnessGradient, startPoint: .top, endPoint: .bottom)
        }
        .frame(width: 250, height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
    }
    
    var hueSaturationGradient: Gradient {
        Gradient(colors: [
            Color(uiColor: UIColor.white),
            Color(UIColor(displayP3Red: CGFloat(HSV(h: Float(hsv.hue), s: 1, v: 1).rgb.r),
                          green: CGFloat(HSV(h: Float(hsv.hue), s: 1, v: 1).rgb.g),
                          blue: CGFloat(HSV(h: Float(hsv.hue), s: 1, v: 1).rgb.b),
                          alpha: 1))
        ])
    }
    
    var brightnessGradient: Gradient {
        Gradient(colors: [
            Color(uiColor: UIColor.clear),
            Color(uiColor: UIColor.black)
        ])
    }
}
