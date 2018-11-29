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
    var reservationList : [MyReservation]
    var prevReservationList : [MyReservation]
    var partyNames : [String]
    var profilePicure : String = ""
    
    init(email: String, userType: String) {
        self.email = email
        self.userType = userType
        self.profilePicure = ""
        
        self.reservationList = []
        self.prevReservationList = []
        self.partyNames = []
    }
    
    // Keep track of the party names that the user has used
    // Note: If you pass in a party name that is already recorded, the function will do nothing
    func updatePartyNameList(newPartyName : String){
        var foundFlag = false
        
        for partyName in kPartyNames{ // Check if the party name has been used by the user before
            if (partyName == newPartyName){
                foundFlag = true
            }
        }
        
        if (!foundFlag){ // Add to the list if unused
            kPartyNames.append(newPartyName)
        }
    }
}
