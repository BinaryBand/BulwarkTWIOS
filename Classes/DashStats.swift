//
//  DashStats.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/26/23.
//

import Foundation
struct DashStats:Codable {
 
    var success: Int
    var serviceprostats:Stats
    

    
}
struct Stats:Codable {
    
            var id:Int
            var hrEmpId:Int
            var monthFor:String
            var photoRatio:Double
            var photoRatioString:String
            var onTime:Double
            var onTimeString:String
            var finisher:Double
            var finisherString:String
            var retention31:Double
            var retention31String:String
            var retentionRolling:Double
            var retentionRollingString:String
            var completion:Double
            var completionString:String
            var proactiveAdds:Int
            var reviewsAll:Int
            var reviewsBad:Int
            var isExtDaysOff:Int
            var isExtOptIns:Int
            var fastComm:Double
            var fastCommDue:Double
            var fastCommMtd:Double
            var salesYtdpay:Double
            var salesYtdcount:Int
            var salesYtdrank:Int
            var salesMtdpay:Double
            var salesMtdcount:Int
            var salesMtdrank:Int
            var salesActiveAccount:Int
            var photoLottoTickets:Int
            var photoLottoPot:Double
    
}
