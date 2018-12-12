//
//  SignUpViewController.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 10/23/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignUpViewController : UIViewController{
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPass: UITextField!
    @IBOutlet weak var userPassConfirm: UITextField!
    @IBOutlet weak var cName: UITextField!
    @IBOutlet weak var IDSelector: UISegmentedControl!

    //Refrence: https://www.youtube.com/watch?v=m_0_XQEfrGQ
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        // Hide Company field on load
        cName.isHidden = true
        
        super.viewDidLoad()
        setBackground()
    }
    @IBAction func IDSelectorTapped(_ sender: Any) {
        if (IDSelector.selectedSegmentIndex == 0){
            cName.isHidden = true
        }
        else if (IDSelector.selectedSegmentIndex == 1){
            cName.isHidden = false
        }
    }
    
    #warning("Can add this to the Alert.swift")
    func showMessage (alertTitle : String, alertMessage : String, actionTitle : String){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // Make a popup with a segue
    func segueHomeMessage (alertTitle : String, alertMessage : String, actionTitle : String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .cancel, handler: { (action) in
            
            print ("Taking user back to Login Page after successful Sign Up")
            // call the segue at hare
            self.performSegue(withIdentifier:"SignUpToLogin", sender: nil)
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        (sender as! UIButton).pulsate() // Animate button when pressed
        
        var databaseRef : DatabaseReference? // Create firebase database reference variable
        databaseRef = Database.database().reference()  // Link the firebase database
        
        let userEmailTxt = self.userEmail.text!
       
        
        if (userPass.text == userPassConfirm.text){
            Auth.auth().createUser(withEmail: userEmail.text!, password: userPass.text!)
            { (user, error) in
                
                if error == nil{
                    guard let createdUser = user else{
                        return
                    }
                    
                    let userID = createdUser.user.uid
                    
                    // Store Company or Customer data in customer
                    if (self.IDSelector.selectedSegmentIndex == 0){//Customer
                        databaseRef?.child("userList").child(userID).setValue(["userType" : "Customer"])// Write to database the user is a Customer
                        databaseRef?.child("userList").child(userID).child("partyNameList").setValue(["partyName" : "Initial"])// Write to database the user is a Company
                    }
                    else if (self.IDSelector.selectedSegmentIndex == 1){// Company
                        //check to make sure "Company Name" is not empty
                        #warning("fix logic")
                        if(self.cName.text?.isEmpty ?? true){
                            Alert.showMissingNameAlert(on: self)
                        }
                        else{
                            let userCompanyName = self.cName.text!

                            databaseRef?.child("userList").child(userID).setValue(["userType" : "Company"])// Write to database the user is a Company
                            databaseRef?.child("userList/\(userID)/companyName").setValue(userCompanyName)

                            //insert to company database
                            databaseRef?.child("companyList").child(userCompanyName).setValue(["userID" : "\(userID)"])
                        }
                    }
                    
                    databaseRef?.child("userList/\(userID)/email").setValue(userEmailTxt)
                    
                    #warning("Can add this to the Alert.swift")
                    // User added successful message, and segue back to login screen
                    self.segueHomeMessage(alertTitle: "Complete ✅", alertMessage: "Congratulations on your new account! Enjoy calling Dibs!!!", actionTitle: "Go ➡️")
                }
                else{
                    (sender as! UIButton).shake() // Animate button with error
                    
                    #warning("Can add this to the Alert.swift")
                    self.showMessage(alertTitle: "Error", alertMessage: (error?.localizedDescription)!, actionTitle: "Dismiss")
                    print ("❌" + (error?.localizedDescription)!)
                }
                
            }
        }
        else{ // Passwords do not match
            #warning("Can add this to the Alert.swift")
            showMessage(alertTitle: "Passwords do not match", alertMessage: "Please enter identical passwords", actionTitle: "Dismiss")
        }
    }
    
    //--------------------------------------------------------------------------
    //Refrence: https://www.youtube.com/watch?v=m_0_XQEfrGQ
    //sets the background
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
