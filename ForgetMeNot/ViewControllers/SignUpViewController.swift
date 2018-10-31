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
    
    func showMessage (alertTitle : String, alertMessage : String, actionTitle : String){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if (userPass.text == userPassConfirm.text){ // Verify both passwords match
        Auth.auth().createUser(withEmail: userEmail.text!, password: userPass.text!)
        showMessage(alertTitle: "Complete ✅", alertMessage: "Congratulations on your new account. Please continue to the login page.", actionTitle: "Done")
            
        }
        else{
            showMessage(alertTitle: "Passwords do not match", alertMessage: "Please enter identical passwords", actionTitle: "Dismiss")
        }
    }
}
