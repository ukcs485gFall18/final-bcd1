//  DatePickerViewController.swift
//  Created by David Mercado on 10/23/18.
//
//  The user uses this to pick their reservation time slot. This displays a UI Date picker
//  Reference: https://medium.com/@javedmultani16/uidatepicker-in-swift-3-and-swift-4-example-35a1f23bca4b

import UIKit
import Firebase

class DatePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var txtPartyName: UITextField!
    @IBOutlet weak var txtCompName: UITextField!
    @IBOutlet weak var txtPartySize: UITextField!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var comfirmationBtn: UIButton!
    
    //Refrence: https://www.youtube.com/watch?v=m_0_XQEfrGQ
    let backgroundImageView = UIImageView()
    
    //UI Date picker
    let datePicker = UIDatePicker()
    let resturantPicker = UIPickerView()
    
    #warning("MAKE THIS DYNAMIC")
    let avaiableResturants = ["Chilis", "Applebees", "Hooters"]             //TODO: GET THIS INFO FROM FIREBASE TABLE
    var dateOfReservation = ""
    
    //--------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        /*txtPartyName.placeholder = "Party's Name"
        txtPartySize.placeholder = "Party's Size"
        txtCompName.placeholder = "Resturant's Name"
        txtDatePicker.placeholder = "MM/DD/YYYY"
        txtTime.placeholder = "HH:MM"*/

        //display date picker
        showDatePicker()
        showResturantPicker()
    }
    
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
    #warning("pull resturants from FIREBASE")
    //Reference: https://codewithchris.com/uipickerview-example/
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
    #warning("FIXME: make sure the dates and times show from current date forward")
    //When 'Done' is pressed in date picker and scrubs user input to prep for storing reservation
    @objc func donedatePicker(){
        #warning("If it needs to be a date https://stackoverflow.com/questions/36861732/swift-convert-string-to-date")
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
            
            //================================================================//
            //                    *Firebase insertions                        //
            //================================================================//
            var databaseRef : DatabaseReference?            // Create firebase database reference variable
            databaseRef = Database.database().reference()   // Link the firebase database
            
            //------------------------------------------------------------------
            //Call firebase and insert user's reservation into user's Party name
            #warning("FIXME: so when a resturant already exisit in the party's name, it doesnt get overwritten")
        databaseRef?.child(kReservation).child(userReservation.getPartyName()).child(userReservation.getCompName()).setValue([kPartyDate : userReservation.getDate()])
            
            //Call firebase and insert Party's size into firebase under same Party name as above
            databaseRef?.child("\(kReservation)/\(userReservation.getPartyName())/\(userReservation.getCompName())/\(kPartySize)").setValue(userReservation.getPartySize())
            
            //Call firebase and insert Party's UUID into firebase under same Party name as above
            databaseRef?.child("\(kReservation)/\(userReservation.getPartyName())/\(userReservation.getCompName())/\(kPartyUUID)").setValue(userReservation.getUUIDString())

            //------------------------------------------------------------------
            //Call firebase and insert user's reservation into Resturant's table
            
            databaseRef?.child("\(kCompanyList)/\(userReservation.getCompName())/\(userReservation.getUUIDString())").setValue(userReservation.getUUIDString())
            databaseRef?.child("\(kCompanyList)/\(userReservation.getCompName())/\(userReservation.getUUIDString())/\(kPartyDate)").setValue(userReservation.getDate())
            databaseRef?.child("\(kCompanyList)/\(userReservation.getCompName())/\(userReservation.getUUIDString())/\(kPartyName)").setValue(userReservation.getPartyName())
            databaseRef?.child("\(kCompanyList)/\(userReservation.getCompName())/\(userReservation.getUUIDString())/\(kPartySize)").setValue(userReservation.getPartySize())
            //================================================================//

            //this is a confirmation alert to user, seagues back to previous page
            Alert.showConfirmReservationAlert(on: self)
            
            //return to previous page
            //self.performSegue(withIdentifier: "HomeSegue", sender: self)
        }
        else{
            Alert.showIncompleteFormAlert(on: self)
        }
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
