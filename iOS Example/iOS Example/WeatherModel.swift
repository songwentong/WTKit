//
//  WeatherModel.swift
//
//  this file is auto create by WTKit on 2017-12-21 14:02:58.
//  site:https://github.com/swtlovewtt/WTKit
//  Thank you for use my json model maker
//

import WTKit
import UIKit
open class WeatherModel: NSObject {
    var tz:NSNumber?
    var testboolean:NSNumber?
    var testdict:[String:Any]?
    var name:String?
    var id:String?
    var testnull:NSNull?
    var tz_name:String?
    var area:String?
    var Array:[Any]?
    var province:String?
}
extension WeatherModel{
    public func WTJSONModelClass(for property:String)->AnyObject?{
        return nil
    }
}
