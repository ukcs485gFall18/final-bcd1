//
//  Alert.swift
//  ForgetMeNot
//
//  Created by David Mercado on 10/27/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        /*DispatchQueue.main.async {*/ vc.present(alert, animated: true)//}
    }
    
    static func showConfirmReservationAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Confirmation", message: "Reservation Comfirmed. See you soon!")
    }
    
    static func showIncompleteFormAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Error", message: "Please enter a Party's Name, Date, and Time")
    }
    /*
    let alertController = UIAlertController(title: "Reservation", message: "Reservation Comfirmed for \(Name) on \(Date) at \(Time)", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)*/
    
}
