//
//  AuthCookie.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/9/23.
//

import Foundation

struct AuthCookie:Codable{

    var HrEmpId: String
    var RollingKey: String
    
}

struct HomeFootPrintPost:Codable{
    var HrEmpId: String
    var RollingKey: String
    var WorkOrderId:Int
}

struct ProactiveApiPost:Codable{
    
    var HrEmpId: String
    var RollingKey: String
    var lat: Double
    var lon:Double
    var reportType:Int
    var searchString:String
}


struct TBSStationCheckPost:Codable{
    
    var  HrEmpId: String
    var  RollingKey: String
    var  CustomerId: Int
    var  ServiceId: Int
    var  AccountNumber: String
    var  Name: String
    var  Address: String
    var  ServiceType: String
    var  Result: String
    var  Lat: Double
    var  Lon: Double
    var  LinnearFeet: Int
    var  WorkOrderId: Int
    var  WorkOrderItemId: Int
    var  ServiceStart: String
    var  ServiceEnd: String
    var  footPrint:[[GpsPoint]?]
    var  stations:[StationCheck]
    var additionalConditions:[TermiteCondition]
    var footprintImageBase64:String
    var liquidLF:Double
    var liquidProduct:String
   
    
}

