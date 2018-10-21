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
    
    init (hour: Int, min: Int, uuid: UUID){
        resHour = hour
        resMin = min
        resUUID = uuid
        super.init()
    }
    
    // Modify a reservation
    func updateReservation(hour : Int, min : Int){
        resHour = hour
        resMin = min
    }
    
    
}
