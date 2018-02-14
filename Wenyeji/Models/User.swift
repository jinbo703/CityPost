//
//  User.swift
//  Wenyeji
//
//  Created by PAC on 2/10/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

struct User: Decodable, Encodable {
    
    var userId: String?
    var profile: Profile?
    var country: Country?
    var town: Town?
    var nearbyTowns: [Town]?
}




