//
//  ProactiveItems.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/28/23.
//

import Foundation

struct ProactiveAccount: Codable {
    
    var accountNumber : String?
    var customerId    : Int?
    var address       : String?
    var grid          : String?
    var serviceId     : Int?
    var serviceType   : String?
    var name          : String?
    var lastService   : String?
    var lat           : Double?
    var lon           : Double?
    var distance      : Double?
    var needs         : String?
    var status        : String?
    var detailsUrl    : String?
    var reporttype    : String?
    var onRoute       : Bool?
    var canTransfer   : Bool?
    var routeId       : Int?
    var contacted     : Bool?
    var workOrderId   : Int?
    var typeId        : Int?
}
extension ProactiveAccount: Comparable {
    static func <(lhs: ProactiveAccount, rhs: ProactiveAccount) -> Bool {
        lhs.distance ?? -100 < rhs.distance ?? -100
    }
}
