//
//  FastCommPunch.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 2/6/23.
//

import Foundation
struct FastCommPunch:Codable{
    
   var HrEmpId:String
   var RollingKey:String
   var PunchTime:String
    
}
struct FastCommSubmitResult:Codable {
    var success:Int
    var mtdPay:Double
    var ppPay:Double
    
}
