//
//  CTDisplayView.swift
//  CoreTextMagazine
//
//  Created by lianzhandong on 2018/4/23.
//  Copyright © 2018年 lianzhandong. All rights reserved.
//

import UIKit
import CoreText

class CTDisplayView: UIView {
    //MARK: 属性
    var ctData: CoreTextData?
    //MARK: 初始化
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let data = self.ctData, let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.textMatrix = .identity
        context.translateBy(x: 0, y: self.bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        CTFrameDraw(data.ctFrame, context)
        if let imagedTextData = ctData as? CTTextImageData {
            let array = imagedTextData.imageArray
            for imageData in array {
                if let cgImage = UIImage(named: imageData.name)?.cgImage {
                    context.draw(cgImage, in: imageData.imagePosition)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTapGesture()
    }
    //MARK: 点击事件
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(respondsTap(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func respondsTap(_ tap: UITapGestureRecognizer) {
        guard let imageDataArray = (self.ctData as? CTTextImageData)?.imageArray else { return }
        let point = tap.location(in: self)
        var pointAtImage = false
        for imageData in imageDataArray {
            let imageRect = imageData.imagePosition
            var imagePosition = imageRect!.origin
            imagePosition.y = bounds.size.height - imageRect!.origin.y - imageRect!.size.height
            let rect = CGRect(origin: imagePosition, size: imageRect!.size)
            if rect.contains(point) {
                print("tap image: \(point.x) \(point.y)")
                pointAtImage = true
                break
            }
        }
        if !pointAtImage, let link = linkDataAt(point: point) {
            print("tap link: \(link.url)")
        }
    }
    //MARK:
    func linkDataAt(point: CGPoint) -> CTLinkData? {
        guard let linkDataArray = (self.ctData as? CTTextImageData)?.linkArray else { return nil }
        if linkDataArray.isEmpty {
            return nil
        }
        guard let frame = self.ctData?.ctFrame else { return nil }
        let lines = CTFrameGetLines(frame)
        let count = CFArrayGetCount(lines)
        var origins = [CGPoint](repeating: .zero, count: count)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        guard let lineArray = lines as? [CTLine] else {
            return nil
        }
        
        for i in 0..<count {
            let ori = origins[i]
            let line = lineArray[i]

            var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
            let width = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, &leading))
            let height = ascent + descent
            var rect = CGRect(origin: ori, size: CGSize(width: width, height: height))
            rect = rect.applying(CGAffineTransform.identity.translatedBy(x: 0, y: self.bounds.size.height).scaledBy(x: 1.0, y: -1.0))
            if rect.contains(point) {
                let relativePoint = CGPoint(x: point.x - rect.origin.x, y: point.y - rect.origin.y)
                let idx = CTLineGetStringIndexForPosition(line, relativePoint)
                for link in linkDataArray {
                    if NSLocationInRange(idx, link.range) {
                        return link
                    }
                }
                break;
            }
        }
        return nil
    }
}
