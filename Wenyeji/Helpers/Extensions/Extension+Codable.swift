//
//  File.swift
//  Wenyeji
//
//  Created by PAC on 2/9/18.
//  Copyright © 2018 PAC. All rights reserved.
//


import Foundation

extension Encodable {
    
    func asDicctionary() throws -> [String: Any] {
        
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
        
    }
    
    var dictionary: [String: Any]? {
        
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any]}
        
    }
    
}
