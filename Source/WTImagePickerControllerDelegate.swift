//
//  WTImagePickerControllerDelegate.swift
//  WTKit
//
//  Created by SongWentong on 07/07/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation
import UIKit
/*
 
 @available(iOS 2.0, *)
 optional public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
 
 @available(iOS 2.0, *)
 optional public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
 */
/*
    照片选择器,可以选择视频和照片,照片选择数可控,视频选择数可控
 */
public protocol WTImagePickerControllerDelegate:NSObjectProtocol {
    
    //最小照片数
    func minPickNumber(of imagePickerController:WTImagePickerController)
    //最大照片数
    func maxPickNumber(of imagePickerController:WTImagePickerController)
    //选择
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [[String : Any]])
    //取消
    func imagePickerControllerDidCancel(_ picker: WTImagePickerController)
}
