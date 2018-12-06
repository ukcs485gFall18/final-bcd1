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
    var currReservationList : [MyReservation] = []
    let currDate = NSDate()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func indexValueChanged(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.setTitle("Upcoming", forSegmentAt: 0)
        segmentedControl.setTitle("Completed", forSegmentAt: 1)
        // Collect user data for table
        myCustomer.userID = Auth.auth().currentUser!.uid
        myCustomer.partyNames = myCustomer.loadPartyNames() // Load all parties to the user
        myCustomer.reservationList = myCustomer.loadReservations() // Load all reservations on the user
        myCustomer.prevReservationList = myCustomer.updateToOldReservation(oldReservation: myCustomer.reservationList)
        
        customerReservationTableView.dataSource = self
        customerReservationTableView.delegate = self
    }
    
    
    /*  =========================
     *      Table Properties
     *  ========================= */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0{
            return myCustomer.reservationList.count
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            return myCustomer.prevReservationList.count
        }
        return 0 //never hits this line of code
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerReservationTableView.dequeueReusableCell(withIdentifier: "reservationReusableCell", for: indexPath) as! ReservationsCustomerTableViewCell
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.companyLabelName!.text = myCustomer.reservationList[indexPath.row].getCompName()
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            
            cell.companyLabelName!.text = myCustomer.prevReservationList[indexPath.row].getCompName()
        }
        
        // Modify Cell attributes
        
        //print ("DEBUG: " + myCustomer.reservationList[indexPath.row].getCompName())
        
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
