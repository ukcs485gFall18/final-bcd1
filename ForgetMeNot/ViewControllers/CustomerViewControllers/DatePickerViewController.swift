//  DatePickerViewController.swift
//  Created by David Mercado on 10/23/18.
//
//  The user uses this to pick their reservation time slot. This displays a UI Date picker
//  Reference: https://medium.com/@javedmultani16/uidatepicker-in-swift-3-and-swift-4-example-35a1f23bca4b

import UIKit
import Firebase

class DatePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    //Text Field Connection
    @IBOutlet weak var txtPartyName: UITextField!
    @IBOutlet weak var txtCompName: UITextField!
    @IBOutlet weak var txtPartySize: UITextField!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var txtTime: UITextField!

    //Comfirmation Button
    @IBOutlet weak var comfirmationBtn: UIButton!
    
    //UI Date picker
    let datePicker = UIDatePicker()
    let resturantPicker = UIPickerView()
    
    #warning("MAKE THIS DYNAMIC")
    let avaiableResturants = ["Chilis", "Applebees", "TGI Friday's"]             //TODO: GET THIS INFO FROM FIREBASE TABLE
    var dateOfReservation = ""
    
    //--------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPartyName.placeholder = "Party's Name"
        txtPartySize.placeholder = "Party's Size"
        txtCompName.placeholder = "Resturant's Name"
        txtDatePicker.placeholder = "MM/DD/YYYY"
        txtTime.placeholder = "HH:MM"

        //display date picker
        showDatePicker()
        showResturantPicker()
    }

    #warning("TODO: MAKE UIPICKER FOR RESTURANTS")
    
    //--------------------------------------------------------------------------
    //function to display UI date picker when either date or time text fields are clicked on
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
    
    //--------------------------------------------------------------------------
    //function to display UI picker for resturants when text box is tapped
    func showResturantPicker(){
        resturantPicker.delegate = self
        resturantPicker.delegate?.pickerView?(resturantPicker, didSelectRow: 0, inComponent: 0)
    
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //'Done' button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneRestPicker));
        
        //space between 'done' and 'cancel' buttons
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        //'Cancel' button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        //adding date picker to textfields (Company name)
        txtCompName.inputAccessoryView = toolbar
        txtCompName.inputView = resturantPicker
    }
    
    //number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return avaiableResturants.count
    }
    
    //data being returned
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return avaiableResturants[row]
    }
    
    //sets textfield to resturant name
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCompName.text =  avaiableResturants[row]
    }
    
    //--------------------------------------------------------------------------
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
        
        print(dateOfReservation)                                                //DEBUGGING PURPOSE
        self.view.endEditing(true)
    }
    
    //--------------------------------------------------------------------------
    //When 'Done' is pressed in resturant picker and scrubs user input to prep for storing reservation
    @objc func doneRestPicker(){
        //txtCompName.text = resturantPicker.dataSource as? String
        print(txtCompName.text!)                                                //DEBUGGING PURPOSE
        self.view.endEditing(true)
    }
    
    //--------------------------------------------------------------------------
    //When 'Cancel' is pressed in date picker
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    //--------------------------------------------------------------------------
    //Function that comfirms the reservation when button is tapped
    @IBAction func comfirmationBtnTapped(_ sender: Any) {
        var ValidReservationFlag = true
        
        //check to see if text fields are not filled out
        #warning("TODO: check for validity (test cases)")
        
        if (txtPartyName.text?.isEmpty ?? true) {
            ValidReservationFlag = false
            print("Party's name is empty")                                      //DEBUGGING PURPOSE
        }
        else if(txtCompName.text?.isEmpty ?? true){
            ValidReservationFlag = false
            print("Resturant name is empty")                                    //DEBUGGING PURPOSE
        }
        else if(txtPartySize.text?.isEmpty ?? true){
            ValidReservationFlag = false
            print("Party's size is empty")                                      //DEBUGGING PURPOSE
        }
        else if (txtDatePicker.text?.isEmpty ?? true) {
            ValidReservationFlag = false
            print("Date is empty")                                              //DEBUGGING PURPOSE
        }
        else if (txtTime.text?.isEmpty ?? true) {
            ValidReservationFlag = false
            print("Time is empty")                                              //DEBUGGING PURPOSE
        }
        
        //if user information is valid, store into reservation class and send it to firebase
        if(ValidReservationFlag){
            print("You Comfired your reservation")                              //DEBUGGING PURPOSE
            
            //store user input to variables
            let pName = txtPartyName.text!
            let pCompName = txtCompName.text!
            let pSize = Int(txtPartySize.text!)
            let pDate = txtDatePicker.text!
            let pTime = txtTime.text!

            print(pName)                                                        //DEBUGGING PURPOSE
            print(pCompName)                                                    //DEBUGGING PURPOSE
            print(pSize!)                                                        //DEBUGGING PURPOSE
            print(pDate)                                                        //DEBUGGING PURPOSE
            print(pTime)                                                        //DEBUGGING PURPOSE
            print(dateOfReservation)                                            //DEBUGGING PURPOSES
            
            //init a new reservation
            let userReservation = MyReservation(date: dateOfReservation, uuid: UUID(),  CompName: pCompName, name: pName, size: pSize!)
            
            #warning("no longer active, use new USER CLASS")
            //kPartyNames.insert(pName, at: 0)
            
            //================================================================//
            //                    *Firebase insertions                        //
            //================================================================//
            var databaseRef : DatabaseReference?            // Create firebase database reference variable
            databaseRef = Database.database().reference()   // Link the firebase database
            
            //Call firebase and insert user's reservation into user's Party name
        databaseRef?.child("reservation").child(userReservation.getPartyName()).child(userReservation.getCompName()).setValue(["partyDate" : userReservation.getDate()])
            
            //Call firebase and insert Party's size into firebase under same Party name as above
            databaseRef?.child("reservation/\(userReservation.getPartyName())/\(userReservation.getCompName())/partySize").setValue(userReservation.getPartySize())
            
            //Call firebase and insert Party's UUID into firebase under same Party name as above
            databaseRef?.child("reservation/\(userReservation.getPartyName())/\(userReservation.getCompName())/partyUUID").setValue(userReservation.getUUIDString())

            //------------------------------------------------------------------
            //Call firebase and insert user's reservation into Resturant's table
            
            databaseRef?.child("companyList/\(userReservation.getCompName())/\(userReservation.getUUIDString())").setValue(userReservation.getUUIDString())
            databaseRef?.child("companyList/\(userReservation.getCompName())/\(userReservation.getUUIDString())/PartyDate").setValue(userReservation.getDate())
            databaseRef?.child("companyList/\(userReservation.getCompName())/\(userReservation.getUUIDString())/PartyName").setValue(userReservation.getPartyName())
            databaseRef?.child("companyList/\(userReservation.getCompName())/\(userReservation.getUUIDString())/PartySize").setValue(userReservation.getPartySize())

            /*
            databaseRef?.child(userReservation.getCompName()).child(userReservation.getUUIDString()).setValue(["partyDate" : userReservation.getDate()])
            
            //Call firebase and insert Party's Name into firebase under same Party UUID
            databaseRef?.child("\(userReservation.getCompName())/\(userReservation.getUUIDString())/partyName").setValue(userReservation.getPartyName())
            
            //Call firebase and insert Party's Size into firebase under same Party UUID
            databaseRef?.child("\(userReservation.getCompName())/\(userReservation.getUUIDString())/partySize").setValue(userReservation.getPartySize())*/

            //================================================================//

            #warning("for better UI experience intergrade this")
            //this is a confirmation alert to user...need to seague so afterwards it exits
            //Alert.showConfirmReservationAlert(on:self)
            
            //return to previous page
            self.performSegue(withIdentifier: "HomeSegue", sender: self)
        }
        else{
            Alert.showIncompleteFormAlert(on: self)
        }
    }
}
