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
//
//  CalendarViewController.swift
//
//  Created by David Mercado on 9/30/18.
//
//  This file was created by David Mercado and it is used to make a calendar
//  Could not get my initial idea to work so just commented out all of the work and
//  deleted parts of the story board that could interfere with the compliation of the app
//  The work around is setting up a button that when pressed calls the external calendar app.
//  Will revisit the calendar idea, if not capable of using apple's calendar app internally
//  with our app we will have to switch to reminders for the schuduling of this app.
//  A good refrence for this idea is: https://www.raywenderlich.com/2291-eventkit-tutorial-making-a-calendar-reminder
//
//Reference: https://www.andrewcbancroft.com/2015/05/14/beginners-guide-to-eventkit-in-swift-requesting-permission/
//Reference: https://github.com/andrewcbancroft/EventTracker/blob/ask-for-permission/EventTracker/ViewController.swift
//Reference: https://www.youtube.com/watch?v=ES69XgBDgeo&feature=youtu.be
//-------------------------------------------------------------------------------------------


/*
 import UIKit
 import EventKit
 import Foundation
 
 class CalendarViewController: UIViewController/*, UITableViewDataSource, UITableViewDelegate*/ {
 
 //var eventStore : EKEventStore = EKEventStore()
 
 //@IBOutlet weak var needPermissionView: UIView!
 //@IBOutlet weak var calendarsTableView: UITableView!
 
 //var calendars: [EKCalendar]?
 //var calendar: EKCalendar?
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapButton))
 self.navigationItem.leftBarButtonItem = addButton
 
 let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapButton))
 self.navigationItem.rightBarButtonItem = doneButton
 
 //UIApplication.shared.openURL(NSURL(string: "calshow://")! as URL)
 }
 @objc func tapButton(){
 print("YOu tapped!!")
 }
 
 
 //Bool function that checks for calendar authorization----------------------------------
 override func viewWillAppear(_ animated: Bool) {
 checkCalendarAuthorizationStatus()
 }
 
 //Function that checks calendar authorization-------------------------------------------
 func checkCalendarAuthorizationStatus() {
 let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
 print("Status is \(status)")
 
 switch (status) {
 case EKAuthorizationStatus.notDetermined:         // This happens on first-run
 print("inside notDetermined")
 requestAccessToCalendar()
 
 case EKAuthorizationStatus.authorized:
 // Things are in line with being able to show the calendars in the table view
 
 print("inside authorized")
 
 loadCalendars()
 refreshTableView()
 
 case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
 print("inside denied")
 
 // We need to help them give us permission
 needPermissionView.fadeIn()
 }
 }
 
 //Function that asks user access to calendar--------------------------------------------
 func requestAccessToCalendar(){
 eventStore.requestAccess(to: EKEntityType.event, completion: {
 (accessGranted: Bool, error: Error?) in
 
 if accessGranted == true {
 /*print("granted \(accessGranted)")
 print("error  \(String(describing: error))")
 
 let event:EKEvent = EKEvent(eventStore: self.eventStore)
 event.title = "Test Title"
 event.startDate = NSDate() as Date
 event.endDate = NSDate() as Date
 event.notes = "This is a note"
 event.calendar = self.eventStore.defaultCalendarForNewEvents
 //eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
 print("Saved Event")*/
 
 DispatchQueue.main.async(execute: {
 self.loadCalendars()
 self.refreshTableView()
 })
 } else {
 DispatchQueue.main.async(execute: {
 self.needPermissionView.fadeIn()
 })
 }
 })
 }
 
 //Function that loads the users calendar------------------------------------------------
 func loadCalendars() {
 print("inside loadCalendars")
 self.calendars = eventStore.calendars(for: EKEntityType.event)
 }
 
 //Function that refresh table view
 func refreshTableView() {
 print("inside refreshTableView")
 
 calendarsTableView.isHidden = false
 calendarsTableView.reloadData()
 }
 
 //Button that allows user to go to setting to allow access to calendar------------------
 @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
 let openSettingsUrl = URL(string: UIApplication.openSettingsURLString)
 //UIApplication.shared.openURL(openSettingsUrl!)
 UIApplication.shared.open(openSettingsUrl!)
 }
 
 //Table view for calendar---------------------------------------------------------------
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 if let calendars = self.calendars {
 return calendars.count
 }
 return 0
 }
 
 //Table view rows-----------------------------------------------------------------------
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
 
 func numberOfSectionsInTableView(tableView: UITableView) -> Int {
 return 2 // This was put in mainly for my own unit testing
 }
 }
 
 //------------------------------------------------------------------------------------------
 extension UIView {
 func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
 UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
 self.alpha = 1.0
 }, completion: completion)  }
 
 func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
 UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
 self.alpha = 0.0
 }, completion: completion)
 }
 }
 */
