//
//  APIService.swift
//  Wenyeji
//
//  Created by PAC on 2/12/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation
import SVProgressHUD

class APIService: NSObject {
    
    static let sharedInstance = APIService()
    
    private func dismissHud() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    func getPosts(getPostsRequest: GetPostsRequest, url: URL, completion: @escaping (GetPostsResponse) -> ()) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        do {
            let jsonBody = try JSONEncoder().encode(getPostsRequest)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        SVProgressHUD.show()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.dismissHud()
            
            if let error = error {
                print("Error for get post: ", error.localizedDescription)
                completion(GetPostsResponse(status: nil, posts: nil, error: Status.serverError.rawValue))
                return
            }
            guard let data = data else {
                completion(GetPostsResponse(status: nil, posts: nil, error: Status.dataErrror.rawValue))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            do {
                
                let response = try JSONDecoder().decode(GetPostsResponse.self, from: data)
                
                completion(response)
                
            } catch let jsonErr {
                print("Error serializing get post: ", jsonErr)
                completion(GetPostsResponse(status: nil, posts: nil, error: Status.parsingError.rawValue))
                return
            }
            
        }
        
        
        task.resume()
        
    }
    
    func getNearbyTowns(locationInfo: LocationInfo, completion: @escaping (GetNearbyTownsResponse) -> ()) {
        
        guard let urlStr = ServerUrls.getNearbyTowns.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlStr) else {
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        do {
            let jsonBody = try JSONEncoder().encode(locationInfo)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        SVProgressHUD.show()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.dismissHud()
            
            if let error = error {
                print("Error for update profile: ", error.localizedDescription)
                completion(GetNearbyTownsResponse(status: nil, nearbyTowns: nil, error: Status.serverError.rawValue))
                return
            }
            guard let data = data else {
                completion(GetNearbyTownsResponse(status: nil, nearbyTowns: nil, error: Status.dataErrror.rawValue))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            do {
                
                let response = try JSONDecoder().decode(GetNearbyTownsResponse.self, from: data)
                
                completion(response)
                
            } catch let jsonErr {
                print("Error serializing update profile: ", jsonErr)
                completion(GetNearbyTownsResponse(status: nil, nearbyTowns: nil, error: Status.parsingError.rawValue))
                return
            }
            
        }
        
        
        task.resume()
        
    }
    
    func addPost(createPostRequest: CreatePostRequest, completion: @escaping (GeneralResponse) -> ()) {
        
        
        guard let urlStr = ServerUrls.addPost.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlStr) else {
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        do {
            let jsonBody = try JSONEncoder().encode(createPostRequest)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        SVProgressHUD.show()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.dismissHud()
            
            if let error = error {
                print("Error for create post: ", error.localizedDescription)
                completion(GeneralResponse(status: nil, error: Status.serverError.rawValue))
                return
            }
            guard let data = data else {
                completion(GeneralResponse(status: nil, error: Status.dataErrror.rawValue))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            do {
                
                let response = try JSONDecoder().decode(GeneralResponse.self, from: data)
                
                completion(response)
                
            } catch let jsonErr {
                print("Error serializing create post: ", jsonErr)
                completion(GeneralResponse(status: nil, error: Status.parsingError.rawValue))
                return
            }
            
        }
        
        
        task.resume()
    }
    
    func updateProfile(user: UpdateUser, completion: @escaping (GeneralResponse) -> ()) {
        guard let urlStr = ServerUrls.updateProfile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlStr) else {
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        do {
            let jsonBody = try JSONEncoder().encode(user)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        SVProgressHUD.show()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.dismissHud()
            
            if let error = error {
                print("Error for update profile: ", error.localizedDescription)
                completion(GeneralResponse(status: nil, error: Status.serverError.rawValue))
                return
            }
            guard let data = data else {
                completion(GeneralResponse(status: nil, error: Status.dataErrror.rawValue))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            do {
                
                let response = try JSONDecoder().decode(GeneralResponse.self, from: data)
                
                completion(response)
                
            } catch let jsonErr {
                print("Error serializing update profile: ", jsonErr)
                completion(GeneralResponse(status: nil, error: Status.parsingError.rawValue))
                return
            }
            
        }
        
        
        task.resume()
    }
    
    func fetchProfile(user: User, completion: @escaping (GetProfileResponse) -> ()) {
        
        guard let urlStr = ServerUrls.getProfile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlStr) else {
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        do {
            let jsonBody = try JSONEncoder().encode(user)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        SVProgressHUD.show()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.dismissHud()
            
            if let error = error {
                print("Error for get profile: ", error.localizedDescription)
                completion(GetProfileResponse(status: nil, userInfo: nil, error: Status.serverError.rawValue))
                return
            }
            guard let data = data else {
                completion(GetProfileResponse(status: nil, userInfo: nil, error: Status.dataErrror.rawValue))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            do {
                
                let response = try JSONDecoder().decode(GetProfileResponse.self, from: data)
                
                completion(response)
                
            } catch let jsonErr {
                print("Error serializing get profile error: ", jsonErr)
                completion(GetProfileResponse(status: nil, userInfo: nil, error: Status.parsingError.rawValue))
                return
            }
            
        }
        
        task.resume()
    }
    
    func handleRequestLocationAfterSignup(locationInfo: LocationInfo, completion: @escaping (GeneralResponse) -> ()) {
        
        guard let urlStr = ServerUrls.setLocation.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlStr) else {
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        do {
            let jsonBody = try JSONEncoder().encode(locationInfo)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        SVProgressHUD.show()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.dismissHud()
            
            if let error = error {
                print("Error for request location: ", error.localizedDescription)
                completion(GeneralResponse(status: nil, error: Status.serverError.rawValue))
                return
            }
            guard let data = data else {
                completion(GeneralResponse(status: nil, error: Status.dataErrror.rawValue))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            do {
                
                let response = try JSONDecoder().decode(GeneralResponse.self, from: data)
                
                completion(response)
                
            } catch let jsonErr {
                print("Error serializing request location error: ", jsonErr)
                completion(GeneralResponse(status: nil, error: Status.parsingError.rawValue))
                return
            }
            
        }
        
        
        task.resume()
    }
    
    func fetchTownsInCountry(_ country: Country, completion: @escaping (GetTownsResponse) -> ()) {
        
        guard let urlStr = ServerUrls.getTowns.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlStr) else {
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        do {
            let jsonBody = try JSONEncoder().encode(country)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        SVProgressHUD.show()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.dismissHud()
            
            if let error = error {
                print("Error for fetch towns: ", error.localizedDescription)
                completion(GetTownsResponse(status: nil, country: nil, towns: nil, error: Status.serverError.rawValue))
                return
            }
            guard let data = data else {
                completion(GetTownsResponse(status: nil, country: nil, towns: nil, error: Status.dataErrror.rawValue))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            do {
                
                let response = try JSONDecoder().decode(GetTownsResponse.self, from: data)
                
                completion(response)
                
            } catch let jsonErr {
                print("Error serializing fetch towns error: ", jsonErr)
                completion(GetTownsResponse(status: nil, country: nil, towns: nil, error: Status.parsingError.rawValue))
                return
            }
            
        }
        
        
        task.resume()
    }
    
    func handleSignup(user: Profile, completion: @escaping (SignUpResponse) -> ()) {
        guard let urlStr = ServerUrls.signupUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlStr) else {
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        do {
            let jsonBody = try JSONEncoder().encode(user)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        SVProgressHUD.show()
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.dismissHud()
            
            if let error = error {
                print("Error for sign up: ", error.localizedDescription)
                completion(SignUpResponse(status: nil, userId: nil, message: nil, error: Status.serverError.rawValue))
                return
            }
            guard let data = data else {
                completion(SignUpResponse(status: nil, userId: nil, message: nil, error: Status.dataErrror.rawValue))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            do {
                
                let response = try JSONDecoder().decode(SignUpResponse.self, from: data)
                
                completion(response)
                
            } catch let jsonErr {
                print("Error serializing sign error: ", jsonErr)
                completion(SignUpResponse(status: nil, userId: nil, message: nil, error: Status.parsingError.rawValue))
                return
            }
            
        }
        
        task.resume()
    }
    
    func hadleLogin(user: Profile, completion: @escaping (LoginResponse) -> ()) {
        
        guard let urlStr = ServerUrls.loginUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlStr) else {
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        do {
            let jsonBody = try JSONEncoder().encode(user)
            request.httpBody = jsonBody
        } catch let jsonError {
            print("Error serializing ", jsonError)
        }
        
        SVProgressHUD.show()
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.dismissHud()
            
            if let error = error {
                print("Error for Login: ", error.localizedDescription)
                completion(LoginResponse(status: nil, userInfo: nil, message: nil, error: Status.serverError.rawValue))
                return
            }
            guard let data = data else {
                completion(LoginResponse(status: nil, userInfo: nil, message: nil, error: Status.dataErrror.rawValue))
                return
            }
            
            let jsonString = String(data: data, encoding: .utf8)
            print("json: ", jsonString ?? "")
            
            do {
                
                let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                completion(response)
                
            } catch let jsonErr {
                print("Error serializing Login error: ", jsonErr)
                completion(LoginResponse(status: nil, userInfo: nil, message: nil, error: Status.parsingError.rawValue))
                return
            }
            
        }
        
        
        task.resume()
    }
}
