//
//  XOREncrypt.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 11/9/22.
//

import Foundation

extension Character {
    func utf8() -> UInt8 {
        let utf8 = String(self).utf8
        return utf8[utf8.startIndex]
    }
}

func xorEncryption(clearText: String, setKey: String) -> [UInt8] {
    if clearText.isEmpty { return [UInt8]() }
    
    var encrypted = [UInt8]()
    let text = [UInt8](clearText.utf8)
    let key = [UInt8](setKey.utf8)
    let length = key.count
    
    // encrypt bytes
    for t in text.enumerated() {
        encrypted.append(t.element ^ key[t.offset % length])
    }
    
    return encrypted
}

func xorDecryption(cypherText: [UInt8], setKey: String) -> String {
    if cypherText.count == 0 { return "" }
    
    var decrypted = [UInt8]()
    let cypher = cypherText
    let key = [UInt8](setKey.utf8)
    let length = key.count
    
    // decrypt bytes
    for c in cypher.enumerated() {
        decrypted.append(c.element ^ key[c.offset % length])
    }
    
    return String(bytes: decrypted, encoding: .utf8)!
}
