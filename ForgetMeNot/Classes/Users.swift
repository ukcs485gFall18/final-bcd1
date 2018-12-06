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
    var userID : String?
    var email : String?
    var userType : String?
    var reservationList : [MyReservation]
    var prevReservationList : [MyReservation]
    var partyNames : [String]
    var profilePicure : String = ""
    var resDate : [String]
    
    init(email: String, userType: String) {
        self.userID = ""
        self.email = email
        self.userType = userType
        self.profilePicure = ""
        
        self.reservationList = []
        self.prevReservationList = []
        self.partyNames = []
        self.resDate = []
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
    // Add a party name to the user's list
    // Note: If you pass in a party name that is already recorded, the function will do nothing
    func addPartyNameList(newPartyName : String){
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
    
    func addReservation(newReservation : MyReservation){
        reservationList.append(newReservation)
    }
    
    // Move a reservation from the active reservations to the "old" list
    func updateToOldReservation(oldReservation : MyReservation){
        prevReservationList.append(oldReservation)
        removeReservationFromCurr(currListOfReservations: reservationList, reservationToRemove: oldReservation)
    }
    
    
    /*  ====================================================
     *  ====================================================
     *                      Get Functions
     *  ====================================================
     *  ====================================================*/
    
    
    /* ===================================================
     *              Load Reservations
     *  Return a list of reservations a user has
     * ===================================================
     */
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
    
    /* ===================================================
     *           Load Party Names of the user
     *             Return as a simple array
     * ===================================================
     */
    func loadPartyNames() -> [String]{
        
        var foundPartyNames : [String] = []
        
        getPartyNamesForUser (handler:{ (newPartyNames) in
            for newName in newPartyNames{
                foundPartyNames.append(newName)
            }
        })
        
        return foundPartyNames
    }
    
    /* ===================================================
     *              Get Party Names
     *  Get a list of the user's CURRENT party names (already found)
     * ===================================================
     */
    func getPartyNames() -> [String]{
        return partyNames
    }
    
    
    /* ===================================================
     *              Get Reservations
     *  Get a list of the user's CURRENT reservations (already found)
     * ===================================================
     */
    func getReservations() -> [MyReservation]{
        return reservationList
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*  ====================================================
     *  ====================================================
     *                      ASync Functions
     *  ====================================================
     *  ====================================================*/
    
    
    /* ===================================================
     *              Get Users Email and Type
     *  Get a list of users from the database
     *  Note: Only builds a user with email and userType
     * ===================================================
     */
    func getUsersData(_ users: [String], handler: @escaping (_ usersArray: [Users]) -> ()) {
        var usersArray = [Users]()
        
        // Create firebase reference and link to database
        let dataRef = Database.database().reference()
        
        dataRef.child("userList").observe(.value) { (datasnapshot) in
            guard let usersnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in usersnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                let userType = user.childSnapshot(forPath: "userType").value as! String
                
                let userObj = Users(email: email, userType: userType)
                usersArray.append(userObj)
            }
            handler(usersArray)
        }
    }
    
    /* ===================================================
     *              Get Users party List
     *  Get all the party names for a user
     * ===================================================
     */
    func getPartyNamesForUser(handler: @escaping (_ newPartyNameList: [String]) -> ()){
        var newPartyNameList : [String] = []
        
        if (userID == ""){
            print ("Error: userID empty in loadPartyNames()")
        }
        else{
            // Create firebase reference and link to database
            let dataRef = Database.database().reference()
            
            dataRef.child("userList/\(userID!)/partyNameList").observe(.value) { (datasnapshot) in
                guard let partynamesnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
                
                for eachPartyName in partynamesnapshot {
                    guard let newpartyName : String = eachPartyName.childSnapshot(forPath: "partyName").value as? String else{return}
                    newPartyNameList.append(newpartyName)
                    print("DEBUGGING: Added \(newpartyName) to (handler) partyNames")
                }
            }
        }
        handler(newPartyNameList)
    }
    
    /* ===================================================
     *              Get Parties with Reservations
     *  Method can be used in order to find all reservations in the system
     *
     *  Gets a list of parties from the database and returns all reservations for each party'
     *  Note: ASync method that fetches the database in the background thread
     * ===================================================
     */
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
