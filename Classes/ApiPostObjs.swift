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

struct ProactiveApiPost:Codable{
    
    var HrEmpId: String
    var RollingKey: String
    var lat: Double
    var lon:Double
    var reportType:Int
    var searchString:String
}
