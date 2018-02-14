//
//  Requests.swift
//  Wenyeji
//
//  Created by PAC on 2/13/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

struct UpdateUser: Decodable, Encodable {
    
    var userId: String
    var profile: Profile
    var countryId: String
    var townId: String
    var nearbyTowns: [String]
}


struct CreatePostRequest: Encodable {
    
    let userId: String
    let action: String
    
    let post: Post
}

struct GetPostsRequest: Encodable, Decodable {
    
    let userId: String
    let page: String
    let timestamp: Double
}
