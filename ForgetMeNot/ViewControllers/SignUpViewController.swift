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
    @IBOutlet weak var IDSelector: UISegmentedControl!
    
    #warning("Can add this to the Alert.swift")
    func showMessage (alertTitle : String, alertMessage : String, actionTitle : String){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
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
                    
                    #warning("Can add this to the Alert.swift")
                    // User added successful message
                    self.showMessage(alertTitle: "Complete ✅", alertMessage: "Congratulations on your new account. Please continue to the login page.", actionTitle: "Done")
                    
                    // Store Company or Customer data in customer
                    if (self.IDSelector.selectedSegmentIndex == 0){//Customer
                        databaseRef?.child("userList").child(userID).setValue(["userType" : "Customer"])// Write to database the user is a Customer
                    }
                    else if (self.IDSelector.selectedSegmentIndex == 1){// Company
                        databaseRef?.child("userList").child(userID).setValue(["userType" : "Company"])// Write to database the user is a Company
                    }
                    #warning("TODO: NEED TO ADD A TEXT FIELD WHEN COMPANY IS SELECTED TO TYPE IN THE COMPANY'S NAME")
                    
                    databaseRef?.child("userList/\(userID)/email").setValue(userEmailTxt)
                }
                else{
                    (sender as! UIButton).shake() // Animate button with error
                    
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
}
