//
//  CTScrollView.swift
//  CoreTextMagazine
//
//  Created by lianzhandong on 2018/4/25.
//  Copyright © 2018年 lianzhandong. All rights reserved.
//

import UIKit

class CTScrollView: UIScrollView {
    var imageIndex: Int!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    /// 创建CTColumnView，并把它们加到UIScrollView中
    func buildFrames(withAttrString attrString: NSAttributedString, andImages images: [[String: Any]]) {
        isPagingEnabled = true
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        var pageView = UIView()
        var textPos = 0  //记录文本位置，每渲染一列(即生成一个CTFrame实例)，textPos += 这一列渲染的字符数，下一个CTFrame从textPos开始渲染字符
        imageIndex = 0
        var columnIndex: CGFloat = 0 //当前列的序号
        var pageIndex: CGFloat = 0   //当前页的序号
        let settings = CTSettings()
        while textPos < attrString.length { //直至字符渲染完成
            if columnIndex.truncatingRemainder(dividingBy: settings.columnsPerPage) == 0 {//如果当前列是这一页中的第一列，
                columnIndex = 0
                //创建新的一页，装下当前列
                // settings.pageRect == (20, 20, screen_width - 40, screen_height - 40)
                // pageView.frame == (20 + n * screen_width, 20 + 0, screen_width - 40, screen_height - 40)
                pageView = UIView(frame: settings.pageRect.offsetBy(dx: pageIndex * bounds.width, dy: 0))//x轴偏移➡️，这是一个横向滑动的ScrollView
                addSubview(pageView)
                pageIndex += 1
            }
            let columnXOrigin = pageView.frame.size.width / settings.columnsPerPage
            let columnOffset = columnIndex * columnXOrigin                          //0 或者 一个pageRect.width * 0.5
            let columnFrame = settings.columnRect.offsetBy(dx: columnOffset, dy: 0)
            let path = CGMutablePath()
            path.addRect(CGRect(origin: .zero, size: columnFrame.size))
            // framesetter 根据指定区域，从字符串的指定位置开始创建CTFrame，CTFrame可直接渲染到View上
            let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, nil)
            
            let column = CTColumnView(frame: columnFrame, ctframe: ctframe) //CTFrame将渲染到CTColumnView上
            pageView.addSubview(column)
            //ctframe对应的字符集中是否有图片的占位字符，若有，根据占位字符在当前ctframe中的信息(位置等)确定图片的位置信息
            if images.count > imageIndex {
                attachImagesWithFrames(images, ctframe: ctframe, margin: settings.margin, columnView: column)
            }
            
            let frameRange = CTFrameGetVisibleStringRange(ctframe)
            textPos += frameRange.length
            
            columnIndex += 1
        }
        contentSize = CGSize(width: CGFloat(pageIndex) * bounds.size.width, height: bounds.size.height)
    }
    
    
    /*
     ------------------------------------------------------------------------------------------------
     |20                              2020
     |  |----------------------------|    |----------------------------|
     |  |20        pageView        20|    |20        pageView        20|
     |  |  |---------|  |---------|  |    |  |---------|  |---------|  |
     |  |  |         |  |         |  |    |  |         |  |         |  |
     |  |  |  column |40|         |  |    |  |  column |40|         |  |
     |  |  |   view  |  |         |  |    |  |   view  |  |         |  |
     |  |  |         |  |         |  |    |  |         |  |         |  |
     |  |  |---------|  |---------|  |    |  |---------|  |---------|  |
     |  |                            |    |                            |
     |  |----------------------------|    |----------------------------|
     |20
     ------------------------------------------------------------------------------------------------
     */
    func attachImagesWithFrames(_ images: [[String: Any]],
                                ctframe: CTFrame,
                                margin: CGFloat,
                                columnView: CTColumnView) {
        let lines = CTFrameGetLines(ctframe) as NSArray
        // 获取每一行的原点坐标
        var origins = [CGPoint](repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), &origins)
        
        var nextImage = images[imageIndex]
        guard var imgLocation = nextImage["location"] as? Int else {
            return
        }
        for lineIndex in 0..<lines.count {
            let line = lines[lineIndex] as! CTLine
            if let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun],
                let imagesFileName = nextImage["filename"] as? String,
                let img = UIImage(named: imagesFileName) {
                for run in glyphRuns {
                    let runRange = CTRunGetStringRange(run) //当前块儿所在区间
                    //找出图片对应的占位符
                    if runRange.location > imgLocation || runRange.location + runRange.length <= imgLocation {
                        continue
                    }
                    var imageBounds: CGRect = .zero
                    var ascent: CGFloat = 0
                    imageBounds.size.width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, nil, nil))
                    imageBounds.size.height = ascent
                    //获取占位符的偏移量
                    let xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
                    imageBounds.origin.x = origins[lineIndex].x + xOffset //对应行的x坐标 + 占位符偏移量 -> 图片的x坐标
                    imageBounds.origin.y = origins[lineIndex].y           //对应行的y坐标              -> 图片的y坐标
                    
                    columnView.images.append((image: img, frame: imageBounds)) // [图片，frame]
                    imageIndex! += 1
                    if imageIndex < images.count {
                        nextImage = images[imageIndex]
                        imgLocation = (nextImage["location"] as! NSNumber).intValue
                    }
                }
            }
        }
    }
}
