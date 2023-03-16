//
//  stringFetcher.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 12/2/22.
//

import Foundation

@objc public class StringFetcher: NSObject{
    enum StringFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    
    @objc public static func fetchStringFromUrlAsync(urlStr: String) async throws -> String {
        
        guard let tempurl = URL(string: urlStr) else {
            throw StringFetcherError.invalidURL
        }
        
        let tempRequest = URLRequest(
            url: tempurl
        )
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)
        
        let str = String(decoding: data, as: UTF8.self)
       
        
        return str
               
        
    }
    
  @objc public static func fetchStringFromUrlAsync(urlStr: String, hrEmpId: String) async throws -> String {
        
        guard let tempurl = URL(string: urlStr) else {
            throw StringFetcherError.invalidURL
        }
        
        var tempRequest = URLRequest(
            url: tempurl
        )
        
        
        
        //let token = String(decoding: utoken, as: UTF8.self)
        let btoken = JsonFetcher.getAuthToken(hrempid: hrEmpId)
        print(btoken)
        
        tempRequest.setValue(
            btoken,
            forHTTPHeaderField: "authorization"
        )
        
        let (data, _) = try await URLSession.shared.data(for: tempRequest)
        
        let str = String(decoding: data, as: UTF8.self)
       
        
        return str
    }
    
    
    
    @objc public static func downloadProductListAsync(officeCode: String) async throws ->Bool{
        
        
        
        
        
        return true;
    }
    
    
}
