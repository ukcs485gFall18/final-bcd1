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
    fileprivate var resHour : Int       // The hour of the reservation
    fileprivate var resMin : Int        // The minnute of the reservation
    fileprivate var resUUID : UUID      // The UUID number of the reservation
                                        // UUID will be broadcasted
    fileprivate var resStatus : Bool    // Will contain the current status of the check-in 
    fileprivate var resName : String    // The name of the party
    //Need a day, month variable
    init (name: String, hour: Int, min: Int, uuid: UUID){
        resName = name
        resHour = hour
        resMin = min
        resUUID = uuid
        resStatus = false
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
