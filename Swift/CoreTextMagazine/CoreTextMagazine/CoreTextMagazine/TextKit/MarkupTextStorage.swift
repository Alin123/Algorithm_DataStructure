//
//  MarkupTextStorage.swift
//  CoreTextMagazine
//
//  Created by lianzhandong on 2018/4/26.
//  Copyright © 2018年 lianzhandong. All rights reserved.
//

import UIKit

class MarkupTextStorage: NSTextStorage {
    var backingStore: NSMutableAttributedString = NSMutableAttributedString()

    
    override var string: String {
        return backingStore.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey : Any] {
        return backingStore.attributes(at:location, effectiveRange: range)
    }
    
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        self.beginEditing()
        backingStore.replaceCharacters(in: range, with: str)
        self.edited(NSTextStorageEditActions.editedCharacters, range: range, changeInLength: str.characters.count - range.length)
        self.endEditing()
    }
    
    override func setAttributes(_ attrs: [NSAttributedStringKey : Any]?, range: NSRange) {
        self.beginEditing()
        backingStore.setAttributes(attrs, range: range)
        self.edited(.editedAttributes, range: range, changeInLength: 0)
        self.endEditing()
    }
    
    override func processEditing() {
    
    }
    
    func performReplacementsForRange(_ changedRange: NSRange) {
        
    }
    func applyStylesToRange(searchRange: NSRange) {
        // create some fonts
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        let boldFontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold)
        let boldFont = UIFont(descriptor: boldFontDescriptor!, size: 0)
        let normalFont = UIFont.preferredFont(forTextStyle: .body)
        
        // match items surrounded by asterisks
        let regexStr = "(\\*\\w+(\\s\\w+)*\\*)"
        do  {
            let regex = try NSRegularExpression(pattern: regexStr)
        } catch _ {
            
        }
        
        
    }
}
