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
    let dataRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Collect user data for table
        myCustomer.userID = Auth.auth().currentUser!.uid
        
        // Load all parties to the user
        //myCustomer.partyNames = myCustomer.loadPartyNames()
        // Create firebase reference and link to database
        
        dataRef.child("userList/\(myCustomer.userID!)/partyNameList").observe(.value) { (datasnapshot) in
            guard let partynamesnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for eachPartyName in partynamesnapshot {
                guard let newpartyName : String = eachPartyName.childSnapshot(forPath: "partyName").value as? String else{return}
                self.myCustomer.partyNames.append(newpartyName)
                print("DEBUGGING: Added \(newpartyName) to (handler) partyNames")
            }
        }
        
        // Load all reservations on the user
        myCustomer.reservationList = myCustomer.loadReservations()
        
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
