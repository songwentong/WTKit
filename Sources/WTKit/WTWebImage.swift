//
//  File.swift
//  
//
//  Created by 宋文通 on 2020/2/4.
//

import Foundation
#if canImport(UIKit)
import UIKit
open class WebImageView:UIImageView{
    open var webImageTask:URLSessionDataTask? = nil
    //highlightedImage
    open var highlightedImageTask:URLSessionDataTask? = nil
    open func loadWebImage(with path:String) {
        webImageTask?.cancel()
        let size = self.frame.size
        
        webImageTask = URLSession.default.useCacheElseLoadURLData(with: path.urlValue) { [weak self](data, res, err) in
            guard let data = data else{
                return
            }
            guard let img = data.image else{
                return
            }
            img.decodedImage(size) { (image) in
                self?.image = image
                self?.layoutIfNeeded()
            }
        }
        webImageTask?.resume()
    }
    open func loadhighlightedImage(with path:String) {
        highlightedImageTask?.cancel()
        let size = self.frame.size
        highlightedImageTask = URLSession.default.useCacheElseLoadURLData(with: path.urlValue) { [weak self](data, res, err) in
            guard let data = data else{
                return
            }
            guard let img = data.image else{
                return
            }
            
            img.decodedImage(size) { (image) in
                self?.highlightedImage = image
                self?.layoutIfNeeded()
            }
        }
        highlightedImageTask?.resume()
    }
}
open class WebImageButton:UIButton{
    open var webImageTask:URLSessionDataTask? = nil
    open var backgroundImageImageTask:URLSessionDataTask? = nil
    open func loadWebImage(with path:String,for state:UIControl.State) {
        webImageTask?.cancel()
        let size = self.bounds.size
        webImageTask = URLSession.default.useCacheElseLoadURLData(with: path.urlValue, completionHandler: { [weak self](data, res, err) in
            guard let data = data else{
                return
            }
            guard let img = data.image else{
                return
            }
            img.decodedImage(size) { (image) in
                self?.setImage(image, for: state)
                self?.layoutIfNeeded()
            }
        })
        
        webImageTask?.resume()
    }
    open func loadBackgroundImageImage(with path:String,for state:UIControl.State){
        backgroundImageImageTask?.cancel()
        let size = self.frame.size
        backgroundImageImageTask = URLSession.default.useCacheElseLoadURLData(with: path.urlValue, completionHandler: {  [weak self](data, res, err) in
            guard let data = data else{
                return
            }
            guard let img = data.image else{
                return
            }
            img.decodedImage(size) { (image) in
                self?.setImage(image, for: state)
                self?.layoutIfNeeded()
            }
        })
        backgroundImageImageTask?.resume()
    }
}
#endif
