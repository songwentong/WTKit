//
//  WeatherModel.swift
//
//  this file is auto create by WTKit
//  site:https://github.com/swtlovewtt/WTKit
//  Thank you for use my json model maker
//

import WTKit
import UIKit
@objc open class WeatherModel:NSObject{
@objc var tz:NSNumber?
    @objc var testboolean:NSNumber?
    @objc var testdict:[String:Any]?
    @objc var name:String?
    @objc var id:String?
    @objc var testnull:NSNull?
    @objc var tz_name:String?
    @objc var area:String?
    @objc var Array:[Any]?
    @objc var province:String?
}
@objc extension WeatherModel:WTJSONModelProtocol{
    @objc public func WTJSONModelClass(for property:String)->AnyObject?{
        return nil
    }
}
