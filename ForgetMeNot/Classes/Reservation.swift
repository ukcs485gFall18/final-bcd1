//
//  Reservation.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 10/16/18.
//

import Foundation
import Firebase

class MyReservation : NSObject { // Create the reservation
    
    // Local Variables
    fileprivate var resDate : String    // (MM/DD/YYYY) Date
    fileprivate var resUUID : UUID      // UUID number of the reservation
                                        // UUID will be broadcasted
    fileprivate var resStatus : Bool    // Party Checkin Status
    fileprivate var resCompName: String //resturant Name
    fileprivate var resName : String    // Party Name
    fileprivate var resSize : Int       // Size
    
    init (date: String, uuid: UUID, CompName: String, name : String, size : Int){
        resDate = date
        resUUID = uuid
        resStatus = false
        resCompName = CompName
        resName = name
        resSize = size
        
        super.init()
    }
    
    
    /* ===================================================
     *              "Set" Functions
     *  Modify a variable from outside of the class
     * ===================================================
     */
    // Set the active reservations
    func setReservations(reservations : [MyReservation]){
        kreservationList = reservations
    }
    
    
    /* ===================================================
     *              "Get" Functions
     *  Returns private variables for use outside the function
     *  but prevents modification.
     * ===================================================
    */
    func getUUID() -> UUID {
        return resUUID
    }
    
    func getUUIDString() -> String {
        return resUUID.uuidString
    }
    func getDate() -> String {
        return resDate
    }
    
    func getPartyName() -> String {
        return resName
    }
    
    func getPartySize() -> Int {
        return resSize
    }
    
    func getCompName() -> String {
        return resCompName
    }
    
    func getCheckInStatus() -> Bool{
        return resStatus
    }
    // ===================================================
    
    /* ===================================================
                    Processing Functions
       =================================================== */
    
    // Gets a list of parties from the database
    func getPartiesWithReservations(_ userPartyName : String, handler: @escaping (_ reservationsArray: [MyReservation]) -> ()){
        let dataRef = Database.database().reference() // Firebase reference link
        var reservationsArray = [MyReservation]()
        var currPartyName = ""
        
        dataRef.child("reservation").observe(.value) { (datasnapshot) in
            guard let partySnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for currParty in partySnapshot {
                if (userPartyName == currParty.key){
                    currPartyName = currParty.key
                    guard let reservations = currParty.value as? [String:Any] else{
                        return
                    }
                    
                    // Each reservation referenced inside loop
                    print ("\(currPartyName)'s active reservations: ")
                    for reservation in reservations{
                        print(reservation)
                        let partyValues = reservation.value as! [String : Any]   // Dictionary containing each value pair as an element
                        
                        let currComp = reservation.key
                        let currDate = partyValues["partyDate"] as! String
                        let currPartySize = partyValues["partyDate"] as! Int
                        let currUUIDString = partyValues["partySize"] as! String
                        
                        // Convert UUIDString back to a normal UUID to be placed into reservation
                        let currUUID = UUID(uuidString: currUUIDString)
                        
                        let resObj = MyReservation(date: currDate, uuid: currUUID ?? UUID(), CompName: currComp, name: currPartyName, size: currPartySize)
                        
                        reservationsArray.append(resObj)
                    }
                }
            }
            handler(reservationsArray) // Returns an array of "MyReservation" objects`
        }
    }
    
    // Get the active reservations
    // Returns a list of reservations the user has
    func getReservations(userPartyName : String) -> [MyReservation]{
        var currReservations : [MyReservation] = []
        
        getPartiesWithReservations(userPartyName, handler: { (foundPartiesWithReservations) in
            for reservation in foundPartiesWithReservations{
                print (reservation)
                /*if (reservation.getPartyName() == userPartyName){
                 currReservations.append(reservation)
                 }*/
            }
            
        }
        )
        
        return currReservations
    }
}
