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
        // Local Variables
        let partyName : String
        let reservation : MyReservation
        
        // Set the party name
        getUsersData([kuserID], handler: { (foundUsers) in
            for person in foundUsers{
            }
        })
        
        // Get a list of reservations
        //reservation.getReservations(userPartyName: partyName)
        
        // Reload reservations into cells
    }
}
