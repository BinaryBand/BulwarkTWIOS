//
//  RecentHomeSold.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 3/14/23.
//

import Foundation

struct RecentHomeSold: Codable {
    
    var zid:String
    var salePrice:String
    var address :String
    var city: String
    var state: String
    var zip: String
    var soldon: String
    var lat: Double
    var lon: Double
    var sqft:String
    var lotsize:String
    var fullAddress:String
    
    
}

struct RecentHomeSoldPostObj:Codable{
    
    var hrempid:String
    var rollingKey:String
    var homeData: [RecentHomeSold]
    
    
}

struct HomeZipCheck:Codable{
    
    var hrempid:String
    var rollingKey:String
    var zipCode: String
}

struct ZipReturn: Codable{
    
    var check : Bool
    var nearZip : String
    
}
