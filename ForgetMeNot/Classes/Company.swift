//
//  CompData.swift
//
//  Created by David Mercado on 11/29/18.
//

import Foundation
import Firebase

// Created Company model for retrieving data (Host)
class Company/*: NSObject*/{
    
    //Local Variables
    var companyName : String                        //Host's name
    var companyID : String                          //Host's ID
    var reservationList : [MyReservation]           //Host's list of Current Reservations
    var prevReservationList : [MyReservation]       //Host's list of Past Reservations
    //var partyNames : [String]                       //Host's list of Party names
    
    init (){
        companyName = ""
        companyID = ""
        reservationList = []
        prevReservationList = []
        //self.partyNames = []
        //super.init()
    }
    
    /* ===================================================
     *              "Get" Functions
     *  Returns private variables for use outside the function
     *  but prevents modification.
     * ===================================================
     */
    //Company getters
    func getName() -> String {
        return companyName
    }
    func getID() -> String {
        return companyID
    }
    func printTEST() {
        print("Host name: \(self.getName())")
        print("Host ID: \(self.getID())")
    }
    
    //Reservation getters
    func getReservationDate(customerRes: MyReservation) -> String {
        return customerRes.getDate()
    }
    func getReservationUUID(customerRes: MyReservation) -> UUID {
        return customerRes.getUUID()
    }
    func getReservationStatus(customerRes: MyReservation) -> Bool {
        return customerRes.getCheckInStatus()
    }
    func getReservationName(customerRes: MyReservation) -> String {
        return customerRes.getPartyName()
    }
    func getReservationName(customerRes: MyReservation) -> Int {
        return customerRes.getPartySize()
    }
    func printAll(){
        for res in reservationList{
            print(res.getUUID())
            print(res.getDate())
            print(res.getPartyName())
            print(res.getPartySize())
        }
    }
    
    /* ===================================================
     *              "Set" Functions
     *  Modify a variable from outside of the class
     * ===================================================
     */
    //Company setters
    func setCompanyName(n: String){
        companyName = n
    }
    func setCompanyID(id: String) {
        companyID = id
    }
    func appendReservation(customerRes: MyReservation){
        reservationList.append(customerRes)
        sortReservation()
    }
    func removeReservation(customerRes: MyReservation){
        let pos = searchReservation(date: customerRes.getDate(), name: customerRes.getPartyName())
        reservationList.remove(at: pos)
    }
    func searchReservation(date: String, name: String) -> Int{
        //search for reservation
        return 0
    }
    func sortReservation(){
        //sort reservations by date time
    }
    
    /*====================================================
    *               FireBase Functions
    *
    ====================================================*/
    //Function used to find Company ID once signed in
    //Reference: https://firebase.google.com/docs/auth/ios/manage-users
    func whoAmI() {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            //print("company UUID: \(uid)")                                       //DEBUGGING PURPOSES
            setCompanyID(id: uid)
        }
        findMyName()
    }
    
    //Function used to find Company's name once signed in
    func findMyName() {
        // Create firebase reference and link to database
        let dataRef = Database.database().reference()
        
        //Call firebase and start looking for the Company's name via its ID
        dataRef.child("userList").observe(.value) { (datasnapshot) in
            guard let usersnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in usersnapshot {
                if (user.key == self.getID()){
                    let name = user.childSnapshot(forPath: "name").value as! String
                    //print("host name: \(name)")                                            //DEBUGGING PURPOSES
                    self.setCompanyName(n: name)
                    //break??
                 }
            }
            self.printTEST()
            self.populateSelf()
        }
        
    }
    
    //Function to populated it's own reservation list
    func populateSelf() {
        let dataRef = Database.database().reference()
        
        dataRef.child("companyList").observe(.value) { (datasnapshot) in
            guard let partySnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            //print("SnapShot: \(partySnapshot)")                                     //DEBUGGING PURPOSES
            
            //iterate through the Company's reservation table
            for currParty in partySnapshot{
                
                if(self.getName() == currParty.key){
                    guard let reservations = currParty.value as? [String:Any] else{
                        return
                    }
                    //print("currParty: \(currParty.key)")                                //DEBUGGING PURPOSES
                    //print("reservations: \(reservations)")                              //DEBUGGING PURPOSES
                    
                    // Each reservation referenced inside loop
                    for reservation in reservations{
                        //print("reservation: \(reservation)")                            //DEBUGGING PURPOSES
                        
                        // Store variables as a dictionary
                        let partyValues = reservation.value as! [String:Any]
                        
                        //print("partyValues: \(partyValues)")
                           // Dictionary containing each value pair of res
     
                        // Collect variables from database
                        let currResUUID_Str = reservation.key
                        let currResUUID = UUID(uuidString: currResUUID_Str)!
                        let currResDate = partyValues["PartyDate"] as! String
                        let currResName = partyValues["PartyName"] as! String
                        let currResSize = partyValues["PartySize"] as! Int
                        
                        //print("UUID_Str: \(currResUUID_Str)")                           //DEBUGGING PURPOSES
                        //print("currResDate: \(currResDate)")                            //DEBUGGING PURPOSES
                        //print("currResName: \(currResName)")                            //DEBUGGING PURPOSES
                        //print("currResSize: \(currResSize)")                            //DEBUGGING PURPOSES
                        
                        //Convert data into a MyReservation NSObject
                        let currRes = MyReservation(date: currResDate, uuid: currResUUID, CompName: self.getName(), name: currResName, size: currResSize)
                        
                        //Add the reservation to the Company's list
                        self.appendReservation(customerRes: currRes)
                    }
                }
            }
            self.printAll()
        }
    }
}
