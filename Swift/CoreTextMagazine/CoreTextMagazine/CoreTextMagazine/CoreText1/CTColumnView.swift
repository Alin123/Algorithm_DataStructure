//
//  CTColumnView.swift
//  CoreTextMagazine
//
//  Created by lianzhandong on 2018/4/25.
//  Copyright © 2018年 lianzhandong. All rights reserved.
//

import UIKit
import CoreText

class CTColumnView: UIView {
    var ctFrame: CTFrame!
    var images: [(image: UIImage, frame: CGRect)] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(frame: CGRect, ctframe: CTFrame) {
        super.init(frame: frame)
        self.ctFrame = ctframe
        backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        CTFrameDraw(ctFrame, context)
        for imageData in images {
            if let image = imageData.image.cgImage {
                let imgBounds = imageData.frame
                context.draw(image, in: imgBounds)
            }
        }
    }

}
