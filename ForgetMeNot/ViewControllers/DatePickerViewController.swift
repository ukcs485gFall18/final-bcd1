//  DatePickerViewController.swift
//  Created by David Mercado on 10/23/18.
//
//  The user uses this to pick their reservation time slot. This displays a UI Date picker
//  Reference: https://medium.com/@javedmultani16/uidatepicker-in-swift-3-and-swift-4-example-35a1f23bca4b

import UIKit
import Firebase

class DatePickerViewController: UIViewController {
    //Text Field Connection
    @IBOutlet weak var txtPartyName: UITextField!
    @IBOutlet weak var txtPartySize: UITextField!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtCompName: UITextField!
    
    //Comfirmation Button
    @IBOutlet weak var comfirmationBtn: UIButton!
    
    //UI Date picker
    let datePicker = UIDatePicker()
    var dateOfReservation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPartyName.placeholder = "Party's Name"
        txtPartySize.placeholder = "Party's Size"
        txtDatePicker.placeholder = "MM/DD/YYYY"
        txtTime.placeholder = "HH:MM"
        txtCompName.placeholder = "Company Name"

        //display date picker
        showDatePicker()
    }

    //function to display UI date picker
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 15
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //'Done' button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        
        //space between 'done' and 'cancel' buttons
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        //'Cancel' button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        //adding date picker to textfields (date, time)
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        txtTime.inputAccessoryView = toolbar
        txtTime.inputView = datePicker
    }
    
    //When 'Done' is pressed in date picker and scrubs user input to prep for storing reservation
    @objc func donedatePicker(){
        
        //used to format date and time from UIDate picker
        let formatter = DateFormatter()
        let form = DateFormatter()
        let dateFormatter = DateFormatter()
        
        formatter.dateFormat = "MM/dd/yyyy"
        form.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"

        txtDatePicker.text = formatter.string(from: datePicker.date)
        txtTime.text = form.string(from: datePicker.date)
        dateOfReservation = dateFormatter.string(from: datePicker.date)
        
        print(dateOfReservation)            //DEBUGGING PURPOSE
        self.view.endEditing(true)
    }
    
    //When 'Cancel' is pressed in date picker
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    //Function that comfirms the reservation
    @IBAction func comfirmationBtnTapped(_ sender: Any) {
        var ValidReservationFlag = true
        
        //check to see if text fields are filled out
        #warning("check for validity")
        
        if (txtPartyName.text?.isEmpty ?? true) {
            ValidReservationFlag = false
            print("name is empty")
        }
        else if(txtPartySize.text?.isEmpty ?? true){
            ValidReservationFlag = false
            print("party size is empty")
        }
        else if (txtDatePicker.text?.isEmpty ?? true) {
            ValidReservationFlag = false
            print("date is empty")
        }
        else if (txtTime.text?.isEmpty ?? true) {
            ValidReservationFlag = false
            print("time is empty")
        }
        
        //if info vaild create reservation and add it to the calendar
        if(ValidReservationFlag){
            print("You Comfired your reservation")
            let pName = txtPartyName.text!
            let pSize = Int(txtPartySize.text!)
            let pDate = txtDatePicker.text!
            let pTime = txtTime.text!

            #warning("make pname dynamic so user can make an input")
            let pCompName = "Chilis"
            print(pName)
            print(pSize)
            print(pDate)
            print(pTime)
            print(dateOfReservation)        //DEBUGGING PURPOSES
        
            let pCompName = txtCompName.text!
            
            var databaseRef : DatabaseReference? // Create firebase database reference variable
            databaseRef = Database.database().reference()  // Link the firebase database

            
            //init a new reservation
            let userReservation = MyReservation(date: dateOfReservation, uuid: UUID(),  CompName: pCompName, name: pName, size: pSize!)
            
            //call firebase and insert user's reservation into database
        databaseRef?.child("reservation").child(userReservation.getPartyName()).child(userReservation.getCompName()).setValue(["partyDate" : userReservation.getDate()])
            
            
            databaseRef?.child("reservation/\(userReservation.getPartyName())/\(userReservation.getCompName())/partySize").setValue(userReservation.getPartySize())
            
            databaseRef?.child("reservation/\(userReservation.getPartyName())/\(userReservation.getCompName())/partyUUID").setValue(userReservation.getUUIDString())
            
            //databaseRef?.child("reservation/\(userReservation.getUUID)").setValue(userReservation)
            
            //this is a confirmation alert...need to link so afterwards it exits
            //Alert.showConfirmReservationAlert(on:self)
            
            
            self.performSegue(withIdentifier: "HomeSegue", sender: self)
        }
        else{
            Alert.showIncompleteFormAlert(on: self)
        }
    }
}
