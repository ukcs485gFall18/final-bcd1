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
    fileprivate var resHour : Int       // Start Hour
    fileprivate var resMin : Int        // Start Minnute
    fileprivate var resEndHour : Int    // End Hour
    fileprivate var resEndMin : Int     // End Minnute
    fileprivate var resUUID : UUID      // UUID number of the reservation
                                        // UUID will be broadcasted
    fileprivate var resStatus : Bool    // Party Checkin Status
    
    fileprivate var resName : String    // Party Name
    fileprivate var resSize : Int       // Size
    //Need a day, month variable
    
    init (date: String, hour: Int, min: Int, endHour: Int, endMin: Int, uuid: UUID, name : String, size : Int){
        resDate = date
        resHour = hour
        resMin = min
        resEndHour = endHour
        resEndMin = endMin
        resUUID = uuid
        resStatus = false
        resName = name
        resSize = size
        super.init()
    }

    // Modify a reservation time
    func updateResTime(hour : Int, min : Int){
        resHour = hour
        resMin = min
    }
    
    // MOdify 
    
    // Check if the reservation has been checked in
    func checkStatus () -> Bool {
        if (resStatus == true){
            return true
        }
        else{
            return false
        }
    }
}
