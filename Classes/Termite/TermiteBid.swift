//
//  TermiteBid.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 4/19/23.
//

import Foundation
struct TermiteBid: Codable{
    var rollingKey:String
    var workOrderId:Int
    var serviceType:String
    var hrEmpId:String
    var mediaBase64:String
    var status:String
    var address:String
    var bidType:String
    var isPrice:Double
    var recPrice:Double
    var notes:String
}
