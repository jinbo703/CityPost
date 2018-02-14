//
//  Profile.swift
//  Wenyeji
//
//  Created by PAC on 2/12/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

struct Profile: Encodable, Decodable {
    
    var userId: String?
    var fname: String?
    var lname: String?
    var birthday: String?
    var mobile: String?
    var email: String?
    var gender: String?
    var password: String?
    var profileImage: String?
}
