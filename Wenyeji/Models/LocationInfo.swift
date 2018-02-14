//
//  LocationInfo.swift
//  Wenyeji
//
//  Created by PAC on 2/11/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

struct LocationInfo: Encodable, Decodable {
    let userId: String?
    let countryId: String?
    let townId: String?
    let nearbyTowns: [String]?
}
