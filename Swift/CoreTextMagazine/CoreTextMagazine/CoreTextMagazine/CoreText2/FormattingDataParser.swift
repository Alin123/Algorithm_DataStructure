//
//  FormattingDataParser.swift
//  CoreTextMagazine
//
//  Created by lianzhandong on 2018/4/26.
//  Copyright © 2018年 lianzhandong. All rights reserved.
//

import UIKit

class CTImageData: NSObject {
    var name: String
    var position: Int
    var imagePosition: CGRect!
    init(name: String, position: Int) {
        self.name = name
        self.position = position
        super.init()
    }
}

class CTLinkData: NSObject {
    var title: String
    var url: String
    var range: NSRange
    init(title: String, url: String, range: NSRange) {
        self.title = title
        self.url = url
        self.range = range
        super.init()
    }
}

class CTTextImageData: CoreTextData {
    var linkArray: [CTLinkData] = [CTLinkData]()
    var imageArray: [CTImageData] = [CTImageData]() {
        didSet {
            if imageArray.count < 1 {
                return
            }
            let lines = CTFrameGetLines(ctFrame) as NSArray
            let lineCount = (lines as Array).count
            var lineOrigins: [CGPoint] = [CGPoint](repeating:.zero, count: lineCount)
            CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), &lineOrigins)
            
            var idx = 0
            var imageData = imageArray[idx]
            for i in 0..<lineCount {
                if !(idx < imageArray.count) {
                    break;
                }
                let line = lines[i] as! CTLine
                if let runs = CTLineGetGlyphRuns(line) as? [CTRun] {
                    for run in runs {
                        let runRange = CTRunGetStringRange(run)
                        if runRange.location > imageData.position || runRange.location + runRange.length <= imageData.position {
                            continue
                        }
                        var imageBounds: CGRect = .zero
                        var ascent: CGFloat = 0
                        imageBounds.size.width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, nil, nil))
                        imageBounds.size.height = ascent
                        let offsetX = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
                        let lineOrigin = lineOrigins[i]
                        imageBounds = imageBounds.offsetBy(dx: lineOrigin.x + offsetX, dy: lineOrigin.y)
                        
                        imageData.imagePosition = imageBounds
                        idx += 1
                        if idx < imageArray.count {
                            imageData = imageArray[idx]
                        } else {
                            break
                        }
                    }
                }
            }
        }
    }
}

class FormattingDataParser: NSObject {
    static func parseTemplateFile(with nameWithExpand: String, config: CTFrameParserConfig) -> CTTextImageData? {
        let strings = nameWithExpand.split(separator: ".")
        let filePath = Bundle.main.path(forResource: "CTTest", ofType: "json")
        if let filePath = filePath  {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let array = dict as? [[String: Any]] {
                    return parseFormattingData(in: array, config: config)
                }
            } catch _ {
                
            }
        }
        return nil
    }
    static func parseFormattingData(in array: [[String: Any]], config: CTFrameParserConfig) -> CTTextImageData {
        let attrString = NSMutableAttributedString()
        var imageDataArray = [CTImageData]()
        var linkDataArray = [CTLinkData]()
        let commonDict = CTFrameParser.attributesWith(config: config)
        
        for item in array {
            guard let type = item["type"] as? String else { continue }
            switch type {
            case "txt":
                let txt = item["content"] as! String
                var customDict = commonDict
                if let size = item["size"] as? Int {
                    let font = CTFontCreateWithName("Arial" as CFString, CGFloat(size), nil)
                    customDict[NSAttributedStringKey.font] = font
                }
                if let str = item["color"] as? String, let color = str.ctColor {
                    customDict[NSAttributedStringKey.foregroundColor] = color.cgColor
                }
                let str = NSAttributedString(string: txt, attributes: customDict)
                attrString.append(str)
            case "img":
                let name = item["name"] as! String
                let position = attrString.length
                let imageData = CTImageData(name: name, position: position)
                imageDataArray.append(imageData)
                let placeholder = FormattingDataParser.placeholderForImage(at: item, maxWidth: config.width)
                attrString.append(placeholder)
            case "link":
                let startPos = attrString.length
                let content = item["content"] as! String
                let url = item["url"] as! String
                var customDict = commonDict
                if let str = item["color"] as? String, let color = str.ctColor {
                    customDict[NSAttributedStringKey.foregroundColor] = color.cgColor
                }
                customDict[NSAttributedStringKey.underlineStyle] = NSNumber(value: 1)
                let linkStr = NSAttributedString(string: content, attributes: customDict)
                attrString.append(linkStr)
                let endPos = attrString.length - startPos
                let linkData = CTLinkData(title: content, url: url, range: NSMakeRange(startPos, endPos))
                linkDataArray.append(linkData)
            default:
                print("Cannot draw \(item) in view!")
            }
        }
        return FormattingDataParser.parseAttributeString(attrString, width: config.width, imageArray: imageDataArray, linkArray: linkDataArray)
    }
    
    static func placeholderForImage(at item: [String: Any], maxWidth: CGFloat) -> NSAttributedString {
        
        var width = item["width"] as! CGFloat
        var height = item["height"] as! CGFloat
        if width > maxWidth {
            height = height * (maxWidth / width)
            width = maxWidth
        }
        struct HolderStruct {
            let ascent: CGFloat
            let descent: CGFloat
            let width: CGFloat
        }
        let extentBuffer = UnsafeMutablePointer<HolderStruct>.allocate(capacity: 1)
        extentBuffer.initialize(to: HolderStruct(ascent: height, descent: 0, width: width))
        var callbacks = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (_) in
            
        }, getAscent: { (pointer) -> CGFloat in
            let d = pointer.assumingMemoryBound(to: HolderStruct.self)
            return d.pointee.ascent
        }, getDescent: { (pointer) -> CGFloat in
            let d = pointer.assumingMemoryBound(to: HolderStruct.self)
            return d.pointee.descent
        }, getWidth: { (pointer) -> CGFloat in
            let d = pointer.assumingMemoryBound(to: HolderStruct.self)
            return d.pointee.width
        })
        let delegate = CTRunDelegateCreate(&callbacks, extentBuffer)
        let attrDintionaryDelegate = [(kCTRunDelegateAttributeName as NSAttributedStringKey) : (delegate as Any)]
        return NSAttributedString(string: " ", attributes: attrDintionaryDelegate)
    }
    
    
    static func parseAttributeString(_ string: NSAttributedString, width: CGFloat, imageArray:[CTImageData], linkArray: [CTLinkData]) -> CTTextImageData {
        let framesetter = CTFramesetterCreateWithAttributedString(string as CFAttributedString)
        
        var size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, size, nil)
        
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: size))
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        let textImageData = CTTextImageData(frame: frame, height: size.height)
        textImageData.imageArray = imageArray
        textImageData.linkArray = linkArray
        return textImageData
    }
}

extension String {
    var ctColor: UIColor? {
        switch self {
        case "blue":
            return UIColor.blue
        case "red":
            return UIColor.red
        case "black":
            return UIColor.black
        default:
            return nil
        }
    }
}






