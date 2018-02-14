//
//  ServerUrls.swift
//  Wenyeji
//
//  Created by PAC on 2/10/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

class ServerUrls {
    
    static let baseUrl = "http://192.168.2.100/"
    
    static let profileImageBaseUrl = "http://192.168.2.100/uploads/user/"
    static let postImageBaseUrl = "http://192.168.2.100/uploads/post/"
    static let eventImageBaseUrl = "http://192.168.2.100/uploads/event/"
    
    static let loginUrl = ServerUrls.baseUrl + "user/checklogin"
    static let signupUrl = ServerUrls.baseUrl + "user/signup"
    static let getTowns = ServerUrls.baseUrl + "user/gettownlist"
    static let getNearbyTowns = ServerUrls.baseUrl + "user/getnearbytowns"
    static let setLocation = ServerUrls.baseUrl + "user/setlocation"
    static let getProfile = ServerUrls.baseUrl + "user/getprofile"
    static let updateProfile = ServerUrls.baseUrl + "user/updateProfile"
    static let addPost = ServerUrls.baseUrl + "post/addPost"
    static let getPosts = ServerUrls.baseUrl + "post/getPost"
    static let getMyPosts = ServerUrls.baseUrl + "post/getmyPost"
}
