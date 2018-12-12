//
//  BroadcastViewController.swift
//  ForgetMeNot
//
//  Created by Blake Sweet on 12/12/18.
//
// Citation: https://stackoverflow.com/questions/49303785/how-to-advertise-an-ibeacon-using-an-ipad-5-in-swift-4

import UIKit
import CoreLocation
import CoreBluetooth

class BroadcasterViewController: UIViewController, CBPeripheralManagerDelegate {
    
    var myBeacon: CLBeaconRegion!
    var beaconData: NSDictionary!
    var peripheralMgr: CBPeripheralManager!
    let myRegionID = "myRegionID"
    let backgroundImageView = UIImageView()
    
    // Carried from previous view
    var broadcastCustomer : Users = Users(email: "", userType: "")
    var broadcastCellNum : Int = 0
    
    override func viewDidLoad() {
        setBackground()
    }
    
    @IBAction func startBeacon(_ sender: Any) {
        (sender as! UIButton).pulsate() // Animate button when pressed
        
        print ("Broadcasting")
        print ("UUID: \(broadcastCustomer.reservationList[broadcastCellNum].getUUIDString())")
        print ("Index: \(broadcastCellNum)")
        
        guard myBeacon == nil else { return } // don't do anything if myBeacon already exists
        
        let beaconUUID = broadcastCustomer.reservationList[broadcastCellNum].getUUIDString()
        let beaconMajor: CLBeaconMajorValue = 123
        let beaconMinor: CLBeaconMinorValue = 456
        
        let uuid = UUID(uuidString: beaconUUID)!
        myBeacon = CLBeaconRegion(proximityUUID: uuid, major: beaconMajor, minor: beaconMinor, identifier: "MyIdentifier")
        
        beaconData = myBeacon.peripheralData(withMeasuredPower: nil)
        peripheralMgr = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
    }
    
    @IBAction func stopBeacon(_ sender: Any) {
        (sender as! UIButton).shake() // Animate button when pressed
        
        print ("stopped Broadcasting")
        // don't do anything if there's no peripheral manager
        guard peripheralMgr != nil else { return }
        
        peripheralMgr.stopAdvertising()
        peripheralMgr = nil
        beaconData = nil
        myBeacon = nil
        
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralMgr.startAdvertising(beaconData as! [String: AnyObject]!)
        } else if peripheral.state == .poweredOff {
            peripheralMgr.stopAdvertising()
        }
    }
    
    func setBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.image = UIImage(named: kBgWave)
        view.sendSubviewToBack(backgroundImageView)
    }
    
}
