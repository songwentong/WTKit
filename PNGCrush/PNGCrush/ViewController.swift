//
//  ViewController.swift
//  PNGCrush
//
//  Created by Wentong Song on 2018/4/12.
//  Copyright © 2018年 Wentong Song. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var workPath = "/Users/songwentong/Desktop/images"
        workPath = "/"
        ///Users/wentongsong/Documents/cars 文稿
        _ = findPaths(for: workPath)
    }
    func findPaths(for workPath:String) -> [String] {
        guard let subpaths = FileManager.default.subpaths(atPath: workPath) else {
            return []
        }
        var all:[String] = [String]()
        var isDir:ObjCBool = false
//        UnsafeMutablePointer.init()
        ///       var number = 5
        ///       let numberPointer = UnsafeMutablePointer<Int>(&number)
        ///       // Accessing 'numberPointer' is undefined behavior.
        let pointer = UnsafeMutablePointer<ObjCBool>(&isDir)
        /*
        for path in subpaths{
            if FileManager.default.fileExists(atPath: path, isDirectory: pointer){
                //dir
                all.append(contentsOf: findPaths(for: path))
            }else{
                all.append(path)
            }
        }*/
        return all
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

