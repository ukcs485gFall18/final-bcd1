//
//  Users.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 11/28/18.
//

import Foundation
import Firebase

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
    
    
    // Add a party name to the user's list
    // Note: If you pass in a party name that is already recorded, the function will do nothing
    func updatePartyNameList(newPartyName : String){
        var foundFlag = false
        
        for partyName in partyNames{ // Check if the party name has been used by the user before
            if (partyName == newPartyName){
                foundFlag = true
            }
        }
        
        if (!foundFlag){ // Add to the list if unused
            partyNames.append(newPartyName)
        }
    }
    
    // Remove a reservation from "reservationList"
    func removeReservationFromCurr(currListOfReservations : [MyReservation], reservationToRemove : MyReservation){
        var counter = 0
        for reservation in currListOfReservations{
            if (reservation.getUUID() == reservationToRemove.getUUID()){
                // If found, remove the reservation from the list
                reservationList.remove(at: counter)
                print ("Successfully removed \(reservation.getPartyName())'s reservation at \(reservation.getCompName()) for date \(reservation.getDate())")
            }
            counter += 1
        }
    }
    
    /*  ==========================
     *        Set Functions
     *  ==========================*/
    func addPartyName(newPartyName : String){
        partyNames.append(newPartyName)
    }
    
    func addReservation(newReservation : MyReservation){
        reservationList.append(newReservation)
    }
    
    // Move a reservation from the active reservations to the "old" list
    func updateToOldReservation(oldReservation : MyReservation){
        prevReservationList.append(oldReservation)
        removeReservationFromCurr(currListOfReservations: reservationList, reservationToRemove: oldReservation)
    }
    
    
    /*  ==========================
     *        Get Functions
     *  ==========================*/
    
    // Load all data for the user
    /*func loadUser(){
        
        /* Load in reservations  */
        var counter = 0
        for _ in reservationList{
            getPartiesWithReservations(reservationList[counter].getPartyName(), handler: { (foundParties) in
                
                // Parse each reservation per the found party name
                for reservation in foundParties{
                    //if (reservation.isUnique()){
                    self.reservationList.append(reservation)
                    //}
                }
            })
            
            counter += 1
        }
    }*/
    
    // Load reservations for the user
    func loadReservations() -> [MyReservation]{
            
        // Local Variables
        var counter = 0 // Used to track the number of party names the user has
        var currReservationList : [MyReservation] = []
        
        // Get a list of reservations for every party name of the user
        for _ in reservationList{
            getPartiesWithReservations(reservationList[counter].getPartyName(), handler: { (foundParties) in
                
                // Parse each reservation per the found party name
                for reservation in foundParties{
                    //if (reservation.isUnique()){
                    currReservationList.append(reservation)
                    //}
                }
            })
            
            counter += 1
        }
        
        return currReservationList
    }
    
    // Get partyNames
    func getPartyNames() -> [String]{
        return partyNames
    }
    
    func getReservations() -> [MyReservation]{
        return reservationList
    }
    
    
    
    
    
    // Gets a list of parties from the database and returns all reservations for each party
    func getPartiesWithReservations(_ userPartyName : String, handler: @escaping (_ reservationsArray: [MyReservation]) -> ()){
        let dataRef = Database.database().reference() // Firebase reference link
        var reservationsArray = [MyReservation]()
        var currPartyName = ""
        
        dataRef.child("reservation").observe(.value) { (datasnapshot) in
            guard let partySnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for currParty in partySnapshot {
                if (userPartyName == currParty.key){
                    // Local Variables
                    currPartyName = currParty.key
                    guard let reservations = currParty.value as? [String:Any] else{
                        return
                    }
                    
                    // Each reservation referenced inside loop
                    for reservation in reservations{
                        // Store variables as a dictionary
                        let partyValues = reservation.value as! [String : Any]   // Dictionary containing each value pair of res
                        
                        // Collect variables from database
                        let currComp = reservation.key
                        let currDate = partyValues["partyDate"] as! String
                        let currPartySize = partyValues["partySize"] as! Int
                        let currUUIDString = partyValues["partyUUID"] as! String
                        
                        // Convert UUIDString back to a normal UUID to be placed into reservation
                        let currUUID = UUID(uuidString: currUUIDString)
                        
                        // Compile all info into reservation object and add to array
                        let resObj = MyReservation(date: currDate, uuid: currUUID ?? UUID(), CompName: currComp, name: currPartyName, size: currPartySize)
                        reservationsArray.append(resObj)
                    }
                }
            }
            handler(reservationsArray) // Returns an array of "MyReservation" objects`
        }
    }
    
    
    
    
}
