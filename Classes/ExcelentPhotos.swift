//
//  ExcelentPhotos.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/3/23.
//

import Foundation

struct  ExcelentPhotos: Codable {
    
    
    var Categories:[PhotoCatagories]
    var Tags:[PhotoCatagories]
    var Id:Int?
    var MarketingGrade:Int?
    var DateCreated:String?
    var AccountNumber:String?
    var ToCustomerId:Int?
    var WorkOrderId:Int?
    var MediaUrl:String?
    var Date:String?
    var ProName:String?
    var OfficeName:String?
    var SubmittedAsExcellentPhoto:Bool?
    
}
struct PhotoCatagories:Codable{
    
    
    var Id:Int?
    var Name:String?
    
    
}
struct ExcelentPhotoImage{
    var img:UIImage?
    var id:Int?
    
}
