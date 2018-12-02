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


/*  ==========================
 *
 *       Animations
 *
    ========================== */



// Button animations
extension UIButton{
    func spin(){
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 2.0)
        }, completion: nil)
    }
    
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
