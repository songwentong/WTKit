//
//  WTPanPop.swift
//  WTKit
//
//  Created by SongWentong on 06/12/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//

import Foundation
import UIKit
private var WTPanToPopGestureRecognizer:Void?
extension UIViewController{
    
    public func panToPop()->UIPanGestureRecognizer{
        
        if let gesture = objc_getAssociatedObject(self, &WTPanToPopGestureRecognizer) as? UIPanGestureRecognizer
        {
            return gesture
        }else{
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(UIViewController.WTPanToPopGestureRecognizer(_:)))
            self.view.addGestureRecognizer(gesture)
        }
    }
    public func WTPanToPopGestureRecognizer(_ gesture:UIPanGestureRecognizer)->Void{
        
    }
}
