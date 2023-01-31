//
//  SaveFileUtilities.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/23/23.
//

import Foundation

struct DataUtilities {
    
    
    
    
    static func SavePostingResults(UrlToStave: String, Lat: String, Lon: String, Vin: String, Odometer: String, OdoLastUpdated:String, Rdate: String) -> Bool {
        
        let tt = UrlToStave.replacingOccurrences(of: " ", with: "%20") + "&date=" + Rdate.replacingOccurrences(of: " ", with: "%20")
        
        let t = tt + "&lat=" + Lat + "&lng=" + Lon + "&vin=" + Vin + "&odo=" + Odometer + "&ododate="
        
        let newUrl = t + (OdoLastUpdated.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "1/1/1900")
        
        
        
        return SaveUrlToPost(UrlToSave: newUrl)
        
    }
    
    
    static func SaveUrlToPost(UrlToSave: String) -> Bool {
        
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("services")
            //let fileName = uniqueFileName()
            
            if !FileManager.default.fileExists(atPath: fileURL.path) { //if does not exist
                    do {
                        try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: false, attributes: nil) //Create folder
                    } catch {
                        print(error)
                    }
                }

            let rtfile = fileURL.appendingPathComponent(uniqueFileName())
            
            
            
            //writing
             do {
             try UrlToSave.write(to: rtfile, atomically: true, encoding: .utf8)
                 return true
             }
             catch {
                 print(error)
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
            
        }// unique filelabel
    
    
    static func dateLabel(date: Date) ->String {
        
        var formatter: DateFormatter?
        var dateString: String?

        formatter = DateFormatter()
        formatter?.dateFormat = "MM-dd-yyy"

        dateString = formatter?.string(from: date)


        return dateString ?? "Route"
        
        
    } //route date label
    
    
    static func saveRouteStopList(list: Data) ->Bool{
        
        
        
        
        
        let filename = "current.json"
        //im not sure if theis will work check the logic 1-23-2023
      if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
          let pathWithFileName = documentDirectory.appendingPathComponent("routes")
          
          if !FileManager.default.fileExists(atPath: pathWithFileName.path) { //if does not exist
                  do {
                      try FileManager.default.createDirectory(atPath: pathWithFileName.path, withIntermediateDirectories: false, attributes: nil) //Create folder
                  } catch {
                  }
              }

          let rtfile = pathWithFileName.appendingPathComponent(filename)
          
          
          
            do {
                try list.write(to: rtfile)
            } catch {
                print(error)
                // handle error
                return false
            }
            return true
            
        }
        
        return true
    } //save route
    
    static func getRouteStopListFromFile() -> [RouteStop]{
        
        let rl : [RouteStop] = []
        
       if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
           let pathWithFileName = documentDirectory.appendingPathComponent("routes").appendingPathComponent("current.json")
            

            
            do{
                let data = try Data(contentsOf: pathWithFileName, options: .mappedIfSafe)
                let list = try JSONDecoder().decode([RouteStop].self, from: data)
                
                return list
            }catch {
                
                print(error)
                return rl
            }
            
       }else{
           
           return rl
       }
        
        
        
        
        
    }
    
    
    static func saveCurrentRouteDate(dateStr: String) -> Bool {
        
        let defaults = UserDefaults.standard
        
        defaults.set(dateStr, forKey: "rdate")
        
       
        
        return true
        
    }
    static func getCurrentRouteDateString() ->String {
        
        let defaults = UserDefaults.standard
        let defdate = Utilities.CurrentDateString()
        let rdate = defaults.object(forKey: "rdate") as? String ?? defdate
        
        return rdate
        
    }
    static func getCurrentRouteDate() -> Date {
        let rdateStr = getCurrentRouteDateString()
        
        let date = Utilities.toDateFromStandardString(dateStr: rdateStr)
        return date
        
        
    }
    
    static func getRouteTitle() -> String {
        
        let rdate = getCurrentRouteDate()
        
        
        var formatter: DateFormatter?
        var dateString: String?

        formatter = DateFormatter()
        formatter?.dateFormat = "MMM d"

        dateString = formatter?.string(from: rdate)
        let nd = (dateString ?? "") + " Route"

        return nd
        
        
    }
    
    
    static func saveJSONFile(list: Data, filename: String) ->Bool{
        
        
        //im not sure if theis will work check the logic 1-23-2023
      if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
          let pathWithFileName = documentDirectory.appendingPathComponent("jsonData")
          
          
          if !FileManager.default.fileExists(atPath: pathWithFileName.path) { //if does not exist
                  do {
                      try FileManager.default.createDirectory(atPath: pathWithFileName.path, withIntermediateDirectories: false, attributes: nil) //Create folder
                  } catch {
                      print(error)
                  }
              }

          let rtfile = pathWithFileName.appendingPathComponent(filename)
          

          
            do {
                try list.write(to: rtfile)
            } catch {
                // handle error
                return false
            }
            return true
            
        }
        
        return true
    } //save route
    
    
   static func getHomeGps(hrempid: String) async throws -> SPHomeGps{
        
        
        var sph = SPHomeGps(success: 0, lat: 0, lon: 0, address: "")
        
       
       

       
       
       
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent("jsonData").appendingPathComponent("employeeHome.json")
             
            
            if !FileManager.default.fileExists(atPath: pathWithFileName.path) { //if does not exist
                    do {
                        let list = try await JsonFetcher.fetchEmployeeHomeJson(hrEmpId: hrempid)
                        return list
                    } catch {
                        return sph
                    }
            }else{
                
                
                
                
                
                
                do{
                    let attr = try FileManager.default.attributesOfItem(atPath: pathWithFileName.path)
                    let savedate = attr[FileAttributeKey.modificationDate] as? Date
                    
                    
                    if let s = savedate {
                        let d = Date()
                        
                        let ti = d.timeIntervalSince(s)
                        
                        let seconds = ti.rounded()
                        let tthours =  seconds / 3600
                        
                        
                        if tthours > 4 {
                            
                            let list = try await JsonFetcher.fetchEmployeeHomeJson(hrEmpId: hrempid)
                            return list
                            
                        }else{
                            let data = try Data(contentsOf: pathWithFileName, options: .mappedIfSafe)
                            print(data.count)
                            do{
                                let list = try JSONDecoder().decode(SPHomeGps.self, from: data)
                                
                                if list.lat == 0 {
                                    let ll = try await JsonFetcher.fetchEmployeeHomeJson(hrEmpId: hrempid)
                                    return ll
                                }else{
                                    return list
                                }
                                
                            }catch{
                                
                                print(error)
                                throw error
                                
                            }
                            
                            
                            
                                
                            
                            
                            
                            
                        }
                        
                        
                        
                    }else{
                        let list = try await JsonFetcher.fetchEmployeeHomeJson(hrEmpId: hrempid)
                        return list
                    }
                    
                    
                    
                    
                }catch {
                    
                    
                    return sph
                }
            }
             
        }else{
            let list = try await JsonFetcher.fetchEmployeeHomeJson(hrEmpId: hrempid)
            return list
        }
         
        

        
        
        
    }
    
    
    static func getProactiveRetentionList(hrempid: String) async throws -> [ProactiveAccount]{
         
         
         let sph = [ProactiveAccount]()
         
        
        

        
        
        
         if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
             let pathWithFileName = documentDirectory.appendingPathComponent("jsonData").appendingPathComponent("proactiveList.json")
              
             
             if !FileManager.default.fileExists(atPath: pathWithFileName.path) { //if does not exist
                     do {
                         let list = try await JsonFetcher.fetchProactiveRetentionJson(hrEmpId: hrempid)
                         return list
                     } catch {
                         return sph
                     }
             }else{
                 
                 
                 
                 
                 
                 
                 do{
                     let attr = try FileManager.default.attributesOfItem(atPath: pathWithFileName.path)
                     let savedate = attr[FileAttributeKey.modificationDate] as? Date
                     
                     
                     if let s = savedate {
                         let d = Date()
                         
                         let ti = d.timeIntervalSince(s)
                         
                         let seconds = ti.rounded()
                         let tthours =  seconds / 3600
                         
                         
                         if tthours > 11 {
                             
                             let list = try await JsonFetcher.fetchProactiveRetentionJson(hrEmpId: hrempid)
                             return list
                             
                         }else{
                             let data = try Data(contentsOf: pathWithFileName, options: .mappedIfSafe)
                             print(data.count)
                             do{
                                 let list = try JSONDecoder().decode([ProactiveAccount].self, from: data)
                                 
                                 
                                     return list
                                 
                                 
                             }catch{
                                 
                                 print(error)
                                 throw error
                                 
                             }
                             
                             
                             
                                 
                             
                             
                             
                             
                         }
                         
                         
                         
                     }else{
                         let list = try await JsonFetcher.fetchProactiveRetentionJson(hrEmpId: hrempid)
                         return list
                     }
                     
                     
                     
                     
                 }catch {
                     
                     
                     return sph
                 }
             }
              
         }else{
             let list = try await JsonFetcher.fetchProactiveRetentionJson(hrEmpId: hrempid)
             return list
         }
          
         

         
         
         
     }
    
    
    
    } //end struct
    
    
    
    
    

