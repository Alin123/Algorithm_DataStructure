//
//  MedalView.swift
//  CALayerPlayground
//
//  Created by lianzhandong on 2018/5/13.
//  Copyright © 2018年 razerware. All rights reserved.
//

import UIKit

class MedalView: UIImageView {
    lazy var medalImage: UIImage = self.createMedalImage()
    func showMedal(show: Bool) {
        image = (show == true) ? medalImage : nil
    }
}

extension MedalView {
    func createMedalImage() -> UIImage {
        let size = CGSize(width: 120, height: 200)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        let darkGoldColor = UIColor(red: 0.6, green: 0.5, blue: 0.15, alpha: 1.0)
        let midGoldColor = UIColor(red: 0.86, green: 0.73, blue: 0.3, alpha: 1.0)
        let lightGoldColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0)
        // 上阴影
        let shadow: UIColor = UIColor.black.withAlphaComponent(0.8)
        let offset = CGSize(width: 2.0, height: 2.0)
        let blurRadius: CGFloat = 5
        context.setShadow(offset: offset, blur: blurRadius, color: shadow.cgColor)
        // 开始透明层
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        // 开始绘制组合对象
        // 较低的带子
        let lowerRibbonPath = UIBezierPath()
        lowerRibbonPath.move(to: CGPoint(x: 0, y: 0))
        lowerRibbonPath.addLine(to: CGPoint(x: 40, y: 0))
        lowerRibbonPath.addLine(to: CGPoint(x: 78, y: 70))
        lowerRibbonPath.addLine(to: CGPoint(x: 38, y: 70))
        lowerRibbonPath.close()
        UIColor.red.setFill()
        lowerRibbonPath.fill()
        // 环
        let claspPath = UIBezierPath(roundedRect: CGRect(x: 36, y: 62, width: 43, height: 20), cornerRadius: 5)
        claspPath.lineWidth = 5
        darkGoldColor.setStroke()
        claspPath.stroke()
        // 保存上下文
        context.saveGState()
        // 圆形浮雕
        let medallionPath = UIBezierPath(ovalIn: CGRect(x: 8, y: 72, width: 100, height: 100))
        medallionPath.addClip()
        let colors = [darkGoldColor.cgColor, midGoldColor.cgColor, lightGoldColor.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0, 0.51, 1])!
        context.drawLinearGradient(gradient, start: CGPoint(x: 40, y: 40), end: CGPoint(x: 100, y: 160), options: [])
        // 画浮雕里的内圆
        var transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        transform = transform.translatedBy(x: 15, y: 30)
        medallionPath.lineWidth = 2.0
        medallionPath.apply(transform)
        medallionPath.stroke()
        // 恢复上下文
        context.restoreGState()
        // 较高的带子
        let upperRibbonPath = UIBezierPath()
        upperRibbonPath.move(to: CGPoint(x: 68, y: 0))
        upperRibbonPath.addLine(to: CGPoint(x: 108, y: 0))
        upperRibbonPath.addLine(to: CGPoint(x: 78, y: 70))
        upperRibbonPath.addLine(to: CGPoint(x: 38, y: 70))
        upperRibbonPath.close()
        UIColor.blue.setFill()
        upperRibbonPath.fill()
        // 画数字1
        let numberOne = "1" as NSString
        let numberRect = CGRect(x: 47, y: 100, width: 50, height: 50)
        let font = UIFont(name: "Academy Engraved LET", size: 60)!
        let numberOneAttributes = [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: darkGoldColor
        ]
        numberOne.draw(in: numberRect, withAttributes: numberOneAttributes)
        // 结束透明层
        context.endTransparencyLayer()
        
        // 生成图片
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
