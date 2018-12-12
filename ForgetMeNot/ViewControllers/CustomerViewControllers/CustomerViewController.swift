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
    @IBOutlet weak var reservationSeg: UISegmentedControl!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var customerReservationTableView: UITableView!
    
    // Local Variables
    var myCustomer : Users = Users(email: "", userType: "")
    let backgroundImageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      /*==================
         UI Preferences
        ==================*/
        setBackground()
        setNavbar()

        customerReservationTableView.dataSource = self
        customerReservationTableView.delegate = self
        
      /*==================
         Load User Reservations
         ==================*/
        myCustomer.emptyReservationList()       // Make sure list is empty to avoid duplicates
        myCustomer.emptyPrevReservationList()
        myCustomer.emptyPartyNames()
        
        myCustomer.loadReservations(){
            for currReservation in self.myCustomer.reservationList{
                self.myCustomer.loadOldReservations(reservation: currReservation)
            }
            self.customerReservationTableView.reloadData()
        }
        
    }
    
    /*  =========================
     *      Table Properties
     *  ========================= */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (reservationSeg.selectedSegmentIndex == 0){  // Showing CURRENT reservations
            if(myCustomer.getNumOfUserReservations() == 0){
                return 0
            }
            else{
                return myCustomer.getNumOfUserReservations()
            }
        }
        else if (reservationSeg.selectedSegmentIndex == 1){ // Showing PREVIOUS reservations
            if(myCustomer.prevReservationList.count == 0){
                return 0
            }
            else{
                return myCustomer.prevReservationList.count
            }
        }
        else{
            print ("Error: table view displaying 0 by incorrect default")
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerReservationTableView.dequeueReusableCell(withIdentifier: "reservationReusableCell") as! ReservationsCustomerTableViewCell
        if (reservationSeg.selectedSegmentIndex == 0){  // Showing CURRENT reservations
            if(myCustomer.getNumOfUserReservations() == 0){
                return cell
            }
            else{
                cell.companyLabelName?.text = myCustomer.getUserResCompName(pos: indexPath.item)
                cell.dateLabel?.text = myCustomer.getUserResDate(pos: indexPath.item)
                cell.partyLabelName?.text = myCustomer.getUserResName(pos: indexPath.item)
                cell.logoSlot.image = UIImage(named: "Coming_Soon")
                
                return cell
            }
        }
        else if (reservationSeg.selectedSegmentIndex == 1){ // Showing PREVIOUS reservations
            if(myCustomer.prevReservationList.count == 0){
                return cell
            }
            else{
                cell.companyLabelName?.text = myCustomer.getUserPrevResCompName(pos: indexPath.item)
                cell.dateLabel?.text = myCustomer.getUserPrevResDate(pos: indexPath.item)
                cell.partyLabelName?.text = myCustomer.getUserPrevResName(pos: indexPath.item)
                cell.logoSlot.image = UIImage(named: "Coming_Soon")
                
                return cell
            }
        }
        else{
            print ("Error: tableview could not select segment index")
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
        /*myCustomer.loadReservations(){
            for currReservation in self.myCustomer.reservationList{
                self.myCustomer.loadOldReservations(reservation: currReservation)
            }
            self.customerReservationTableView.reloadData()
        }*/
    }
    @IBAction func onSegmentChange(_ sender: Any) {
        self.customerReservationTableView.reloadData()
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
    
    func setNavbar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}


extension CustomerViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (reservationSeg.selectedSegmentIndex == 0){
            print("Attempting to broadcast beacon for \(myCustomer.reservationList)")
        }
        //let item = Item(date: "Current Date", name: "Blake", size: 1, uuid: UUID(), majorValue: 1, minorValue: 2)
        
        /*let detailMessage = "UUID: \(item.uuid.uuidString)\nMajor: \(item.majorValue)\nMinor: \(item.minorValue)"
        let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .alert)
        detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(detailAlert, animated: true, completion: nil)*/
    }
}
