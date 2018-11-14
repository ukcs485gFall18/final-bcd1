//
//  Reservation.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 10/16/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation

class MyReservation : NSObject { // Create the reservation
    
    // Local Variables
    fileprivate var resDate : String    // (MM/DD/YYYY) Date
    //fileprivate var resHour : Int       // Start Hour
    //fileprivate var resMin : Int        // Start Minnute
    //fileprivate var resEndHour : Int    // End Hour
    //fileprivate var resEndMin : Int     // End Minnute
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
    
    // Check if the reservation has been checked in
    func checkStatus () -> Bool {
        if (resStatus == true){
            return true
        }
        else{
            return false
        }
    }
    
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
}
