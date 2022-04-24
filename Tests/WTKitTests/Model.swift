//
//  TWGiftWallOuterModel.swift
//
//  this file is auto create by WTKit on 2022-04-24 20:02:49.
//  site:https://github.com/songwentong/ModelMaker
//  Thank you for use my json model maker😜
//

import Foundation
import WTKit
public class TWGiftWallOuterModel:NSObject, Codable {
    public override init() {
        super.init()
    }
    var data:[TWGiftWallOuterModel_data] = [TWGiftWallOuterModel_data]()
    var gift_total:Int = -1
    var page:Int = -1
    var total_page:Int = -1
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case gift_total = "gift_total"
        case page = "page"
        case total_page = "total_page"
    }
    required public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            data = try values.decode([TWGiftWallOuterModel_data].self, forKey: .data)
            gift_total = values.decodeToInt(forKey: .gift_total)
            page = values.decodeToInt(forKey: .page)
            total_page = values.decodeToInt(forKey: .total_page)
        } catch {
            
        }
    }
}
public class TWGiftWallOuterModel_data:NSObject, Codable {
    public override init() {
        super.init()
    }
    var id:Int = -1
    var num:String = ""
    var pic:String = ""
    var title:String = ""
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case num = "num"
        case pic = "pic"
        case title = "title"
    }
    required public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = values.decodeToInt(forKey: .id)
            num = values.decodeToString(forKey: .num)
            pic = values.decodeToString(forKey: .pic)
            title = values.decodeToString(forKey: .title)
        } catch {
            
        }
    }
}
