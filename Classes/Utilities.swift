//
//  Utilities.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/23/23.
//

import Foundation
struct Utilities {
    
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


