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
    
    // Local Variables
    var currReservationList : [MyReservation] = []
    var myCustomer : Users
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currReservationList = myCustomer.loadReservations() // Load all info on the user
        
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
        cell.companyLabelName?.text = currReservationList[indexPath.row].getCompName()
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
    }
}
