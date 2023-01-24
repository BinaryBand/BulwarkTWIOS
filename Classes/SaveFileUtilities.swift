//
//  SaveFileUtilities.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/23/23.
//

import Foundation

struct SaveFileUtilities {
    
    
    
    
    static func SavePostingResults(UrlToStave: String, Lat: String, Lon: String, Vin: String, Odometer: String, OdoLastUpdated:String, Rdate: String) -> Bool {
        
        let tt = UrlToStave.replacingOccurrences(of: " ", with: "%20") + "&date=" + Rdate.replacingOccurrences(of: " ", with: "%20")
        
        let t = tt + "&lat=" + Lat + "&lng=" + Lon + "&vin=" + Vin + "&odo=" + Odometer + "&ododate="
        
        let newUrl = t + (OdoLastUpdated.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "1/1/1900")
        
        
        
        return SaveUrlToPost(UrlToSave: newUrl)
        
    }
    
    
    static func SaveUrlToPost(UrlToSave: String) -> Bool {
        
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("services").appendingPathComponent(uniqueFileName())
            //let fileName = uniqueFileName()
            //writing
             do {
             try UrlToSave.write(to: fileURL, atomically: true, encoding: .utf8)
                 return true
             }
             catch {
                let fal = false
                 return fal
                 
                 
             }
             
            
        }else{
            return false
        }
        
        
    }
            
            
            
        
        
        
      static func uniqueFileName() -> String{
            
          
            
            let uuid = UUID().uuidString
            
            return uuid + ".tw"
            
        }// time filelabel
    
    
    
    
    
    
    } //end struct
    
    
    
    
    

