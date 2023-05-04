//
//  Utilities.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/23/23.
//

import Foundation
import Toast
struct Utilities {
    
    
    
    static func haversine(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
        let lat1rad = lat1 * Double.pi/180
        let lon1rad = lon1 * Double.pi/180
        let lat2rad = lat2 * Double.pi/180
        let lon2rad = lon2 * Double.pi/180
        
        let dLat = lat2rad - lat1rad
        let dLon = lon2rad - lon1rad
        let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad)
        let c = 2 * asin(sqrt(a))
        let R = 3959.0
        
        return R * c
    }


    static func CurrentDateString() -> String {
        
        var formatter: DateFormatter?
        var dateString: String?

        formatter = DateFormatter()
        formatter?.dateFormat = "M/d/yyy"

        dateString = formatter?.string(from: Date())
        return dateString ?? "1/1/1900"
        
    }
    static func StandardDateOnlyString(date: Date) -> String {
        
        var formatter: DateFormatter?
        var dateString: String?

        formatter = DateFormatter()
        formatter?.dateFormat = "M/d/yyy"

        dateString = formatter?.string(from: date)
        return dateString ?? "1/1/1900"
        
        
    }
    static func toDateFromStandardString(dateStr: String) -> Date {
       
        let defdate = Date(timeIntervalSince1970: 0)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if dateStr.contains("/"){
            
            let datecomp = dateStr.components(separatedBy: "/")
            if datecomp.count == 3{
                
                let m = Int(datecomp[0])
                let d = Int(datecomp[1])
                let y = Int(datecomp[2])
                
                let comps = DateComponents(year: y, month: m, day: d)
                let userCalendar = Calendar.current

                let dd = userCalendar.date(from: comps) ?? defdate
                return dd
                
            }else{
                return defdate
            }
            
            
            
        }else{
            return defdate
        }
        
            
        
        
    }
    
    
    static func toastStyleCheckmark() -> ToastStyle{
        var style = ToastStyle()
        style.titleFont = UIFont(name: "Arial-BoldMT", size: 14)!
        style.messageFont = UIFont(name: "ArialMT", size: 12)!
        //style.messageColor = UIColor.yellow
        style.messageAlignment = .center
        style.imageSize = CGSize(width: 50, height: 45)
        style.backgroundColor = UIColor(red: 62.0 / 255.0, green: 128.0 / 255.0, blue: 180.0 / 255.0, alpha: 0.9)
        return style
        
        
    }
    
    
   static public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }

    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
    
    
    
}

public extension Double {
    
    
    
    func toPercentString(decimalPlaces:Int = 2) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 3
        formatter.maximumFractionDigits = decimalPlaces
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSDecimalNumber(value: self)) ?? "0.00%"
    }
    func toMoneyString() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 10
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSDecimalNumber(value: self)) ?? "$0.00"
    }
    
    func toNumberString(decimalPlaces:Int = 2) -> String{
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 14
        formatter.maximumFractionDigits = decimalPlaces
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSDecimalNumber(value: self)) ?? "0.00"
        
        
        
    }
    
    
}

public extension Int {
    
    
    func toString() -> String{
        return String(self)
    }

    
    
}

public extension String {
    
    
    func toBase64() -> String {
        
        let encodedString = Base64FS.encodeString(str: self)
        return encodedString

    }
    
    func fromBase64() -> String {
        let decodedString = Base64FS.decodeString(str: self)
        return decodedString
        
        
    }
    
    
}


extension Calendar {
  func startOfDay(byAdding component: Calendar.Component,
                value: Int,
                to date: Date,
                wrappingComponents: Bool = false) -> Date? {
    guard let newDate = self.date(byAdding: component,
                                  value: value,
                                  to: date,
              wrappingComponents: wrappingComponents) else {
        return nil
    }
    return self.startOfDay(for: newDate)
  }
    
    func startOfDay(in days: Int) -> Date? {
      return self.startOfDay(byAdding: .day,
                             value: days,
                             to: Date())
    }
    
    
}
 extension UIAlertController {
    func showAlert(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard let rootVC = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first?.rootViewController else {
            return
        }
        rootVC.present(self, animated: animated, completion: completionHandler)
    }
}
extension URLRequest {
    init?(urlStr: String, hrempid:String, jsonData: Data){
        
        let tempurl = URL(string: urlStr)!
        
        var tempRequest = URLRequest(
            url: tempurl
        )
        
        tempRequest.httpBody = jsonData
        tempRequest.httpMethod = "POST"
        tempRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        tempRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self = tempRequest
        return
    }
    init?(urlStr: String, jsonData: Data){
        
        let tempurl = URL(string: urlStr)!
        
        var tempRequest = URLRequest(
            url: tempurl
        )
        
        tempRequest.httpBody = jsonData
        tempRequest.httpMethod = "POST"
        tempRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        tempRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self = tempRequest
        return
    }
}
