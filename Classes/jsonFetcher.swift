//
//  jsonFetcher.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 11/8/22.
//

import Foundation

struct JsonFetcher {
    
    enum JsonFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    private static var isSendingGps:Bool = false
    
    
    static func getAuthToken(hrempid: String) -> String {
        
        
        let d = Date()
        
        let k = hrempid + (d.toString(format: .custom("MMyyddyyddMM")) ?? "")
        //print(k)

        
        
        let begToken = "54d566654sfgye3ddrtyabe4444ba81rt67fderolssunfbyhremxzmnhfuyieisk511fdsiujnfuwuqlajdfhte2r3shdfuhyewkaksd5hdusksdfheu4euhr4dfhgh4weiwudb5ioqo45d4acvf4fdfg74651gdfgertrtasadfgdtujndrtbjsiu1212nduelaj124ysadjhsnz15dsdf1ffd5syuyyyaijajaydydbchdksudsufgd4wQsakahdgffszmcsdsfSSTHihhgghd"
        
        let utoken = xorEncryption(clearText: begToken , setKey: k)
        
        let dtoken = Data(utoken)
        
        //let token = String(decoding: utoken, as: UTF8.self)
        let btoken = dtoken.base64EncodedString()
        print(btoken)
        
        return btoken
        
        
    }
    
    
    static func fetchFBFSearch(urlStr: String, completion: @escaping (Result<[FBFSearch], Error>) -> Void) {
        
        // Create URL
        guard let url = URL(string: urlStr) else {
            completion(.failure(JsonFetcherError.invalidURL))
            return
        }
        
        // Create URL session data task
        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(JsonFetcherError.missingData))
                return
            }
            
            do {
                // Parse the JSON data
                let fbfResult = try JSONDecoder().decode([FBFSearch].self, from: data)
                completion(.success(fbfResult))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    
    static func fetchFBFResultsAsync(urlStr: String, hrEmpId: String) async throws -> [FBFSearch] {

        guard let tempurl = URL(string: urlStr) else {
            throw JsonFetcherError.invalidURL
        }

        var tempRequest = URLRequest(
            url: tempurl
        )
        
       
        
        //let token = String(decoding: utoken, as: UTF8.self)
        let btoken = getAuthToken(hrempid: hrEmpId)
        print(btoken)
        
        tempRequest.setValue(
            btoken,
            forHTTPHeaderField: "authorization"
        )
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)
        
        
        // Parse the JSON data
        let fbfResult = try JSONDecoder().decode([FBFSearch].self, from: data)
        return fbfResult
    }
    

    
    static func postAddToRouteJson(urlStr: String, addToRouteParam: AddToRouteParams) async throws -> AddUpdateApiResult {
        
        guard let tempurl = URL(string: urlStr) else {
            throw JsonFetcherError.invalidURL
        }

        var tempRequest = URLRequest(
            url: tempurl
        )
        
        var atpr = addToRouteParam
        
        
        atpr.RollingKey = getAuthToken(hrempid: addToRouteParam.FromHrEmpId)
     
    
        
        tempRequest.httpMethod = "POST"
        tempRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        tempRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let jsonData = try JSONEncoder().encode(atpr)
        
        tempRequest.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)
        
        
        // Parse the JSON data
        let auResult = try JSONDecoder().decode(AddUpdateApiResult.self, from: data)
        return auResult
        
        
    }
    
    
    static func fetchExcelentPhotosAsync(hrempid: String) async throws -> [ExcelentPhotos] {

        var urlparam = "?hrempid=" + hrempid
        if hrempid == "" {
            urlparam = ""
        }
            
        
        var urlStr = "https://kpwebapi2.bulwarkapp.com/api/marketing/getrecenttopratedimages" + urlparam
        
        guard let tempurl = URL(string: urlStr) else {
            throw JsonFetcherError.invalidURL
        }

        var tempRequest = URLRequest(
            url: tempurl
        )
        
       
        
        //let token = String(decoding: utoken, as: UTF8.self)
      //  let btoken = getAuthToken(hrempid: hrEmpId)
      //  print(btoken)
        
      //  tempRequest.setValue(
       //     btoken,
       //     forHTTPHeaderField: "authorization"
       // )
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)
        
        
        // Parse the JSON data
        let result = try JSONDecoder().decode([ExcelentPhotos].self, from: data)
        return result
    }
    
    static func fetchPhotoAsync(urlStr: String) async throws -> UIImage {

        guard let tempurl = URL(string: urlStr) else {
            throw JsonFetcherError.invalidURL
        }

        let tempRequest = URLRequest(
            url: tempurl
        )
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)
        
        return UIImage(data: data)!
        // Parse the JSON data
        //let fbfResult = try JSONDecoder().decode([FBFSearch].self, from: data)
        //return fbfResult
    }
    
    static func postAuthCookieJson(hrEmpId: String) async throws -> HTTPCookie {
        
        
       
        var urlStr = "https://twapiweb.bulwarkapp.com/GetAuthCookie"
        
        //urlStr = "http://10.211.55.4:5095/GetAuthCookie"
        
        guard let tempurl = URL(string: urlStr) else {
            throw JsonFetcherError.invalidURL
        }

        var tempRequest = URLRequest(
            url: tempurl
        )
        var athtoken = getAuthToken(hrempid: hrEmpId)
        let ac = AuthCookie(HrEmpId: hrEmpId, RollingKey: athtoken)
        
        
        tempRequest.httpMethod = "POST"
        tempRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        tempRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let jsonData = try JSONEncoder().encode(ac)
        
        tempRequest.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)
        
        
        // Parse the JSON data
        let acresult: AuthCookieResult = try JSONDecoder().decode(AuthCookieResult.self, from: data)
        
        let cookie = HTTPCookie(properties: [
            .domain: ".bulwarkapp.com",
            .path: "/",
            .name: "_bulwarkappauth",
            .value: acresult.cookie,
            .expires: NSDate(timeIntervalSinceNow: 31556926)
        ])!
        
        
        
        return cookie
        
        
    }
    
    
    
    static func fetchRouteStopsAsync(rdate: String, hrEmpId: String) async throws -> [RouteStop] {

        
        
        let urlstr = "https://ipadapp.bulwarkapp.com/getRouteByHRempidAndDate.ashx?date=" + rdate + "&hr_emp_id=" + hrEmpId
        
        let tempurl = URL(string: urlstr)!
            
        

        var tempRequest = URLRequest(
            url: tempurl
        )
        
       
        
        //let token = String(decoding: utoken, as: UTF8.self)
        let btoken = getAuthToken(hrempid: hrEmpId)
        print(btoken)
        
        tempRequest.setValue(
            btoken,
            forHTTPHeaderField: "authorization"
        )
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)
        
        let sv = DataUtilities.saveRouteStopList(list: data)
        
        /*
        var (data, response) = try await URLSession.shared.data(for: tempRequest)
      
              guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                  //error getting data could be servewr related
                 
                  return DataUtilities.getRouteStopListFromFile()

                  
              }
        */
        
        // Parse the JSON data
        let rsResult = try JSONDecoder().decode([RouteStop].self, from: data)
        return rsResult
    }
    

    
    
    static func SendPostingResultsAsync(hrEmpId: String) async throws -> Bool{
      
        
        let fm = FileManager.default


        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("services")
            
            
            do {
                let items = try fm.contentsOfDirectory(atPath: fileURL.path)

                for item in items {
                    print("Found \(item)")
                    
                    if item.hasSuffix(".tw"){
                        
                        let fp = fileURL.appendingPathComponent(item)
                        
                        //if let fu =  URL(string: item) {
                            
                            do {
                                let urlStr = try String(contentsOf: fp, encoding: .utf8)
                                
                                
                                if urlStr.hasPrefix("https://"){
                                    
                                
                                    let ntu = urlStr.replacingOccurrences(of: "ipadapp.bulwarktechnician.com", with: "ipadapp.bulwarkapp.com")
                                
                                
                                    let tempurl = URL(string: ntu)!

                                var tempRequest = URLRequest(
                                    url: tempurl
                                )
                                
                               
                                
                                //let token = String(decoding: utoken, as: UTF8.self)
                                let btoken = getAuthToken(hrempid: hrEmpId)
                                print(btoken)
                                
                                tempRequest.setValue(
                                    btoken,
                                    forHTTPHeaderField: "authorization"
                                )
                                   
                                    
                                let (data, _) = try await URLSession.shared.data(for: tempRequest)
                                            
                                   
                                            
                                
                                
                                
                                // Parse the JSON data
                                    let resStr = String(decoding: data, as: UTF8.self)
                                
                                    let stl = resStr.lowercased()
                                    
                                    if stl.contains("success"){
                                        
                                        
                                        try fm.removeItem(atPath: fp.path)
                                        
                                        
                                    }else{
                                        //check how old the file is and remove if greater then 4 days
                                        
                                        let attr = try FileManager.default.attributesOfItem(atPath: fp.path)
                                        let savedate = attr[FileAttributeKey.creationDate] as? Date
                                        
                                        
                                        if let s = savedate {
                                            let d = Date()
                                            
                                            let ti = d.timeIntervalSince(s)
                                            
                                            let seconds = ti.rounded()
                                            let tthours =  seconds / 3600
                                            
                                            
                                            if tthours > 80 {
                                                //it has been more then 80 hours remove the file
                                                try fm.removeItem(atPath: fp.path)
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                    }
                                        
                                    
                                    
                                    
                                    
                                }else{
                                    //invalid url remove the file
                                    try fm.removeItem(atPath: fp.path)
                                    
                                }
                                
                                
                                
                                
                            }
                                catch {
                                print(error)
                            }
                            
                        //}else {
                        //    //invalid url conversion remove the file
                        //    try fm.removeItem(atPath: item)
                        //}
                        
                        
                        
                    }
                    
                    
                    
                }
            } catch {
                // failed to read directory – bad permissions, perhaps?
            }
            
        }
        
        
        return true
    }
    
    
    static func sendGpsDataToServer(hrEmpId: String) async -> Bool{
        if isSendingGps == false{
            do{
                isSendingGps = true
                let s = try await SendGPSAsync(hrEmpId: hrEmpId)
                isSendingGps = false
                return s
            }catch{
                isSendingGps = false
                return false
            }
        }else{
            return false
        }
        
    }
    
    private static func SendGPSAsync(hrEmpId: String) async throws -> Bool{
      
        
        let fm = FileManager.default


        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("gpsData")
            
            
            do {
                let items = try fm.contentsOfDirectory(atPath: fileURL.path)

                for item in items {
                    print("Found \(item)")
                    
                    if item.hasSuffix(".tw"){
                        
                        let fp = fileURL.appendingPathComponent(item)
                        
                        //if let fu =  URL(string: item) {
                            
                        do {
                            let jdata = try Data(contentsOf: fp, options: .mappedIfSafe)
                            
                            
                            
                            print(item)
                            
                            let decoder = JSONDecoder()
                            let mdl = try decoder.decode(GpsModel.self, from: jdata)
                            
                            let stl = try await postGps(gpsData: mdl)
                            
                            
                            
                            if stl == 1{
                                
                                
                                try fm.removeItem(atPath: fp.path)
                                
                                
                            }else{
                                //check how old the file is and remove if greater then 4 days
                                
                                let attr = try FileManager.default.attributesOfItem(atPath: fp.path)
                                let savedate = attr[FileAttributeKey.creationDate] as? Date
                                
                                
                                if let s = savedate {
                                    let d = Date()
                                    
                                    let ti = d.timeIntervalSince(s)
                                    
                                    let seconds = ti.rounded()
                                    let tthours =  seconds / 3600
                                    
                                    
                                    if tthours > 96 {
                                        //it has been more then 80 hours remove the file
                                        try fm.removeItem(atPath: fp.path)
                                    }
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                
                            }
                                
                                
                                
                            }catch {
                                print(error)
                                
                                let errstr:String = error.localizedDescription.lowercased()
                                print(errstr)
                                if errstr.contains("correct format"){
                                    try fm.removeItem(atPath: fp.path)
                                }
                                
                            }
                            
                        //}else {
                        //    //invalid url conversion remove the file
                        //    try fm.removeItem(atPath: item)
                        //}
                        
                        
                        
                    }
                    
                    
                    
                }
            } catch {
                // failed to read directory – bad permissions, perhaps?
            }
            
        }
        
        
        return true
    }
    
    static func postGps(gpsData: GpsModel) async throws ->Int{
        
        
        
            let url = "https://twubuntucore.bulwarkapp.com/api/SaveIpadGps"
        
            //let url = "http://10.211.55.4:5095/api/SaveIpadGps"
            
        let jd = GpsModel(hrempid: gpsData.hrempid, rollingKey: getAuthToken(hrempid: gpsData.hrempid), truck: gpsData.truck, office: gpsData.office, timeStamp: gpsData.timeStamp, lat: gpsData.lat, lon: gpsData.lon, course: gpsData.course, speed: gpsData.speed, distance: gpsData.distance, odometer: gpsData.odometer, odometerTimeStamp: gpsData.odometerTimeStamp)
        
            let jsonData = try JSONEncoder().encode(jd)
        let request = URLRequest(urlStr: url, hrempid: gpsData.hrempid, jsonData: jsonData)!
            
            let (data, res) = try await URLSession.shared.data(for: request)
        let httpResponse = res as! HTTPURLResponse
        print(httpResponse.statusCode)
        let str = String(decoding: data, as: UTF8.self)
        print(str)
            let result = try JSONDecoder().decode(GpsPostResult.self, from: data)
        return result.success
     
        
        
        
        
        
    }
    
    
    static func fetchDashStatsJson(hrEmpId: String) async throws -> DashStats {
        
        
       
        let urlStr = "https://twapiweb.bulwarkapp.com/GetIpadDashStats"
        
        //urlStr = "http://10.211.55.4:5095/GetAuthCookie"
        
        guard let tempurl = URL(string: urlStr) else {
            throw JsonFetcherError.invalidURL
        }

        var tempRequest = URLRequest(
            url: tempurl
        )
        let athtoken = getAuthToken(hrempid: hrEmpId)
        let ac = AuthCookie(HrEmpId: hrEmpId, RollingKey: athtoken)
        
        
        tempRequest.httpMethod = "POST"
        tempRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        tempRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let jsonData = try JSONEncoder().encode(ac)
        
        tempRequest.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)
        
        
        // Parse the JSON data
        let acresult: DashStats = try JSONDecoder().decode(DashStats.self, from: data)
        
      
        
        
        
        return acresult
        
        
    }
    
    static func fetchEmployeeHomeJson(hrEmpId: String) async throws -> SPHomeGps {
        
        
       
        let urlStr = "https://twapiweb.bulwarkapp.com/GetSPHomeGps"
        
        //urlStr = "http://10.211.55.4:5095/GetAuthCookie"
        
        guard let tempurl = URL(string: urlStr) else {
            throw JsonFetcherError.invalidURL
        }

        var tempRequest = URLRequest(
            url: tempurl
        )
        let athtoken = getAuthToken(hrempid: hrEmpId)
        let ac = AuthCookie(HrEmpId: hrEmpId, RollingKey: athtoken)
        
        
        tempRequest.httpMethod = "POST"
        tempRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        tempRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let jsonData = try JSONEncoder().encode(ac)
        
        tempRequest.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)

        _ = DataUtilities.saveJSONFile(list:data, filename: "employeeHome.json")
    
        // Parse the JSON data
        let acresult: SPHomeGps = try JSONDecoder().decode(SPHomeGps.self, from: data)

        return acresult
        
        
    }
    
    static func fetchProactiveRetentionJson(hrEmpId: String) async throws -> [ProactiveAccount] {
        
        
       
        let urlStr = "https://twapiweb.bulwarkapp.com/api/GetProactiveList"
        
        //urlStr = "http://10.211.55.4:5095/GetAuthCookie"
        
        guard let tempurl = URL(string: urlStr) else {
            throw JsonFetcherError.invalidURL
        }

        var tempRequest = URLRequest(
            url: tempurl
        )
        let athtoken = getAuthToken(hrempid: hrEmpId)
        let ac = AuthCookie(HrEmpId: hrEmpId, RollingKey: athtoken)
        
        
        tempRequest.httpMethod = "POST"
        tempRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        tempRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let jsonData = try JSONEncoder().encode(ac)
        
        tempRequest.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)

        
        
        // Parse the JSON data
        let acresult = try JSONDecoder().decode([ProactiveAccount].self, from: data)
        if  acresult.count > 0{
            
            
                _ = DataUtilities.saveJSONFile(list:data, filename: "proactiveList.json")
            
        }
        
        return acresult
        
        
    }
    
    static func fetchCancelsJson(hrEmpId: String) async throws -> [ProactiveAccount]{
        
        
        let urlStr = "https://twapiweb.bulwarkapp.com/api/GetReportJsonForRetentionLists"
        let athtoken = getAuthToken(hrempid: hrEmpId)
        let ac = ProactiveApiPost(HrEmpId: hrEmpId, RollingKey: athtoken, lat: 0, lon: 0, reportType: 1, searchString: "")
        
        return try await fetchProactiveWorkJson(urlStr: urlStr, proApiPost: ac, fname: "cancelsList.json")
        
    }
    static func fetchPoolJson(hrEmpId: String, lat:Double, lon:Double) async throws -> [ProactiveAccount]{
        
        
        let urlStr = "https://twapiweb.bulwarkapp.com/api/GetReportJsonForRetentionLists"
        let athtoken = getAuthToken(hrempid: hrEmpId)
        let ac = ProactiveApiPost(HrEmpId: hrEmpId, RollingKey: athtoken, lat: 0, lon: 0, reportType: 2, searchString: "")
        
        return try await fetchProactiveWorkJson(urlStr: urlStr, proApiPost: ac, fname:"poolList.json")
        
    }
    static func fetchAcctSearchJson(hrEmpId: String, searchStr: String) async throws -> [ProactiveAccount]{
        
        
        let urlStr = "https://twapiweb.bulwarkapp.com/api/GetReportJsonForRetentionLists"
        let athtoken = getAuthToken(hrempid: hrEmpId)
        let ac = ProactiveApiPost(HrEmpId: hrEmpId, RollingKey: athtoken, lat: 0, lon: 0, reportType: 3, searchString: searchStr)
        
        return try await fetchProactiveWorkJson(urlStr: urlStr, proApiPost: ac, fname:"acctSearch.json")
        
    }
    
    
    static func fetchProactiveWorkJson(urlStr: String, proApiPost: ProactiveApiPost, fname:String) async throws -> [ProactiveAccount] {
        
        
        //urlStr = "http://10.211.55.4:5095/GetAuthCookie"
        
        guard let tempurl = URL(string: urlStr) else {
            throw JsonFetcherError.invalidURL
        }

        var tempRequest = URLRequest(
            url: tempurl
        )
 
        tempRequest.httpMethod = "POST"
        tempRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        tempRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let jsonData = try JSONEncoder().encode(proApiPost)
        
        tempRequest.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)

        // Parse the JSON data
        let acresult = try JSONDecoder().decode([ProactiveAccount].self, from: data)

        if  acresult.count > 0{
            
            
                _ = DataUtilities.saveJSONFile(list:data, filename: fname)
            
        }
        
        
        
        return acresult
        
        
    }
    
    
    static func fetchIsTerritorySteward(hrEmpId: String) async throws -> isTerritorySteward {
        
        let urlStr = "https://twapiweb.bulwarkapp.com/api/GetISTerritorySteward"
        guard let tempurl = URL(string: urlStr) else {
            throw JsonFetcherError.invalidURL
        }
        var tempRequest = URLRequest(
            url: tempurl
        )
        let athtoken = getAuthToken(hrempid: hrEmpId)
        let ac = AuthCookie(HrEmpId: hrEmpId, RollingKey: athtoken)
        tempRequest.httpMethod = "POST"
        tempRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        tempRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(ac)
        tempRequest.httpBody = jsonData
        let (data, _) = try await URLSession.shared.data(for: tempRequest)
        // Parse the JSON data
        let acresult: isTerritorySteward = try JSONDecoder().decode(isTerritorySteward.self, from: data)
        return acresult
        
        
    }
    
    
    static func submitFastComm(hrempid: String, fctime: Date) async throws -> FastCommSubmitResult{
        let url = "https://twapiweb.bulwarkapp.com/api/SubmitFastComm"
        
        let athtoken = JsonFetcher.getAuthToken(hrempid: hrempid)
        var jd = FastCommPunch(HrEmpId: hrempid, RollingKey: getAuthToken(hrempid: hrempid), PunchTime: fctime.toString(format: .usDateTime24NoSec)!)
        let jsonData = try JSONEncoder().encode(jd)
        var request = URLRequest(urlStr: url, hrempid: hrempid, jsonData: jsonData)!
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(FastCommSubmitResult.self, from: data)
        return result
    }
    
    
    
    
}
