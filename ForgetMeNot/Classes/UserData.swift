//
//  UserData.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 11/13/18.
//

import Foundation
import Firebase

/* =========================================
        Store User Settings here
   ========================================= */
var kreservationList : [MyReservation] = []
var kprevReservationList : [MyReservation] = []
var kPartyNames : [String] = ["BlakeGoesToChilis"]  // Always store current party name in the first element
var kprofilePicure : String = ""
var kuserEmail : String = ""                        // Stored on login
var kuserType : String = ""                         // Stored on login
var kuserID : String = ""                           // Stored on login
// =========================================
