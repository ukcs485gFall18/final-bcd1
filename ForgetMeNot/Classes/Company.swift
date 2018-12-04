//
//  CompData.swift
//
//  Created by David Mercado on 11/29/18.
//

import Foundation
import Firebase

// Created Company model for retrieving data (Host)
class Company/*: NSObject*/{
    
    //Local Variables
    var companyName : String                        //Host's name
    var companyID : String                          //Host's ID
    var reservationList : [MyReservation]           //Host's list of Current Reservations
    var prevReservationList : [MyReservation]       //Host's list of Past Reservations
    //var partyNames : [String]                       //Host's list of Party names
    
    init (cName: String, ID: String){
        companyName = cName
        companyID = ID
        reservationList = []
        prevReservationList = []
        //self.partyNames = []
        //super.init()
    }
    
    /* ===================================================
     *              "Get" Functions
     *  Returns private variables for use outside the function
     *  but prevents modification.
     * ===================================================
     */
    //Company getters
    func getName() -> String {
        return companyName
    }
    func getID() -> String {
        return companyID
    }
    
    //Reservation getters
    func getReservationDate(customerRes: MyReservation) -> String {
        return customerRes.getDate()
    }
    func getReservationUUID(customerRes: MyReservation) -> UUID {
        return customerRes.getUUID()
    }
    func getReservationStatus(customerRes: MyReservation) -> Bool {
        return customerRes.getCheckInStatus()
    }
    func getReservationName(customerRes: MyReservation) -> String {
        return customerRes.getPartyName()
    }
    func getReservationName(customerRes: MyReservation) -> Int {
        return customerRes.getPartySize()
    }
    func printAll(){
        for res in reservationList{
            print(res)
        }
    }
    
    /* ===================================================
     *              "Set" Functions
     *  Modify a variable from outside of the class
     * ===================================================
     */
    
    func appendReservation(customerRes: MyReservation){
        reservationList.append(customerRes)
        sortReservation()
    }
    func removeReservation(customerRes: MyReservation){
        let pos = searchReservation(date: customerRes.getDate(), name: customerRes.getPartyName())
        reservationList.remove(at: pos)
    }
    func searchReservation(date: String, name: String) -> Int{
        //search for reservation
        return 0
    }
    func sortReservation(){
        //sort reservations by date time
    }
    
    /*====================================================
    *               FireBase Functions
    *       populate the data for the company
    ====================================================*/
    
    func populateSelf() {
        let dataRef = Database.database().reference()

        
        dataRef.child("companyList").child(companyName).observe(.value) { (datasnapshot) in
            guard let partySnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            print("SnapShot: \(partySnapshot)")                                     //DEBUGGING PURPOSES
            
            //iterate through the Company's reservation table
            for currParty in partySnapshot{
                print("currParty: \(currParty.key)")
                guard let reservations = currParty.value as? [String:Any] else{
                    return
                }
                print("reservations: \(reservations)")                              //DEBUGGING PURPOSES
                // Each reservation referenced inside loop
                for reservation in reservations{
                    // Store variables as a dictionary
                    print("reservation: \(reservation)")                            //DEBUGGING PURPOSES
                    #warning("FIX ME!!!")
                    /* let partyValues = reservation.value as! [String:Any] //else{
                     //return
                     //}   // Dictionary containing each value pair of res
                     
                     // Collect variables from database
                     let currResUUID_Str = reservation.key
                     let currResDate = partyValues["partyDate"] as! String
                     let currResName = partyValues["partyName"] as! String
                     let currResSize = partyValues["partySize"] as! Int
                     
                     // Convert UUIDString back to a normal UUID to be placed into reservation
                     let currResUUID = UUID(uuidString: currResUUID_Str)!
                     
                     print("UUID_Str: \(currResUUID_Str)")
                     print("currResDate: \(currResDate)")
                     print("currResName: \(currResName)")
                     print("currResSize: \(currResSize)")
                     
                     //Convert data into a MyReservation NSObject
                     let currRes = MyReservation(date: currResDate, uuid: currResUUID, CompName: Host.getName(), name: currResName, size: currResSize)
                     
                     //Add the reservation to the Company's list
                     Host.appendReservation(customerRes: currRes)*/
                }
            }
        }
    }
}
