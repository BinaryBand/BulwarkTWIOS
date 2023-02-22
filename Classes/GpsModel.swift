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
struct GpsPostResult:Codable{
    var success:Int
}
@objc public class GpsModels: NSObject{
    private override init() {}
   
    
    @objc func saveGpsFile(hrempid:String, truck:String, office:String, time:Date, lat:Double, lon:Double, course:Double, speed:Double, distance:Double, odo:String, odometerTime:Date) ->Bool{
        
        let ts = time.toString(format: .usDateTime24WithSec) ?? "1/1/1970"
        
        let odometer = Double(odo) ?? 0
        let ot = odometerTime.toString(format: .usDateTime24WithSec) ?? "1/1/1970"
        
        
        let gm = GpsModel(hrempid: hrempid, rollingKey: "", truck: truck, office: office, timeStamp: ts, lat: lat, lon: lon, course: course, speed: speed, distance: distance, odometer: odometer, odometerTimeStamp: ot)
        
        DataUtilities.saveGpsJsonFile(gpsData: gm)
        

        return true
        
    }
    
}
