//
//  StationCheck.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 7/13/23.
//

import Foundation
struct StationCheck:Codable{
    
    var workOrderItemId:Int
    var barcode:String
    var result:String
    var photoBase64:String
    var lat:Double
    var lon:Double
    var timeChecked:Double
    var stationNumber:Int
    var isNew:Bool
    var id:Int
}


struct StationHomeData:Codable{
    
    var footPrint:[[GpsPoint]?]?
    var stations:[StationCheck]?
    var additionalConditions:[TermiteCondition]?
    var footPrintNeedsVerified:Bool?
    var isNew:Bool?
    
}

struct TermiteCondition:Codable{
    var typeId:Int //1 conducive conditions, 2 termite damage, 3 active termites, 4 mud tubes, 5 drill, 6 trench
    var lat:Double
    var lon:Double
    var markerId:String
}
