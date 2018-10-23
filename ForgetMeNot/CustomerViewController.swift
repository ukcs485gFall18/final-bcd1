//
//  CustomerViewController.swift
//  ForgetMeNot
//
//  Created by Cala, Robert on 10/23/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class CustomerViewController: UIViewController {


    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var upcoming: UISegmentedControl!
    @IBOutlet weak var completed: UISegmentedControl!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segControl.selectedSegmentIndex{
        case 0:
            upcoming.isHidden = false
            completed.isHidden = true
        case 1:
            upcoming.isHidden = true
            completed.isHidden = false
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
