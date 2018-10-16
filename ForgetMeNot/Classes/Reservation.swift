//
//  Reservation.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 10/16/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation

struct ReservationConstant {
    static let resTimeHour = 0
    static let resTimeMin = 0
    static let resUUID = UUID().uuidString
}

class MyReservation : NSObject {
    
    fileprivate var resTimeHour : Int
    fileprivate var resTimeMin : Int
    fileprivate var resUUID : UUID
    
    
    init (hour: Int, min: Int, uuid: UUID){
        resTimeHour = hour
        resTimeMin = min
        resUUID = uuid
        
        super.init()
        
    }
    
    
}
