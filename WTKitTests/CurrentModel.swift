//
//  CurrentModel.swift
//  WTKit
//
//  Created by SongWentong on 22/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//

import UIKit

class CurrentModel: NSObject {
    var current_version:String?
    var weather:CurrentDetailModel?
    func WTJSONModelClass(for property:String)->AnyObject?{
        return CurrentDetailModel()
    }

}
