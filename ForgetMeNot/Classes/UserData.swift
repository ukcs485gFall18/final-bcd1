//
//  UserData.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 11/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import Firebase

/* =========================================
        Store User Settings here
   ========================================= */
var kreservationList : [MyReservation] = []
var kprevReservationList : [MyReservation] = []
var kPartyNames : [String] = []
var kprofilePicure : String = ""
var kuserEmail : String = ""                        // Stored on login
var kuserType : String = ""                         // Stored on login
var kuserID : String = ""                           // Stored on login
// =========================================


class UserData : NSObject{
    
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
    
    
    
    
    
    
    
    
    
    
    
    
    // Check reservations are up to date, and update them if not
    // FINISH
    func refreshCurrReservations(){
        for reservation in kreservationList{
            let resDate = reservation.getDate()
            var resYear = ""
            var resMonth = ""
            var resDay = ""
            
            // Parse Date into 3 variables for comparison
            var counter = 0
            for number in resDate{
                if (counter == 0 || counter == 1){ // Create month string
                    resMonth = resMonth + String(number)
                }
                else if (counter == 3 || counter == 4){// Create day string
                    resDay = resDay + String(number)
                }
                else if (counter == 6 || counter == 7 || counter == 8 || counter == 9){ // Create year string
                    resYear = resYear + String(number)
                }
                else if (counter == 2 || counter == 5){
                    // Skip the slashes
                }
                else{
                    print("Error in refreshCurrReservations() function")
                }
                
                counter = counter + 1
            }
            
        }
    }
    
    /*// Get the Expired reservations for the user
     func getPrevReservations() -> [MyReservation]{
     var prevReservations : [MyReservation] = []
     
     return prevReservations
     }*/
}
