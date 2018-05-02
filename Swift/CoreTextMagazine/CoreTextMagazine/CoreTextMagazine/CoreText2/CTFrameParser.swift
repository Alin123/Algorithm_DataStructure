//
//  CTFrameParserConfig.swift
//  CoreTextMagazine
//
//  Created by lianzhandong on 2018/4/23.
//  Copyright © 2018年 lianzhandong. All rights reserved.
//

import UIKit
import Foundation
import CoreText

class CTFrameParserConfig: NSObject {
    var width: CGFloat = 200.0
    var fontSize: CGFloat = 16.0
    var lineSpace: CGFloat = 1.0
    var textColor: UIColor = UIColor(red: 108/255.0, green: 108/255, blue: 108/255, alpha: 1.0)
}

class CoreTextData: NSObject {
    var ctFrame: CTFrame!
    var height: CGFloat!
    init(frame: CTFrame, height: CGFloat) {
        self.ctFrame = frame
        self.height = height
        super.init()
    }
}

class CTFrameParser: NSObject {
    /// 根据字符串content和config配置信息生成CoreTextData实例
    static func parse(content: String, config: CTFrameParserConfig) -> CoreTextData {
        let dict = CTFrameParser.attributesWith(config: config)
        let attrString = NSAttributedString(string: content, attributes: dict)
        return self.parseAttribute(content: attrString, config: config)
    }
    /// 根据attributeString和config配置生成CoreTextData实例
    static func parseAttribute(content: NSAttributedString, config: CTFrameParserConfig) -> CoreTextData {
        // 创建CTFramesetterRef实例
        let frameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(content)
        
        // 获取要绘制的区域的高度
        let restrictSize = CGSize(width: config.width, height: CGFloat.greatestFiniteMagnitude)
        let coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), nil, restrictSize, nil)
        
        //生成CTFrame实例
        let path = CGPath(rect: CGRect(x: 0, y: 0, width: config.width, height: coreTextSize.height), transform: nil)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        
        
        //将生成的CTFrame和计算好的高度保存在CoreTextData中
        let data = CoreTextData(frame: frame, height: coreTextSize.height)
        return data
    }
    ///  根据config生成配置信息
    static func attributesWith(config: CTFrameParserConfig) -> [NSAttributedStringKey: Any] {
        // 段落样式
        var lineSpacing = config.lineSpace
        var paragraphSapcing = lineSpacing * 1.5 + 5.0//1.5倍行距加5
        var firstLineHeadIndent = paragraphSapcing * 2.0 //首行缩进两倍段间距
        let paragraphSetting: [CTParagraphStyleSetting] = [
            CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.lineSpacingAdjustment,
                                    valueSize: MemoryLayout<CGFloat>.size,
                                    value: &lineSpacing),
            CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.minimumLineSpacing,
                                    valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing),
            CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.maximumLineSpacing,
                                    valueSize: MemoryLayout<CGFloat>.size,
                                    value: &lineSpacing),
            CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.paragraphSpacing,
                                    valueSize: MemoryLayout<CGFloat>.size,
                                    value: &paragraphSapcing),
            CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.firstLineHeadIndent,
                                    valueSize: MemoryLayout<CGFloat>.size,
                                    value: &firstLineHeadIndent)
        ]
        let paragraphStyle = CTParagraphStyleCreate(paragraphSetting, 5)
        
        // 文本样式
        let font = CTFontCreateWithName("Arial" as CFString, config.fontSize, nil)
        // 文本颜色
        let ctColor = config.textColor.cgColor
        
        // 最终的样式字典
        let dict: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: ctColor,
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.paragraphStyle: paragraphStyle
        ]
        return dict
    }
}
