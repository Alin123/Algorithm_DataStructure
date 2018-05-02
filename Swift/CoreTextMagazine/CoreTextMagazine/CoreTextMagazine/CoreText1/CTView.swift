//
//  CTView.swift
//  CoreTextMagazine
//
//  Created by lianzhandong on 2018/4/23.
//  Copyright © 2018年 lianzhandong. All rights reserved.
//

import UIKit
import CoreText

class CTView: UIView {
    
    var attrString: NSAttributedString!
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        // Flip the coordinate system
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let path = CGMutablePath()
        path.addRect(self.bounds)
        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        CTFrameDraw(frame, context)
    }
    
    
    func importAttrString(_ attrString: NSAttributedString) {
        self.attrString = attrString
    }
}
