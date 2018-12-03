//
//  CustomerViewController.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 11/28/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit


let resObj : MyReservation = MyReservation(date: "", uuid: UUID(), CompName: "", name: "", size: 0)
var currReservationList : [MyReservation] = []

class CustomerViewController : UIViewController /*UITableViewDataSource, UITableViewDelegate*/{
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var CustomerReservations: UITableView!


  /*  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        switch(segmentedControl.selectedSegmentIndex){
        case 0:
            returnValue = currReservationList.count
        case 1:
            returnValue = currReservationList.count
        
        default:
            break
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resCell = tableView.dequeueReusableCell(withIdentifier: "resCell", for: indexPath)
        switch(segmentedControl.selectedSegmentIndex){
        case 0:
            resCell.textLabel!.text = "this won't work"
        case 1:
            resCell.textLabel!.text = "whyyyyyy"
        default:
            break
        }
        return resCell
    }*/
    
    
   @IBAction func refreshButton(_ sender: Any) {
        // Local Variables

        var counter = 0
        
        //Spin Animation
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
    @IBAction func indexChanged(_ sender: AnyObject) {
        CustomerReservations.reloadData()
    }
}
