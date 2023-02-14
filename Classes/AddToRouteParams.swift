//
//  AddToRouteParams.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 11/17/22.
//

import Foundation

struct AddToRouteParams: Codable {
    
    var RouteId: Int
    var StartAt: String
    var FromHrEmpId: String
    var RollingKey: String
    var FromPage: String
    var CustomerId: Int
    var ServiceId: Int
    var isNC: Bool
    var isTransfer:Bool?
    var workOrderId:Int?
  
}
