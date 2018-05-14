//
//  PushButton.swift
//  CALayerPlayground
//
//  Created by lianzhandong on 2018/5/10.
//  Copyright © 2018年 razerware. All rights reserved.
//

import UIKit

@IBDesignable
class PushButton: UIButton {
    
    
    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
    
    private var halfWidth: CGFloat {
        return bounds.size.width / 2.0
    }
    
    private var halfHeight: CGFloat {
        return bounds.size.height / 2.0
    }
    
    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var isAddButtion: Bool = true
    
    // The view is new to the screen.
    // Other views on top of it are moved.
    // The view's hidden property is changed.
    // Your app explicitly calls the setNeedsDisplay() or setNeedsDisplayInRect() methods on the view.
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        
        let plusPath = UIBezierPath()
        plusPath.lineWidth = Constants.plusLineWidth
        // 线的左端点
        plusPath.move(to: CGPoint(
            x: halfWidth - halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        // 线的右端点
        plusPath.addLine(to: CGPoint(
            x: halfWidth + halfPlusWidth + Constants.halfPointShift,
            y: halfHeight + Constants.halfPointShift))
        if isAddButtion {
            plusPath.move(to: CGPoint(
                x: halfWidth + Constants.halfPointShift,
                y: halfHeight - halfPlusWidth + Constants.halfPointShift))
            plusPath.addLine(to: CGPoint(
                x: halfWidth + Constants.halfPointShift,
                y: halfHeight + halfPlusWidth + Constants.halfPointShift))
        }
        UIColor.white.setStroke()
        plusPath.stroke()
    }
}
