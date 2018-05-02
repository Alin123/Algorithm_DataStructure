//
//  ViewController.swift
//  CoreTextMagazine
//
//  Created by lianzhandong on 2018/4/23.
//  Copyright © 2018年 lianzhandong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let file = Bundle.main.path(forResource: "zombies", ofType: "txt") else { return }
        do {
            
            let text = try String(contentsOf: URL(fileURLWithPath: file), encoding: .utf8)
            let parser = MarkupParser()
            parser.parseMarkup(text)
            (view as? CTScrollView)?.buildFrames(withAttrString: parser.attrString, andImages: parser.images)
        } catch _ {}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

