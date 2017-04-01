//
//  DetailViewController.swift
//  iOS Example
//
//  Created by SongWentong on 01/04/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation
import UIKit
public class DetailViewController:UIViewController{
    public var imageURL:String = ""
    @IBOutlet weak var imageView: UIImageView!
    public override func viewDidLoad() {
        super.viewDidLoad()
        imageView.wt_setImage(with: imageURL)
        
    }
}
