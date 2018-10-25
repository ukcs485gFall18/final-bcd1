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
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    
    //Comfirmation Button
    @IBOutlet weak var comfirmationBtn: UIButton!
    
    //UI Date picker
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPartyName.placeholder = "Party's Name"
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
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        txtTime.inputAccessoryView = toolbar
        txtTime.inputView = datePicker
    }
    
    //What happens when done is pressed in date picker
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        let form = DateFormatter()
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        //formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        //let form = DateComponentsFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        form.dateFormat = "HH:mm"
        //form.zeroFormattingBehavior()
        //txtPartyName.text = form.string(from: datePicker.date)
        txtDatePicker.text = formatter.string(from: datePicker.date)
        txtTime.text = form.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    //what happens when cancel is pressed in date picker
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func comfirmationBtnTapped(_ sender: Any) {
        //Check to see if all fields are filled and vaild
        //if so store reservation and name
        //pop an alert window saying reservation comfiremed and exit the window
        print("You Comfired your reservation")
        
        //create a new reservation
        //add it to the calendar
    }
}
