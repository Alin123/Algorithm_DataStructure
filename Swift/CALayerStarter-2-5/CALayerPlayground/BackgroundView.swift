//
//  BackgroundView.swift
//  CALayerPlayground
//
//  Created by lianzhandong on 2018/5/11.
//  Copyright © 2018年 razerware. All rights reserved.
//

import UIKit

@IBDesignable class BackgroundView: UIView {
    @IBInspectable var lightColor: UIColor = UIColor.orange
    @IBInspectable var darkColor: UIColor = UIColor.yellow
    @IBInspectable var patternSize: CGFloat = 200
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        let drawSize = CGSize(width: patternSize, height: patternSize)
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        let drawingContext = UIGraphicsGetCurrentContext()!
        darkColor.setFill()
        drawingContext.fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: drawSize.width / 2, y: 0))
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height / 2))
        trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height / 2))
        
        trianglePath.move(to: CGPoint(x: 0, y: drawSize.height / 2))
        trianglePath.addLine(to: CGPoint(x: drawSize.width / 2, y: drawSize.height))
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height))
        
        trianglePath.move(to: CGPoint(x: drawSize.width, y: drawSize.height / 2))
        trianglePath.addLine(to: CGPoint(x: drawSize.width / 2, y: drawSize.height))
        trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height))
        
        lightColor.setFill()
        trianglePath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        UIColor(patternImage: image).setFill()
        context.fill(rect)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
