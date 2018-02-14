//
//  Extension+Dictionary.swift
//  ReaLyfe
//
//  Created by John Nik on 11/27/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation

extension Dictionary {
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

extension Dictionary {
    
    func toNSAttributedStringKeys() -> [NSAttributedStringKey: Any] {
        
        var atts = [NSAttributedStringKey: Any]()
        
        for key in keys {
            
            if let keyString = key as? String {
                atts[NSAttributedStringKey(keyString)] = self[key]
            }
            
        }
        
        return atts
    }
    
}
