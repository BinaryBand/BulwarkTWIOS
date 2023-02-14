//
//  FastComm.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 2/6/23.
//

import Foundation
struct FastComm {
    
    static func fastcommBtnLabel(hrempid: String) async -> String {
      
            
        
        let ists = await DataUtilities.GetIsTS(hrempid: hrempid)
        
        var amt = "$30"
        if ists{
            amt = "$35"
        }

        
        var lbl = "$5 Guaranteed"
            
            
            let type = checkFastCommTime()
            if type == 1{
                lbl = "$5 Guaranteed"
            }else if type == 2{
                lbl = "IS=" + amt + "+5 & CB=$13+5"
            }else{
                lbl = "$5 Tomorrow"
            }
                
        return lbl
     
        
    }
    
    
    
    static func checkFastCommTime() -> Int{
        
        
        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print("hours = \(hour):\(min):\(seconds)")
        
       
        let timeclick =  (hour * 60) + min

        if timeclick >= 510 {
            
            if hour >= 15{
                return 3
            }else{
                
                return 2
                
            }
                
            
        }else{
            return 1
                
        }
        
    }
    
    
   static func getfastCommMessage(ists: Bool) ->String{
        
        let type = checkFastCommTime()
        var amt = "$30"
        if ists {
            amt = "$35"
        }
        
       var fastCommMessage = ""
        
        if type == 1  {
            fastCommMessage = "This may extend my route by one hour today. \n\nThe office will not call me for further permission. \n\n$5 Guaranteed just for accepting and \n" + amt + " Commissions if an IS is added to your route. /n$13 Commissions for a CB or urgent Regular service"
            
            
        }else if type == 2{
            fastCommMessage = "This may extend my route for services by one hour today. \n\nThe office will not call me for further permission. \n\n" + amt + " for IS or 13 for CB and 5$ for accepting, only if a Service is added today. \n\nPress the button before 8:30AM to guarantee $5 tomorrow."
            
            
        }else{
            fastCommMessage = "This may extend my route for TOMORROW for services by one hour. \n\nThe office will not call me for further permission. \n$5 Guaranteed just for accepting and \n" + amt + " for IS or $13for CB if an service is added to your route."
            
        }
        
      return fastCommMessage

        
        
    }
    
    
  static func getlastFastCommSubmitTime() -> Date{
        
        let defaults = UserDefaults.standard
        
        let punchint = defaults.double(forKey: "LastFCTime")
        let punchdate = Date(timeIntervalSince1970: punchint)
        return punchdate
    }
    
    static func SaveFCTime(){
        let defaults = UserDefaults.standard
        
    defaults.set(Date().timeIntervalSince1970, forKey: "LastFCTime")
    
 
    }
    static func checkFcPressedAlready() ->Bool{
        
       
        let d = getlastFastCommSubmitTime()
        
       
        let dayofweek = Calendar.current.component(.weekday, from: d)
       

        
        var y =  Calendar.current.startOfDay(in: -1)
        
        if dayofweek == 1 {
            //clicked on sunday for monday
            y =  Calendar.current.startOfDay(in: -2)
        }
        
        let t = Calendar.current.startOfDay(in: 0)
        
        let yesterday3pm = y?.addingTimeInterval(54000) ?? Date()
        let today3pm = t?.addingTimeInterval(54000) ?? Date()
        
        
        
        let range = yesterday3pm...today3pm
        
        let type = checkFastCommTime()
        
        if type == 3{
            if d.compare(today3pm) == .orderedDescending {
                //tomorrow already clicked
                return true
            }
        }else{
            if range.contains(d){
                //already clicked
                return true
            }
            
        }
        
       
        

        return false
        
        
        
        
    }
    
    
    
    
    
}
