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
    
    //Refrence: https://www.youtube.com/watch?v=m_0_XQEfrGQ
    let backgroundImageView = UIImageView()
    
    // Local Variables
    var myCustomer : Users = Users(email: "", userType: "")
    let dataRef = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()

        customerReservationTableView.dataSource = self
        customerReservationTableView.delegate = self
        
        let group = DispatchGroup()
        
        // Collect user data for table
        myCustomer.userID = Auth.auth().currentUser!.uid
        
        // Load all parties to the user
        //myCustomer.getPartyNamesForUser {}
        group.enter()
        dataRef.child("userList/\(myCustomer.userID!)/partyNameList").observe(.value) { (datasnapshot) in
            guard let partynamesnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for eachPartyName in partynamesnapshot {
                guard let newpartyName : String = eachPartyName.value as? String else{return}
                self.myCustomer.partyNames.append(newpartyName)
            }
            
            group.leave()
        }
        
        // Notify main thread of completion
        group.notify(queue: .main){
            print ("Finished Loading party names")
        }
        
        // Load all reservations on the user
        //myCustomer.getReservationsForParties {}
        group.enter()
        dataRef.child("reservation").observe(.value) { (datasnapshot) in
            guard let partySnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for partyName in self.myCustomer.partyNames{
                for currParty in partySnapshot {
                    if (partyName == currParty.key){
                        // Local Variables
                        guard let currPartyName = currParty.key as? String else {return}
                        guard let reservations = currParty.value as? [String:Any] else {return}
                        
                        // Each reservation referenced inside loop
                        for reservation in reservations{
                            // Store variables as a dictionary
                            let partyValues = reservation.value as! [String : Any]   // Dictionary containing each value pair of res
                            
                            // Collect variables from database
                            let currComp = reservation.key
                            let currDate = partyValues["partyDate"] as! String
                            let currPartySize = partyValues["partySize"] as! Int
                            let currUUIDString = partyValues["partyUUID"] as! String
                            
                            // Convert UUIDString back to a normal UUID to be placed into reservation
                            let currUUID = UUID(uuidString: currUUIDString)
                            
                            // Compile all info into reservation object and add to array
                            let resObj = MyReservation(date: currDate, uuid: currUUID ?? UUID(), CompName: currComp, name: currPartyName, size: currPartySize)
                            self.myCustomer.reservationList.append(resObj)
                        }
                    }
                }
            }
            group.leave()
        }
        
        // Notify main thread of completion
        group.notify(queue: .main){
            print ("Finished Loading reservations")
            
            self.customerReservationTableView.reloadData()
        }
    }
    
    
    /*  =========================
     *      Table Properties
     *  ========================= */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(myCustomer.getNumOfUserReservations() == 0){
            return 0
        }
        else{
            return myCustomer.getNumOfUserReservations()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = customerReservationTableView.dequeueReusableCell(withIdentifier: "reservationReusableCell", for: indexPath) as! ReservationsCustomerTableViewCell
        
        // Modify Cell attributes
        //cell.companyLabelName!.text = myCustomer.reservationList[indexPath.row].getCompName()
        //print ("-DEBUG- (Reservation) for: " + myCustomer.reservationList[indexPath.row].getCompName())
        
        //return cell
        
        
        let cell = customerReservationTableView.dequeueReusableCell(withIdentifier: "reservationReusableCell") as! ReservationsCustomerTableViewCell
        
        if(myCustomer.getNumOfUserReservations() == 0){
            return cell
        }
        else{
            cell.companyLabelName?.text = myCustomer.getUserResCompName(pos: indexPath.item)
            cell.dateLabel?.text = myCustomer.getUserResDate(pos: indexPath.item)
            cell.partyLabelName?.text = myCustomer.getUserResName(pos: indexPath.item)
            cell.logoSlot.image = UIImage(named: "Coming_Soon")
            
            if myCustomer.getUserResStatus(pos: indexPath.item) == false{
                cell.statusLabel?.text = "❌"
            }
            if myCustomer.getUserResStatus(pos: indexPath.item) == true{
                cell.statusLabel?.text = "✅"
            }
            else{
                cell.statusLabel?.text = "Error"
            }
            return cell
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
    }
    
    //--------------------------------------------------------------------------
    //Refrence: https://www.youtube.com/watch?v=m_0_XQEfrGQ
    func setBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.image = UIImage(named: kBgWave)
        view.sendSubviewToBack(backgroundImageView)
    }
}
