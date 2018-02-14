//
//  Town.swift
//  Wenyeji
//
//  Created by PAC on 2/11/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

struct Town: Decodable, Encodable {
    let townId: String?
    let townName: String?
    var members: String?
    let lat: String?
    let lon: String?
    var connected: String?
}
