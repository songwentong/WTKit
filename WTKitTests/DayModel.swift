//
//  DayModel.swift
//  WTKit
//
//  Created by SongWentong on 22/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//

import UIKit

class DayModel: NSObject {
    var day_version:String?
    var weather:[DayDetailModel]?
    public func WTJSONModelClass(for property:String)->AnyObject?{
        
        
        if (property == "weather") {
            return DayDetailModel()
        }
        return nil
    }
}
