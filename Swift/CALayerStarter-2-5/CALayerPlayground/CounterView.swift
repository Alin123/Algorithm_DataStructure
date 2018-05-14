//
//  CounterView.swift
//  CALayerPlayground
//
//  Created by lianzhandong on 2018/5/10.
//  Copyright © 2018年 razerware. All rights reserved.
//

import UIKit

@IBDesignable class CounterView: UIView {
    private struct Constants {
        static let numberOfGlasses = 8
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
        
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    
    @IBInspectable var counter: Int = 0 {
        didSet {
            if counter <= Constants.numberOfGlasses {
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange
    
    var MAX: Int {
        return Constants.numberOfGlasses
    }
    
    override func draw(_ rect: CGRect) {
        // 中心点&半径
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius: CGFloat = max(bounds.width, bounds.height) / 2
        // 开始角度&结束角度
        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4
        // 中心点center、半径：中心点到圆环中间线的距离、开始角度、结束角度
        let path = UIBezierPath(arcCenter: center,
                                radius: radius - Constants.arcWidth / 2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        // 画圆弧
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        
        // 圆弧占据的角度
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle
        // 外圈
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: radius - Constants.halfOfLineWidth,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        // 内圈
        outlinePath.addArc(withCenter: center,
                           radius: radius - Constants.arcWidth + Constants.halfOfLineWidth,
                           startAngle: outlineEndAngle,
                           endAngle: startAngle,
                           clockwise: false)
        outlinePath.close()
        // 画线
        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
        
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        outlineColor.setFill()
        let markerWidth: CGFloat = 5.0
        let markerSize: CGFloat = 10.0
        let markerPath = UIBezierPath(rect: CGRect(x: -markerWidth / 2, y: 0, width: markerWidth, height: markerSize))
        context.translateBy(x: rect.width / 2, y: rect.height / 2)
        
        for i in 1...Constants.numberOfGlasses {
            context.saveGState()
            let angle = arcLengthPerGlass * CGFloat(i) + startAngle - .pi / 2
            context.rotate(by: angle)
            context.translateBy(x: 0, y: rect.height / 2 - markerSize)
            markerPath.fill()
            context.restoreGState()
        }
        context.restoreGState()
    }
}



































