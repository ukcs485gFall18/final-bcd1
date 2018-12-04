//
//  CustomerViewController.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 11/28/18.
//

import Foundation
import UIKit

class CustomerViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var customerReservationTableView: UITableView!
    var currReservationList : [MyReservation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Reload reservations when loading in for first time
        reloadCustomerReservations()
        
        customerReservationTableView.dataSource = self
        customerReservationTableView.delegate = self
    }
    
    
    /*  =========================
     *      Table Properties
     *  ========================= */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currReservationList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerReservationTableView.dequeueReusableCell(withIdentifier: "reservationReusableCell", for: indexPath) as! ReservationsCustomerTableViewCell
        
        // Modify Cell attributes
        cell.backgroundColor = UIColor.black
        cell.companyNameLabel?.text = currReservationList[indexPath.row].getCompName()
        
        return cell
    }
    
    
    /*  =========================
     *      View Functions
     *  ========================= */
    func reloadCustomerReservations(){
        
        // Local Variables
        var counter = 0 // Used to track the number of party names the user has
        let resObj = MyReservation(date: "", uuid: UUID(), CompName: "", name: "", size: 0)
        
        // Get a list of reservations for every party name of the user
        for _ in kPartyNames{
            resObj.getPartiesWithReservations(kPartyNames[counter], handler: { (foundParties) in
                
                // Parse each reservation per the found party name
                for reservation in foundParties{
                    //if (reservation.isUnique()){
                        currReservationList.append(reservation)
                    //}
                }
            })
            
            counter += 1
        }
    }
    
    /*  =========================
     *      View Controls
     *  ========================= */
    @IBAction func refreshButton(_ sender: Any) {
        print ("Reloading reservations")
        
        // Spin Animation
        (sender as! UIButton).spin()
        
        // Reload reservations
        reloadCustomerReservations()
    }
}
