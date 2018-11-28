//
//  Users.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 11/28/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation

// Created User model for retrieving data
class Users {
    var email: String?
    var userType: String?
    
    init(email: String, userType: String) {
        self.email = email
        self.userType = userType
    }
}
