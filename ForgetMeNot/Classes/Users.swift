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
    
    init(email: String, userType: String) {
        self.userID = ""
        self.email = email
        self.userType = userType
        self.profilePicure = ""
        
        self.reservationList = []
        self.prevReservationList = []
        self.partyNames = []
    }
    
    // Remove a reservation from "reservationList"
    func removeReservationFromCurr(currListOfReservations : [MyReservation], reservationToRemove : MyReservation){
        var counter = 0
        for reservation in currListOfReservations{
            if (reservation.getUUID() == reservationToRemove.getUUID()){
                // If found, remove the reservation from the list
                reservationList.remove(at: counter)
            }
            counter += 1
        }
    }
    
    func emptyReservationList(){
        // Local Variables
        var counter = 0
        
        for _ in reservationList{
            reservationList.remove(at: counter)
            counter += 1
        }
        print ("Removed \(counter) active reservations")
    }
    
    func emptyPrevReservationList(){
        // Local Variables
        var counter = 0
        
        for _ in prevReservationList{
            prevReservationList.remove(at: counter)
            counter += 1
        }
        print ("Removed \(counter) previous reservations")
    }
    
    func emptyPartyNames(){
        // Local Variables
        var counter = 0

        for _ in partyNames{
            partyNames.remove(at: counter)
            counter += 1
        }
        print ("Removed \(counter) party Names")
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
    
    
    /* ===================================================
     *              Load Reservations
     *  Modify the user's reservationlist to contain reservations
     *  Completion handler added to do an action when complete
     * ===================================================
     */
    func loadReservations(completion: @escaping () -> ()){
        // Collect user data for table
        userID = Auth.auth().currentUser!.uid
        // Load all parties to the user
        loadParties {
            print ("Finished loading party names")
            
            // Load all reservations to the user
            self.loadUnsortedReservations {
                print ("Finished loading reservations")
                completion()
            }
        }
    }
    
    
    func loadParties(completion: @escaping () -> ()){
        let dataRef = Database.database().reference()
        dataRef.child("userList/\(userID!)/partyNameList").observe(.value) { (datasnapshot) in
            guard let partynamesnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            for eachPartyName in partynamesnapshot {
                guard let newpartyName : String = eachPartyName.value as? String else{return}
                self.addPartyNameList(newPartyName: newpartyName)
            }
            completion()
        }
    }
    
    func loadUnsortedReservations(completion: @escaping () -> ()){
        let dataRef = Database.database().reference()
        dataRef.child("reservation").observe(.value) { (datasnapshot) in
            guard let partySnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for partyName in self.partyNames{
                for currParty in partySnapshot {
                    if (partyName == currParty.key){
                        // Local Variables
                        guard let currPartyName = currParty.key as? String else {return}
                        guard let reservations = currParty.value as? [String:Any] else {return}
                        
                        // Each reservation referenced inside loop
                        for reservation in reservations{
                            // Store variables as a dictionary
                            let partyValues = reservation.value as! [String : Any]   // Dictionary containing each value pair of res
                            
                            // Collect variables from database
                            let currComp = reservation.key
                            let currDate = partyValues["partyDate"] as? String ?? "Error with Date"
                            let currPartySize = partyValues["partySize"] as? Int ?? 0
                            let currUUIDString = partyValues["partyUUID"] as? String ?? "Error UUID"
                            
                            // Convert UUIDString back to a normal UUID to be placed into reservation
                            let currUUID = UUID(uuidString: currUUIDString)
                            
                            // Compile all info into reservation object and add to array
                            let resObj = MyReservation(date: currDate, uuid: currUUID ?? UUID(), CompName: currComp, name: currPartyName, size: currPartySize)
                            self.reservationList.append(resObj)
                        }
                    }
                }
            }
            completion()
        }
    }
    
    
    /* ===================================================
     *              Load old Reservations
     *    Transfer all reservations with previous dates to prevReservations
     * ===================================================
     */
    func loadOldReservations(reservation : MyReservation){
        
        // Time variables to compare
        let time = getCurrentTime()!
        let resTime = reservation.getDate().toDate()
        
        // Move old reservations to the old reservation list
        let result = time.compare(resTime)
        if (result == .orderedDescending){ // Current time is later than reservation time
            prevReservationList.append(reservation)
            removeReservationFromCurr(currListOfReservations: reservationList, reservationToRemove: reservation)
        }
    }
    
    /*  ====================================================
     *  ====================================================
     *                      Get Functions
     *  ====================================================
     *  ====================================================*/
    func getNumOfUserReservations() -> Int{
        return reservationList.count
    }
    func getUserResCompName(pos: Int) -> String {
        return reservationList[pos].getCompName()
    }
    func getUserResName(pos: Int) -> String {
        return reservationList[pos].getPartyName()
    }
    func getUserResDate(pos: Int) -> String{
        return reservationList[pos].getDate()
    }
    func getUserResStatus(pos: Int) -> Bool{
        return reservationList[pos].getCheckInStatus()
    }
    func getNumOfUserPrevReservations() -> Int{
        return prevReservationList.count
    }
    func getUserPrevResCompName(pos: Int) -> String {
        return prevReservationList[pos].getCompName()
    }
    func getUserPrevResName(pos: Int) -> String {
        return prevReservationList[pos].getPartyName()
    }
    func getUserPrevResDate(pos: Int) -> String{
        return prevReservationList[pos].getDate()
    }
    func getUserPrevResStatus(pos: Int) -> Bool{
        return prevReservationList[pos].getCheckInStatus()
    }
    func getPartyNames() -> [String]{
        return partyNames
    }
    func getReservations() -> [MyReservation]{
        return reservationList
    }
    
    func getCurrentTime() -> Date?{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        let str = formatter.string(from: Date())
        let date = formatter.date(from: str)
        
        return date
    }
    
    func getNumPartyNames() -> Int{
        return partyNames.count
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
    func getPartyNamesForUser(handler: @escaping () -> ()){
        
        if (userID == ""){
            print ("Error: userID empty in getPartyNamesForUser()")
        }
        else{
            // Create firebase reference and link to database
            let dataRef = Database.database().reference()
            
            dataRef.child("userList/\(userID!)/partyNameList").observe(.value) { (datasnapshot) in
                guard let partynamesnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
                
                for eachPartyName in partynamesnapshot {
                    guard let newpartyName : String = eachPartyName.value as? String else{return}
                    self.partyNames.append(newpartyName)
                }
            }
        }
    }
    
    /* ===================================================
     *              Get Parties with Reservations
     *
     *  Gets a list of parties from the database and returns all reservations for each party'
     *  Note: ASync method that fetches the database in the background thread
     * ===================================================
     */
    func getReservationsForParties(handler: @escaping () -> ()){
        let dataRef = Database.database().reference() // Firebase reference link
        
        dataRef.child("reservation").observe(.value) { (datasnapshot) in
            guard let partySnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for partyName in self.partyNames{
                for currParty in partySnapshot {
                    if (partyName == currParty.key){
                        // Local Variables
                        guard let currPartyName = currParty.key as? String else {return}
                        guard let reservations = currParty.value as? [String:Any] else {return}
                        
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
                            self.reservationList.append(resObj)
                        }
                    }
                }
            }
            
        }
    }

}

extension String {
    func toDate(withFormat format: String = "MM/dd/yyyy HH:mm a") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look at your format")
        }
        return date
    }
}
