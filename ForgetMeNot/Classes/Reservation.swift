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
     *              Utility Functions
     *
     * ===================================================
     */
    /*func isUnique(reservation : MyReservation) -> Bool{
        var flag = true // Assume unique until same reservation is found
        
        for reservation in {
            if (){
        }
    }*/
    
    
    /* ===================================================
     *              "Set" Functions
     *  Modify a variable from outside of the class
     * ===================================================
     */
    
    
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
    
    
}
