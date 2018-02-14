//
//  Post.swift
//  Wenyeji
//
//  Created by PAC on 2/13/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

enum Category: String {
    case post = "POST"
    case event = "EVENT"
}

enum Scope: String {
    case country = "1"
    case town = "2"
    case nearbyTowns = "3"
    
}

struct Post: Decodable, Encodable {
    
    let userId: String?
    let username: String?
    let countryName: String?
    let townName: String?
    
    let postId: String?
    var category: String?
    var subject: String?
    var message: String?
    var postImages: [String]?
    var scope: String?
    var nearbyTowns: [String]?
    var timestamp: String?
    
    var eventDate: String?
    var eventTime: String?
    var eventLocation: String?
    
    var commentCount: String?
    var likeCount: String?
    var like: String?
}

struct GetPost: Decodable, Encodable {
    
    let userId: String?
    let userName: String?
    let userImage: String?
    let countryName: String?
    let townName: String?
    
    let postId: String?
    var category: String?
    var subject: String?
    var message: String?
    var postImages: String?
    var scope: String?
    var nearbyTowns: [String]?
    var timestamp: String?
    
    var eventDate: String?
    var eventTime: String?
    var eventLocation: String?
    
    var commentcount: String?
    var likecount: String?
    var mylike: String?
}
