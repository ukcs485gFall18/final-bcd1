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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // Local Variables
    var currReservationList : [MyReservation] = []
    var prevReservationList : [MyReservation] = []
    var resDate = [""]
    var myCustomer : Users = Users(email: "", userType: "")
    @IBAction func segmentIndexChanged(_ sender: Any) {
        currReservationList = myCustomer.loadReservations()
        prevReservationList = myCustomer.loadReservations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currReservationList = myCustomer.loadReservations() // Load all info on the user
        prevReservationList = myCustomer.loadReservations()
        customerReservationTableView.dataSource = self
        customerReservationTableView.delegate = self
    }
    
    
    
    
    /*  =========================
     *      Table Properties
     *  ========================= */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var reservationCount = 0
        switch(segmentedControl.selectedSegmentIndex){
        case 0:
            reservationCount = currReservationList.count
        case 1:
            reservationCount = prevReservationList.count
        default:
            break
        }
        return reservationCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerReservationTableView.dequeueReusableCell(withIdentifier: "reservationReusableCell", for: indexPath) as! ReservationsCustomerTableViewCell
        switch(segmentedControl.selectedSegmentIndex){
        case 0:
            cell.textLabel!.text = currReservationList[indexPath.row].getCompName()
            resDate = [currReservationList[indexPath.row].getDate()]
            //loop through array of dates, compare to current date
            //call removeReservationFromCurr for dates behind current
            //append to prevReservationList
        case 1:
            cell.textLabel!.text = prevReservationList[indexPath.row].getCompName()
        default:
            cell.textLabel!.text = "No reservations to display!"
        }
        
        // Modify Cell attributes
        cell.backgroundColor = UIColor.black
        print ("DEBUG: " + currReservationList[indexPath.row].getCompName())
        
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
        currReservationList = myCustomer.loadReservations()
        
        
        // Begin Updates
        // for each element in currReservations, insert
        // End Updates
    }
}
