//
//  WeatherModel.swift
//  WTKit
//
//  Created by SongWentong on 21/11/2016.
//  Copyright © 2016 songwentong. All rights reserved.
//

import UIKit

public class WeatherModel: NSObject,WTJSONModelProtocol {
    
    var tz:String?
    var area:String?
    var tz_name:String?
    var id:String?
    var name:String?
    var province:String?
    var current:CurrentModel?
    var day:DayModel?
    
    
    public func WTJSONModelClass(for property:String)->AnyObject?{
        if (property == "current") {
            return CurrentModel()
        }
        if property == "day" {
            return DayModel()
        }
        return nil
    }
}
