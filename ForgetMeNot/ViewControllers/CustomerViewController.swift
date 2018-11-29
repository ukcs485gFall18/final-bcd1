//
//  CustomerViewController.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 11/28/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit

class CustomerViewController : UIViewController{
    
    @IBAction func refreshButton(_ sender: Any) {
        let resObj : MyReservation = MyReservation(date: "", uuid: UUID(), CompName: "", name: "", size: 1)
        
        // Set the party name
        resObj.getPartiesWithReservations(kPartyNames[0], handler: { (foundUsers) in
            for person in foundUsers{
                print(person)
            }
        })
        
        // Get a list of reservations
        //reservation.getReservations(userPartyName: partyName)
        
        // Reload reservations into cells
    }
}
