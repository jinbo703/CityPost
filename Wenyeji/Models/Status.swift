//
//  Status.swift
//  Wenyeji
//
//  Created by PAC on 2/11/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import Foundation

enum Status: String {
    case success = "SUCCESS"
    case fail = "FAIL"
    case emailExist = "email exist"
    case notExistEmail = "Invalid Email or Password"
    case serverError = "server error"
    case parsingError = "json parsing error"
    case dataErrror = "data error"
}
