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
        let resObj : MyReservation = MyReservation(date: "", uuid: UUID(), CompName: "", name: "", size: 0)
        var currReservationList : [MyReservation] = []
        var counter = 0
        
        // Spin Animation
        (sender as! UIButton).spin() // Animate button when pressed
        
        // Get a list of reservations for every party name of the user
        for _ in kPartyNames{
            resObj.getPartiesWithReservations(kPartyNames[counter], handler: { (foundParties) in
                print ("Companies: ")
                
                for reservation in foundParties{
                    currReservationList.append(reservation)
                    print()
                    print("     " + reservation.getPartyName() + ": " + reservation.getCompName())
                }
            })
            
            counter += 1
        }

        // Reload reservations into cells
    }
}
