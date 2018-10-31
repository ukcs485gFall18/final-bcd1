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
    
    @IBAction func signUpAction(_ sender: Any) {
        if (userPass.text == userPassConfirm.text){ // Verify both passwords match
        Auth.auth().createUser(withEmail: userEmail.text!, password: userPass.text!)
        }
        else{
            let alertController = UIAlertController(title: "Passwords do not match", message: "Please make sure both passwords are identical.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
