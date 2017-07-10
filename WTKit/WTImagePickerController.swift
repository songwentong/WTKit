//
//  WTImagePicker.swift
//  WTKit
//
//  Created by SongWentong on 07/07/2017.
//  Copyright © 2017 songwentong. All rights reserved.
//

import Foundation
import UIKit

private class test:UIImagePickerController{
    
}
open class WTImagePickerController: UINavigationController {
    weak var imagePickerDelegate: WTImagePickerControllerDelegate?
    let collectionView:UICollectionView = UICollectionView.init()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.frame = self.view.bounds
    }
    required convenience public init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
        
    }
    
    
}
