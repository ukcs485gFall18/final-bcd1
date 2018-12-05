//
//  ReservationViewController.swift
//
//  Created by David Mercado on 10/21/18.
//

import Foundation
import UIKit
import Firebase
import EventKit

class ReservationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var reservationTableView: UITableView!
    
    let eventStore = EKEventStore()
    let dataSourceArray = ["Item 1 ", "Item 2", "Item 3"]
    var calendars: [EKCalendar]?
    let myCompany = Company()
    
    
    override func viewDidLoad() {
        DispatchQueue.main.async(execute: {
            self.myCompany.whoAmI()
        })
        super.viewDidLoad()
    }
    
    //Custom accessors--------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        checkCalendarAuthorizationStatus()
    }
    
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
        //reservationTableView.isHidden = false
        reservationTableView.reloadData()
    }
    /* @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
     let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
     UIApplication.shared.openURL(openSettingsUrl!)
     }*/
    
    //UITableView------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("resCount: \(myCompany.getNumOfReservations())")
        if let calendars = self.calendars {
            print("calendar Count: \(calendars.count)")
            return calendars.count
        }
        
        return 0
        /*
        print("resCount: \(myCompany.getNumOfReservations())")
        return myCompany.getNumOfReservations()*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HostCell") as! ReservationsHostTableViewCell
        
        cell.customerNameLabel?.text = String("Test \(indexPath.item)")
        
        if let calendars = self.calendars {
            let calendarName = calendars[(indexPath as NSIndexPath).row].title
            cell.dateLabel?.text = calendarName
        } else {
            cell.dateLabel?.text = "Unknown Calendar Name"
        }
        /*
        print("resName: \(myCompany.getReservationName(pos: indexPath.item))")
        print("resDate: \(myCompany.getReservationDate(pos: indexPath.item))")
        cell.customerNameLabel?.text = myCompany.getReservationName(pos: indexPath.item)
        //let calendarName = calendars[(indexPath as NSIndexPath).row].title
        let cellData = myCompany.getReservationDate(pos: indexPath.row)
        cell.dateLabel?.text = cellData*/
        
        return cell
    }

    
    /*
     //used in conjection with dataSourceArray[]
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HostCell") as! ReservationsHostTableViewCell

        cell.customerNameLabel?.text = dataSourceArray[indexPath.item]
        cell.dateLabel?.text = dataSourceArray[indexPath.row]
        return cell
    }*/
}
