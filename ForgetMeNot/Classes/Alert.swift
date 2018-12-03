//  Alert.swift
//
//  Created by David Mercado on 10/27/18.
//

import Foundation
import UIKit

//struct for easier display of alerts
struct Alert {
    
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        /*DispatchQueue.main.async {*/ vc.present(alert, animated: true)//}
    }
    
    //Message for Error in making a reservation
    static func showIncompleteFormAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Error", message: "Please enter the Party's Name, Resturant Name, Party's Size, Date, and Time")
    }
    
    //Message for confirmation of reservation
    static func showConfirmReservationAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Confirmation", message: "Reservation Comfirmed. See you soon!")
    }
    
    //Message for Error in Finding Company
    static func showCompanyErrorAlert(on vc: UIViewController){
        showBasicAlert(on: vc, with: "Error", message: "There is a problem with your Company Account. Please contact Support!")
    }
    /*
    let alertController = UIAlertController(title: "Reservation", message: "Reservation Comfirmed for \(Name) on \(Date) at \(Time)", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)*/
    
}
