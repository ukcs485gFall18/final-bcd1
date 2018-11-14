//
//  UserData.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 11/13/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import Firebase

class UserData : NSObject{
    
    // Create user content
    fileprivate var reservationList : [MyReservation]
    fileprivate var prevReservationList : [MyReservation]
    fileprivate var prevPartyNames : [String]
    fileprivate var profilePicure : String
    
    // Initialize user content
    override init() {
        self.reservationList = []
        self.prevReservationList = []
        self.prevPartyNames = []
        self.profilePicure = ""
        super.init()
    }
    
    func getPartiesWithReservations(_ userPartyName : String, handler: @escaping (_ reservationsArray: [MyReservation]) -> ()){
        let dataRef = Database.database().reference() // Firebase reference link
        var reservationsArray = [MyReservation]()
        
        dataRef.child("reservation").observe(.value) { (datasnapshot) in
            guard let partySnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for currParty in partySnapshot {
                
                let currDate = currParty.childSnapshot(forPath: "partyDate").value as! String
                let currUUIDString = currParty.childSnapshot(forPath: "partySize").value as! String
                let currComp = currParty.childSnapshot(forPath: "partyDate").value as! String
                let currPartyName = currParty.key
                let currSize = currParty.childSnapshot(forPath: "partyDate").value as! String
                
                // Convert UUIDString back to a normal UUID to be placed into reservation
                let currUUID = UUID(uuidString: currUUIDString)
                let randomUUID = UUID()
                
                let resObj = MyReservation(date: currDate, uuid: currUUID ?? randomUUID, CompName: currComp, name: currPartyName, size: Int(currSize) ?? 0)
                
                reservationsArray.append(resObj)
            }
            handler(reservationsArray) // Returns an array of "MyReservation" objects`
        }
    }
    
    /*// Get the active reservations
    func getReservations() -> [MyReservation]{
        var currReservations : [MyReservation] = []
        var userPartyName : String
        
        getUsersWithReservations(userPartyName, handler: { (foundPartiesWithReservations) in
            for reservation in foundPartiesWithReservations{
                if (reservation.getPartyName() == userPartyName){
                    currReservations.append(reservation)
                }
            }
            
            }
        )
        
        return currReservations
    }
     
    // Get the Expired reservations for the user
    func getPrevReservations() -> [MyReservation]{
        var prevReservations : [MyReservation] = []
 
        return prevReservations
    }*/
    
    // Check reservations are up to date, and update them if not
    func refreshCurrReservations(){
        
    }
    
    // Add a profile picture to the user's data
    func setProfilePic(link : String){
        profilePicure = link
    }
    
    // Keep track of the party names that the user has used
    func updatePartyNames(newPartyName : String){
        var foundFlag = false
        
        // Check if the party name has been used by the user before
        for partyName in prevPartyNames{
            if (partyName == newPartyName){
                foundFlag = true
            }
        }
        
        if (!foundFlag){ // Add to the list
            prevPartyNames.append(newPartyName)
        }
    }
}
