//
//  ImageListVC.swift
//  iOS Example
//
//  Created by SongWentong on 31/03/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation
import UIKit
import WTKit
open class ImageListVC:UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var imageURLList:[String] = [String]()
    open override func viewDidLoad() {
        super.viewDidLoad()
        /*
        imageURLList.append("http://www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx?0.35786508303135633")
        imageURLList.append("http://assets.sbnation.com/assets/2512203/dogflops.gif")
        imageURLList.append("https://raw.githubusercontent.com/liyong03/YLGIFImage/master/YLGIFImageDemo/YLGIFImageDemo/joy.gif")
        imageURLList.append("http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp")
        imageURLList.append("http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp")
        imageURLList.append("http://littlesvr.ca/apng/images/SteamEngine.webpp")
        imageURLList.append("http://littlesvr.ca/apng/images/world-cup-2014-42.webp")
        imageURLList.append("https://nr-platform.s3.amazonaws.com/uploads/platform/published_extension/branding_icon/275/AmazonS3.png")
        */
        for i in 0...99{
            var tempString = "https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage"
            if i<10 {
                tempString += "00\(i)"
            }else{
                tempString += "0\(i)"
            }
            tempString += ".jpg"
            imageURLList.append(tempString)
            //https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage1.jpg
        }
    }
    deinit {
        
    }
}
extension ImageListVC:UITableViewDataSource{
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return imageURLList.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        
        return cell
    }
}
extension ImageListVC:UITableViewDelegate{
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if let imageView:UIImageView = cell.contentView.viewWithTag(1) as? UIImageView{
            imageView.wt_setImage(with: imageURLList[indexPath.row])
        }
        if let label:UILabel = cell.contentView.viewWithTag(2) as? UILabel{
            label.text = "Image #\(indexPath.row)"
        }
    }
}
