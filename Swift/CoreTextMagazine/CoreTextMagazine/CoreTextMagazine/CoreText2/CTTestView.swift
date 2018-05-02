//
//  CTTestView.swift
//  CoreTextMagazine
//
//  Created by lianzhandong on 2018/4/24.
//  Copyright © 2018年 lianzhandong. All rights reserved.
//

import UIKit

class CTTestView: CTDisplayView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let config = CTFrameParserConfig()
        config.width = frame.width
        self.ctData = FormattingDataParser.parseTemplateFile(with: "CTTest.json", config: config)
        if self.ctData != nil {
            self.frame = CGRect(origin: frame.origin, size: CGSize(width: frame.size.width, height: self.ctData!.height))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let config = CTFrameParserConfig()
        config.width = frame.width
        self.ctData = FormattingDataParser.parseTemplateFile(with: "CTTest.json", config: config)
        if self.ctData != nil {
            self.frame = CGRect(origin: frame.origin, size: CGSize(width: frame.size.width, height: self.ctData!.height))
        }
    }
    
}
