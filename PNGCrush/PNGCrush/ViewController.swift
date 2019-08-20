//
//  ViewController.swift
//  PNGCrush
//
//  Created by Wentong Song on 2018/4/12.
//  Copyright © 2018年 Wentong Song. All rights reserved.
//  图片压缩机

import Cocoa

class ViewController: NSViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urls:[URL] = FileManager.default.urls(for: .desktopDirectory, in: .allDomainsMask)
        print("urls:\(urls)")
//        guard let first = urls.first else{return}
        ///Users/wentongsong/Documents/cars 文稿
//        _ = findPaths(for: "/Users/wentongsong/WorkSpace/PC")
    }
    func findPaths(for workPath:String) -> [String] {
        do {
            let list = try FileManager.default.subpathsOfDirectory(atPath: workPath)
            return list
        } catch let e {
            print("\(e)")
            return []
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

