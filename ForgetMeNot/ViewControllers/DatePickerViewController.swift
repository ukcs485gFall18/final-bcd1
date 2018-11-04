//
//  DatePickerViewController.swift
//  ForgetMeNot
//
//  Created by David Mercado on 10/23/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//
//  The user uses this to pick their reservation time slot. This displays a UI Date picker
//  Reference: https://medium.com/@javedmultani16/uidatepicker-in-swift-3-and-swift-4-example-35a1f23bca4b

import UIKit

class DatePickerViewController: UIViewController {
    
    //Text Field Connection
    @IBOutlet weak var txtPartyName: UITextField!
    @IBOutlet weak var txtPartySize: UITextField!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    
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

        //display date picker
        showDatePicker()
    }

    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 15
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //Done button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        //Cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        //adding date picker to textfields (date, time)
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        txtTime.inputAccessoryView = toolbar
        txtTime.inputView = datePicker
    }
    
    //What happens when 'Done' is pressed in date picker
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        let form = DateFormatter()
        let dateFormatter = DateFormatter()
        
        formatter.dateFormat = "MM/dd/yyyy"
        form.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"

        txtDatePicker.text = formatter.string(from: datePicker.date)
        txtTime.text = form.string(from: datePicker.date)
        dateOfReservation = dateFormatter.string(from: datePicker.date)
        print(dateOfReservation)
        self.view.endEditing(true)
    }
    
    //what happens when 'Cancel' is pressed in date picker
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    //Function that comfirms the reservation
    @IBAction func comfirmationBtnTapped(_ sender: Any) {
        var ValidReservationFlag = true
        
        //check to see if text fields are filled out
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
            print(pName)
            print(pSize)
            print(pDate)
            print(pTime)
            print(dateOfReservation)
            
            //var Reservation =
            MyReservation(date: dateOfReservation, uuid: UUID(), name: pName, size: pSize!)
            
            #warning("add reservation to database")
            
            //this is a confirmation alert...need to link so afterwards it exits
            //Alert.showConfirmReservationAlert(on:self)
            
            self.performSegue(withIdentifier: "HomeSegue", sender: self)
        }
        else{
            Alert.showIncompleteFormAlert(on: self)
        }
    }
}
