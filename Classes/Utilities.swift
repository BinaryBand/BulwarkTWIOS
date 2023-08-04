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
    static func haversineFeet(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
        let lat1rad = lat1 * Double.pi/180
        let lon1rad = lon1 * Double.pi/180
        let lat2rad = lat2 * Double.pi/180
        let lon2rad = lon2 * Double.pi/180
        
        let dLat = lat2rad - lat1rad
        let dLon = lon2rad - lon1rad
        let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad)
        let c = 2 * asin(sqrt(a))
        let R = 20902230.971129
        
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
    
    func sortConvex(input: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        
        // X = longitude
        // Y = latitude
        
        // 2D cross product of OA and OB vectors, i.e. z-component of their 3D cross product.
        // Returns a positive value, if OAB makes a counter-clockwise turn,
        // negative for clockwise turn, and zero if the points are collinear.
        func cross(P: CLLocationCoordinate2D, _ A: CLLocationCoordinate2D, _ B: CLLocationCoordinate2D) -> Double {
            let part1 = (A.longitude - P.longitude) * (B.latitude - P.latitude)
            let part2 = (A.latitude - P.latitude) * (B.longitude - P.longitude)
            return part1 - part2;
        }
        
        // Sort points lexicographically
        let points: [CLLocationCoordinate2D] = input.sorted { a, b in
            a.longitude < b.longitude || a.longitude == b.longitude && a.longitude < b.longitude
        }
        
        // Build the lower hull
        var lower: [CLLocationCoordinate2D] = []
        
        for p in points {
            while lower.count >= 2 {
                let a = lower[lower.count - 2]
                let b = lower[lower.count - 1]
                if cross(P: p, a, b) > 0 { break }
                lower.removeLast()
            }
            lower.append(p)
        }
        
        // Build upper hull
        var upper: [CLLocationCoordinate2D] = []
        
        for p in points.lazy.reversed() {
            while upper.count >= 2 {
                let a = upper[upper.count - 2]
                let b = upper[upper.count - 1]
                if cross(P: p, a, b) > 0 { break }
                upper.removeLast()
            }
            upper.append(p)
        }
        
        // Last point of upper list is omitted because it is repeated at the
        // beginning of the lower list.
        upper.removeLast()
        
        // Concatenation of the lower and upper hulls gives the convex hull.
        return (upper + lower)
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
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
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
    
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
    
}
extension FloatingPoint {

    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
extension Float{
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
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
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
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
extension UIImage {

  func colorized(color : UIColor) -> UIImage {

    let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)

    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    if let context = UIGraphicsGetCurrentContext() {
        context.setBlendMode(.multiply)
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(self.cgImage!, in: rect)
        context.clip(to: rect, mask: self.cgImage!)
        context.setFillColor(color.cgColor)
        context.fill(rect)
    }

    let colorizedImage = UIGraphicsGetImageFromCurrentImageContext()

    UIGraphicsEndImageContext()
    return colorizedImage!

  }
    func resizeWithScaleAspectFitMode(to dimension: CGFloat) -> UIImage? {

        if max(size.width, size.height) <= dimension { return self }

        var newSize: CGSize!
        let aspectRatio = size.width/size.height

        if aspectRatio > 1 {
            // Landscape image
            newSize = CGSize(width: dimension, height: dimension / aspectRatio)
        } else {
            // Portrait image
            newSize = CGSize(width: dimension * aspectRatio, height: dimension)
        }

        return resize(to: newSize)
    }
   private func resize(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
            self.draw(in: CGRect(origin: .zero, size: newSize))
            defer { UIGraphicsEndImageContext() }
            return UIGraphicsGetImageFromCurrentImageContext()
        }





    

    
    
    
    
}
extension CLLocationCoordinate2D {
    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }

        let lat1 = degreesToRadians(latitude)
        let lon1 = degreesToRadians(longitude)

        let lat2 = degreesToRadians(point.latitude);
        let lon2 = degreesToRadians(point.longitude);

        let dLon = lon2 - lon1;

        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);

        return radiansToDegrees(radiansBearing)
    }
}
