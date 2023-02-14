//
//  FBFSearch.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 9/21/22.
//

import Foundation
struct FBFSearch : Codable {
    
    var title: String
    var rDate: String
    var tbStart: String
    var tbEnd: String
    var dist: Float
    var route_id: Int
    var type: Int
}

extension FBFSearch{
    static var sampleData = [
        FBFSearch(title: "ME200TerryW Mon-Aug 3rd 2022", rDate: "8/3/2022", tbStart: "13:00", tbEnd: "16:00", dist: 3.452, route_id: 1094256, type: 1),
        FBFSearch(title: "ME200TerryW Tue-Aug 4th 2022", rDate: "8/4/2022", tbStart: "12:00", tbEnd: "15:00", dist: 2.3332, route_id: 1094272, type: 1),
        FBFSearch(title: "ME222TestT Tue-Aug 4th 2022", rDate: "8/4/2022", tbStart: "9:00", tbEnd: "12:00", dist: 6.3332, route_id: 1094442, type: 1),
        FBFSearch(title: "ME200TerryW Wed-Aug 9rd 2022", rDate: "8/3/2022", tbStart: "13:00", tbEnd: "16:00", dist: 5.452, route_id: 1096656, type: 1),
        FBFSearch(title: "ME200TerryW Tue-sept 4th 2022", rDate: "8/4/2022", tbStart: "12:00", tbEnd: "15:00", dist: 1.3832, route_id: 1094872, type: 1)
]
}

