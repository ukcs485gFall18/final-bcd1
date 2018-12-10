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

class SignInViewController : UIViewController{
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginBtn: SAButton!
    
    //Refrence: https://www.youtube.com/watch?v=m_0_XQEfrGQ
    let backgroundImageView = UIImageView()
    
    // User object
    var myCustomer : Users = Users(email: "", userType: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User Interface Elements
        setBackground()
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(1.0)])
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(1.0)])
        
        
        // Remove keyboard when tapping away
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    #warning("Can add this to the Alert.swift")
    // Display a popup alert
    func showMessage (alertTitle : String, alertMessage : String, actionTitle : String){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Function used to clean 'Item' data from userDefaults.standard.array(forKey: storedItems)
    func cleanItems(){
        print("Cleaning Item Data...Please Wait!")
        UserDefaults.standard.removeObject(forKey: kStoredItemsKey)
        UserDefaults.standard.synchronize()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func logInAction(_ sender: Any) {
        (sender as! UIButton).pulsate() // Animate button when pressed
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) {
            (user, error) in
            if error == nil{
                // Get the User's ID
                guard let userID = user?.user.uid else{
                    return
                }
                
                // Gather userType from database for the current user
                self.myCustomer.getUsersData([userID], handler: { (foundUsers) in
                    
                    // Parse array of users for desired user's type
                    for person in foundUsers{
                        if (person.email == self.email.text!){ // Authentication successful
                            
                            // Get the current indexed user's type
                            guard let userType = person.userType else{
                                return
                            }
                            
                            // Take user down specific route
                            if (userType == "Customer"){
                                self.performSegue(withIdentifier: "LoginToCustomer", sender: self)
                                print("User: " + userID + " has been signed in to customer side")
                            }
                            else if (userType == "Company"){
                                self.cleanItems()
                                self.performSegue(withIdentifier: "LoginToHost", sender: self)
                                print("User: " + userID + " has been signed in to company side")
                            }
                            else{
                                #warning("Can add this to the Alert.swift")
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
                
                #warning("Can add this to the Alert.swift")
                // Display message with Error
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
                self.myCustomer.getUsersData([userID], handler: { (foundUsers) in
                    
                    // Parse array of users for desired user's type
                    for person in foundUsers{
                        if (person.email == self.email.text!){ // Authentication successful
                            
                            // Get the current indexed user's type
                            guard let userType = person.userType else{
                                return
                            }
                            
                            // Take user down specific route
                            if (userType == "Customer"){
                                self.performSegue(withIdentifier: "LoginToCustomer", sender: self)
                                print("User: " + userID + " has been signed in to customer side")
                            }
                            else if (userType == "Company"){
                                self.cleanItems()
                                self.performSegue(withIdentifier: "LoginToHost", sender: self)
                                print("User: " + userID + " has been signed in to company side")
                            }
                            else{
                                #warning("Can add this to the Alert.swift")
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
                
                #warning("Can add this to the Alert.swift")
                // Display message with Error
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
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
        backgroundImageView.image = UIImage(named: kBg3)
        view.sendSubviewToBack(backgroundImageView)
    }
}
