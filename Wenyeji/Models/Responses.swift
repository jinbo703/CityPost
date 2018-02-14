//
//  Responses.swift
//  Wenyeji
//
//  Created by PAC on 2/12/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

struct GetPostsResponse: Decodable {
    let status: String?
    let posts: [GetPost]?
    
    let error: String?
}

struct GeneralResponse: Decodable {
    let status: String?
    
    let error: String?
}

struct GetNearbyTownsResponse: Decodable {
    
    let status: String?
    let nearbyTowns: [Town]?
    
    let error: String?
}

struct LoginResponse: Decodable {
    let status: String?
    let userInfo: User?
    let message: String?
    
    let error: String?
}

struct GetProfileResponse: Decodable {
    let status: String?
    let userInfo: User?
    
    let error: String?
}

struct SignUpResponse: Decodable, Encodable {
    
    let status: String?
    let userId: String?
    let message: String?
    
    let error: String?
}

struct GetTownsResponse: Decodable, Encodable {
    
    let status: String?
    let country: Country?
    let towns: [Town]?
    
    let error: String?
}
