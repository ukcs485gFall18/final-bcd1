//
//  Helper.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 11/20/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Helper : UIViewController{
    
    // Make a popup
    func showMessage (alertTitle : String, alertMessage : String, actionTitle : String){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /* ===================================================
     * Shortcut to call the database (Make Firebase easier)
     * ===================================================
     */
    func callDatabase() -> (DatabaseReference?){
        var databaseRef : DatabaseReference? // Create firebase database reference variable
        databaseRef = Database.database().reference()  // Link the firebase database
        
        return databaseRef
    }

    /* ===================================================
     *           Writing to Database
     *  Allows writing to database with a simple value that you wish to add and a path to the database
     *              (NON-OVERWRITING)
     * ===================================================
     */

    // Add a string to the database
    func updateStringToDatabase (databasePath : String, writeValue : String){
        let ref = callDatabase()
        ref?.child(databasePath).setValue(writeValue)
    }
    
    // Add an array of strings to the database
    func updateStringListToDatabase (databasePath : String, writeValue : [String]){
        let ref = callDatabase()
        ref?.child(databasePath).setValue(writeValue)
    }

    /* ===================================================
     *              (OVERWRITING)
     * ===================================================
     */
    func initialWriteToDatabase(databasePath1 : String, databasePath2 : String, key : String, value : String){
        let ref = callDatabase()
        ref?.child(databasePath1).child(databasePath2).setValue([key : value])
    }
}
