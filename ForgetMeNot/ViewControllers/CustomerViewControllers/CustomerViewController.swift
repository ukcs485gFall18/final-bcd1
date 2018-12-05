//
//  CustomerViewController.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 11/28/18.
//

import Foundation
import UIKit
import Firebase

class CustomerViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var customerReservationTableView: UITableView!
    
    // Local Variables
    var myCustomer : Users = Users(email: "", userType: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Collect user data for table
        myCustomer.userID = Auth.auth().currentUser!.uid
        myCustomer.partyNames = myCustomer.loadPartyNames() // Load all parties to the user
        myCustomer.reservationList = myCustomer.loadReservations() // Load all reservations on the user
        
        customerReservationTableView.dataSource = self
        customerReservationTableView.delegate = self
    }
    
    
    /*  =========================
     *      Table Properties
     *  ========================= */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCustomer.reservationList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerReservationTableView.dequeueReusableCell(withIdentifier: "reservationReusableCell", for: indexPath) as! ReservationsCustomerTableViewCell
        
        // Modify Cell attributes
        cell.companyLabelName!.text = myCustomer.reservationList[indexPath.row].getCompName()
        print ("DEBUG: " + myCustomer.reservationList[indexPath.row].getCompName())
        
        return cell
    }
    
    /*  =========================
     *      View Controls
     *  ========================= */
    @IBAction func refreshButton(_ sender: Any) {
        print ("Reloading reservations")
        
        // Spin Animation
        (sender as! UIButton).spin()
        
        // Reload reservations
        myCustomer.reservationList = myCustomer.loadReservations()
        customerReservationTableView.reloadData()
    }
}
