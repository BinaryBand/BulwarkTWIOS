//
//  GpsModel.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 2/14/23.
//

import Foundation

struct GpsModel:Codable{
    var hrempid:String
    var rollingKey:String
    var truck:String
    var office:String
    var timeStamp:String
    var lat:Double
    var lon:Double
    var course:Double
    var speed:Double
    var distance:Double
    var odometer:Double
    var odometerTimeStamp:String
}
