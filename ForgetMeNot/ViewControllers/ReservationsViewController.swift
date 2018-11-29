//
//  ReservationViewController.swift
//  ForgetMeNot
//
//  Created by David Mercado on 10/21/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit
import EventKit
import Foundation
import Firebase

class ReservationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var reservationTableView: UITableView!
    
    //private var _eventStore: EKEventStore?
    //private var eventStore: EKEventStore? {
      //  if _eventStore == nil {
        //    _eventStore = EKEventStore()
        //}
        //return _eventStore
    //}
    let eventStore = EKEventStore()
    let dataSourceArray = ["Item1 ", "Item 2", "Item 3"]
    var calendars: [EKCalendar]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        //This is the navagation bar------
        //make this the back button and connect it
        /*let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapButton))
        self.navigationItem.leftBarButtonItem = doneButton
        */
        //go to previous
        let backButton: UIBarButtonItem = {
            let barButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(tapBackButton))
            //barButtonItem.tintColor = UIColor.red
            return barButtonItem
        }()
        self.navigationItem.leftBarButtonItem = backButton

        //This is the reservations-----
        //connect this to the add
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        self.navigationItem.rightBarButtonItem = addButton
        */
    }/*
    @objc func tapBackButton(){
        print("YOu tapped Back!!")
    }
    
    @objc func tapAddButton(){
        print("YOu tapped Add!!")
    }*/
    //Custom accessors--------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        checkCalendarAuthorizationStatus()
    }
    
/*    func getReservationInfo() {
        let dataRef = Database.database().reference()
        
        //partyName, reservation/\(userReservation.getCompName))/\(userReservation.getUUID())
        dataRef.child(<#T##pathString: String##String#>).observe(.value) { (datasnapshot) in
        guard let reservationsnapshot = datasnapshot.children.allObjects as ? [DataSnapshot] else {return}
            for reservation in reservationsnapshot {
                let reservationName = reservation.childSnapshot(forPath: "partyName")
            }
        
            
            
        }
    }*/
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
            refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied: break
            // We need to help them give us permission
            //needPermissionView.fadeIn()
        }
    }
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
                    self.refreshTableView()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    //self.needPermissionView.fadeIn()
                })
            }
        })
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
    }
    
    func refreshTableView() {
        reservationTableView.isHidden = false
        reservationTableView.reloadData()
    }

    //UITableView------------------------------------------------------------------------------
   /* @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        UIApplication.shared.openURL(openSettingsUrl!)
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let calendars = self.calendars {
            return calendars.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        
        if let calendars = self.calendars {
            let calendarName = calendars[(indexPath as NSIndexPath).row].title
            cell.textLabel?.text = calendarName
        } else {
            cell.textLabel?.text = "Unknown Calendar Name"
        }
        
        return cell
    }
    

    
    
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell") as! UITableViewCell

        cell.textLabel?.text = dataSourceArray[indexPath.row]
        return cell
    }*/
}
