//
//  RouteStop.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 10/24/22.
//

import Foundation

struct RouteStop : Codable {
    var serviceType: String
    var timeBlock: String
    var estArrival: String
    var account: String
    var name: String
    var contacted: String
    var redAlert: String
    var blueAlert: String
    var grid: String
    var type: Int
    var notes: String
    
    var encodedurl : String
    var barcolor : String
    var workorderitem_id : Int
    var workorder_id : Int
    var address : String
    var equiptment : String
    var drivecomm : String
    var serviceresult : String
    
    
    var ttvid : Int
    var hrempid : Int
    var ttvTitle : String
    var ttvDescription : String
    var order : Int
    var hasNotification : Int
    var istextNotification : Int
    var notificationMessage : String
    var notificationtime : String
    
    var rdate:String
    var lat:Double
    var lon:Double
    
    
}
