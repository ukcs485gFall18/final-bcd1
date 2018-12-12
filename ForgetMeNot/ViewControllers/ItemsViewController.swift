/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreLocation

class ItemsViewController: UIViewController {
    var myCompany = Company()
    var items = [Item]()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var browserSegment: UISegmentedControl!
    
    //Used for the Segment Control
    @IBAction func browserSegmentChange(_ sender: Any) {
        switch browserSegment.selectedSegmentIndex {
        case 1: //This is the 'Completed' browser
            print("Reloading Completed SegmentedControl")
            tableView.reloadData()
        default:
            //This is the 'UpComming' browser
            print("Reloading UpComming SegmentedControl")
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        tableView.delegate = self
        tableView.dataSource = self
        
        //call function to populate the host
        myCompany.populateSelf(){
            self.titleBar.title = "Welcome \(self.myCompany.getName())"
            //self.myCompany.printAll()
            
            if(self.myCompany.getNumOfReservations() != 0){
                //turn reservations into iBeacons
                for index in 0...(self.myCompany.getNumOfReservations() - 1){
                    let resDate = self.myCompany.getReservationDate(pos: index)
                    let resName = self.myCompany.getReservationName(pos: index)
                    let resSize = self.myCompany.getReservationSize(pos: index)
                    let resUUID = self.myCompany.getReservationUUID(pos: index)
                    let resMajor = self.myCompany.getMajor()
                    let resMinor = self.myCompany.getMinor()
                    
                    let newItem = Item(date: resDate, name: resName, size: resSize, uuid: resUUID, majorValue: resMajor, minorValue: resMinor)
                    self.addBeacon(index: index, item: newItem)
                }
            }
            else{
                print("No current reservations")
            }
        }
        
        //cleanItems()
        //loadItems()
    }

    /*

    override func viewWillAppear(_ animated: Bool) {
        print("now i will reload")
        loadItems()
        //tableView.reloadData()
    }
    */
    
    /*
    //David Mercado added this
    @IBAction func calendarButtonTapped(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "calshow://")! as URL)
    }*/
    
    //--------------------------------------------------------------------------
    //Function used to load 'Item' from userDefaults.standard.array(forKey: storedItems)
    func loadItems() {
        print("Loading Items!")
        guard let storedItems = UserDefaults.standard.array(forKey: kStoredItemsKey) as? [Data] else {
            print("No Stored Data!")
            return
        }
        print("storedItems: \(storedItems)")        //DEBUGGING PURPOSES
        
        for itemData in storedItems {
            print("itemData: \(itemData)")          //DEBUGGING PURPOSES
            guard let item = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? Item else { continue }
            
            print("item: \(item)")          //DEBUGGING PURPOSES
            items.append(item)
            startMonitoringItem(item)
        }
    }
    //--------------------------------------------------------------------------
    //Function used to store 'Item' data into userDefaults.standard.array(forKey: storedItems)
    func persistItems() {
        print("Storing Item!")
        var itemsData = [Data]()
        for item in items {
            let itemData = NSKeyedArchiver.archivedData(withRootObject: item)
            itemsData.append(itemData)
        }
        UserDefaults.standard.set(itemsData, forKey: kStoredItemsKey)
        UserDefaults.standard.synchronize()
    }
    
    //--------------------------------------------------------------------------
    //Function used to clean 'Item' data from userDefaults.standard.array(forKey: storedItems)
    /*func cleanItems(){
        print("Cleaning Items!")
        UserDefaults.standard.removeObject(forKey: kStoredItemsKey)
        UserDefaults.standard.synchronize()
        loadItems()
    }*/

    //--------------------------------------------------------------------------
    func startMonitoringItem(_ item: Item) {
        let beaconRegion = item.asBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
  
    //--------------------------------------------------------------------------
    func stopMonitoringItem(_ item: Item) {
        let beaconRegion = item.asBeaconRegion()
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
  
    //--------------------------------------------------------------------------
    //This is the Add Item button
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSeagueReservations, let viewController = segue.destination as? ReservationsViewController{
                viewController.delegate = self
            }
        
        //if segue.identifier == "segueAdd", let viewController = segue.destination as? AddItemViewController {
         //viewController.delegate = self
         //}
    }*/
}

//==============================================================================
// MARK: To add an iBeacon to the 'Item'
extension ItemsViewController: AddBeacon {
    func addBeacon(index: Int, item: Item) {
        print("adding Item \(index): \(item.getItemName())")            //DEBUGGING PURPOSES
        items.append(item)
    
        tableView.beginUpdates()
        let newIndexPath = IndexPath(row: items.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.endUpdates()
    
        startMonitoringItem(item)
        persistItems()
    }
}

//==============================================================================
// MARK: UITableViewDataSource
extension ItemsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch browserSegment.selectedSegmentIndex {
    
        //Returns number of reservations from completedReservationList in myCompany
        case 1:
            //print("Completed num of rows: \(myCompany.getNumOfResFromCompletedList())")
            if(myCompany.getNumOfResFromCompletedList() == 0){
                return 1
            }
            else{
                return myCompany.getNumOfResFromCompletedList()
            }
        
        //Returns number of reservations from items array
        default:
            //print("UpComming num of rows: \(items.count)")
            return items.count
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellUpComming:UpCommingItemTableViewCell?       //init for cell shown under 'UpComming'
        let cellCompleted:CompletedItemTableViewCell?       //init for cell shown under 'Completed'
    
        #warning("FIXME: when no reservations this breaks need a defualt cells 'No Reservations'")
        switch browserSegment.selectedSegmentIndex {
    
        //Modify cell for 'Completed'
        case 1:
            print("Completed Cell mod")
            cellUpComming = nil
            cellCompleted = tableView.dequeueReusableCell(withIdentifier: kCompletedItemID, for: indexPath) as? CompletedItemTableViewCell

            cellCompleted?.modCompletedCell(res: myCompany.getCompletedRes(pos: indexPath.row))
            return cellCompleted!
    
        //Modify cell for 'UpComming'
        default:
            print("UpComming Cell mod")
            cellCompleted = nil
            cellUpComming = tableView.dequeueReusableCell(withIdentifier: kUpCommingItemID, for: indexPath) as? UpCommingItemTableViewCell

            cellUpComming?.item = items[indexPath.row]

            return cellUpComming!
        }
        /*
         let cell = tableView.dequeueReusableCell(withIdentifier: kUpCommingItemID, for: indexPath) as! UpCommingItemTableViewCell
         cell.item = items[indexPath.row]
         print("cell item?: \(items[indexPath.row])")            //DEBUGGING PURPOSES
         return cell*/
    }
  
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch browserSegment.selectedSegmentIndex {
        case 1:
            #warning("FIXME: make sure to remove delete option")
            if editingStyle == .none {
                print("No deleting here!")
            }
        default:
            if editingStyle == .delete {
                stopMonitoringItem(items[indexPath.row])
      
                //storing into Company completed list
                let ItemUUID = items[indexPath.row].getItemUUID()
                myCompany.updateCompanyCompletedReservationList(itemUUID: ItemUUID)
            
                //removal from 'Upcomming'
                tableView.beginUpdates()
                items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
      
                persistItems()
            }
        }
    }
}

//==============================================================================
// MARK: UITableViewDelegate
extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        //switch browserSegment.selectedSegmentIndex {
        //case 1:
            
        //default:
            let item = items[indexPath.row]
            let detailMessage = "UUID: \(item.uuid.uuidString)\nMajor: \(item.majorValue)\nMinor: \(item.minorValue)"
            
            let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .alert)
            detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(detailAlert, animated: true, completion: nil)
        //}
    }
}

//==============================================================================
// MARK: CLLocationManagerDelegate
extension ItemsViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    print("Failed monitoring region: \(error.localizedDescription)")
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location manager failed: \(error.localizedDescription)")
  }
  
  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    
    // Find the same beacons in the table.
    var indexPaths = [IndexPath]()
    for beacon in beacons {
      for row in 0..<items.count {
        if items[row] == beacon {
          items[row].beacon = beacon
          indexPaths += [IndexPath(row: row, section: 0)]
            
            // Blake Sweet's Beacon detection range
            // Citation: https://developer.apple.com/documentation/corelocation/determining_the_proximity_to_an_ibeacon
            // Output if found beacon
            let nearestBeacon = beacons.first!
            let major = CLBeaconMajorValue(truncating: nearestBeacon.major)
            let minor = CLBeaconMinorValue(truncating: nearestBeacon.minor)
            switch nearestBeacon.proximity {
                case .near, .immediate:
                    print ("Checked in ✅ with: \nUUID: \(nearestBeacon.proximityUUID) \nMajor: \(major)\nMinor: \(minor)\n")
                    break
                default:
                    print("iBeacon out of range!")
                    break
            }
        }
      }
    }
    
    // Update beacon locations of visible rows.
    if let visibleRows = tableView.indexPathsForVisibleRows {
      let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
      for row in rowsToUpdate {
        let cell = tableView.cellForRow(at: row) as! UpCommingItemTableViewCell
        cell.refreshLocation()
      }
    }
    
    // Update Check-in Status : Blake
    if let visibleRows = tableView.indexPathsForVisibleRows {
        let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
        for row in rowsToUpdate {
            let cell = tableView.cellForRow(at: row) as! UpCommingItemTableViewCell
            cell.checkedIn()
        }
    }
  }
}
