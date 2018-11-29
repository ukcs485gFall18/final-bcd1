//
//  SignInViewController.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 10/23/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import Firebase

// Button animations
extension UIButton{
    func pulsate(){
        layer.removeAllAnimations() // Make sure to only perform one animation at a time
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
    func shake(){
        layer.removeAllAnimations() // Make sure to only perform one animation at a time
        let shake = CABasicAnimation(keyPath: "position")
        
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y + 5)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y - 5)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: nil)
    }
}

func getUsersData(_ users: [String], handler: @escaping (_ usersArray: [Users]) -> ()) {
    var usersArray = [Users]()
    
    // Create firebase reference and link to database
    let dataRef = Database.database().reference()
    
    dataRef.child("userList").observe(.value) { (datasnapshot) in
        guard let usersnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
        
        for user in usersnapshot {
            let email = user.childSnapshot(forPath: "email").value as! String
            let userType = user.childSnapshot(forPath: "userType").value as! String
            
            let userObj = Users(email: email, userType: userType)
            usersArray.append(userObj)
        }
        handler(usersArray)
    }
}

class SignInViewController : UIViewController{
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // Display a popup alert
    func showMessage (alertTitle : String, alertMessage : String, actionTitle : String){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // When login button is pressed
    @IBAction func loginAction(_ sender: Any) {
        (sender as! UIButton).pulsate() // Animate button when pressed
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) {
            (user, error) in
            if error == nil{
                // Get the User's ID
                guard let userID = user?.user.uid else{
                    return
                }
                
                // Gather userType from database for the current user
                getUsersData([userID], handler: { (foundUsers) in

                    
                    // Parse array of users for desired user's type
                    for person in foundUsers{
                        if (person.email == self.email.text!){ // Authentication successful

                            // Get the current indexed user's type
                            guard let userType = person.userType else{
                                return
                            }
                            
                            // Remember user's information into UserData.swift
                            kuserEmail = person.email!
                            kuserType = person.userType!
                            kuserID = userID
                            
                            
                            // Take user down specific route
                            if (userType == "Customer"){
                                self.performSegue(withIdentifier: "LoginToCustomer", sender: self)
                                print("User: " + userID + " has been signed in to customer side")
                            }
                            else if (userType == "Company"){
                                self.performSegue(withIdentifier: "LoginToHost", sender: self)
                                print("User: " + userID + " has been signed in to company side")
                            }
                            else{
                                self.showMessage(alertTitle: "Error",
                                                 alertMessage: "User attempted to sign in with no user type.",
                                                 actionTitle: "Dismiss")
                            }
                        }
                    }
                    
                })

            }
            else{
                (sender as! UIButton).shake() // Shake button animation
                
                // Display message with Error
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
