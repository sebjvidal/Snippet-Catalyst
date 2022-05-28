//
//  SNImageView.swift
//  Snippet
//
//  Created by Seb Vidal on 18/03/2022.
//

import UIKit

class SNImageView: UIImageView {
    weak var parent: CanvasViewController!
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
