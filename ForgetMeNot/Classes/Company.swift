//
//  CompData.swift
//
//  Created by David Mercado on 11/29/18.
//

import Foundation
import Firebase

// Created Company model for retrieving data (Host)
class Company {
    fileprivate var companyName : String                        //Host's name
    fileprivate var companyID : String                          //Host's ID
    fileprivate var companyMajor : Int
    fileprivate var companyMinor : Int
    fileprivate var reservationList : [MyReservation]           //Host's list of Current Reservations
    fileprivate var completedReservationList : [MyReservation]       //Host's list of Past Reservations
    //var partyNames : [String]                       //Host's list of Party names
    
    init(){
        self.companyName = ""
        self.companyID = Auth.auth().currentUser!.uid
        self.companyMajor = 0
        self.companyMinor = 0
        self.reservationList = []
        self.completedReservationList = []
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
    func getMajor() -> Int{
        return companyMajor
    }
    func getMinor() -> Int{
        return companyMinor
    }
    
    //Reservation getters from reservationList
    func getNumOfReservations() -> Int {
        return reservationList.count
    }
    func getRes(pos: Int) -> MyReservation {
        if(reservationList.count == 0){
            let blankRes = MyReservation(date: kNANA, uuid: UUID(), CompName: kNA, name: kNA, size: 0)
            return blankRes
        }
        else{
            return reservationList[pos]
        }
    }
    func getReservationName(pos: Int) -> String {
        return reservationList[pos].getPartyName()
    }
    func getReservationSize(pos: Int) -> Int {
        return reservationList[pos].getPartySize()
    }
    func getReservationDate(pos: Int) -> String {
        return reservationList[pos].getDate()
    }
    func getReservationUUID(pos: Int) -> UUID {
        return reservationList[pos].getUUID()
    }
    func getReservationStatus(customerRes: MyReservation) -> Bool {
        return customerRes.getCheckInStatus()
    }
    func getReservationName(customerRes: MyReservation) -> Int {
        return customerRes.getPartySize()
    }
    func printAll(){
        for res in reservationList{
            print("reservation: \(res)")
            print("    pResUUID: \(res.getUUID())")
            print("    pDate: \(res.getDate())")
            print("    pName \(res.getPartyName())")
            print("    pSize: \(res.getPartySize())")
        }
    }
    
    //Reservation getters from completedReservationList
    func getNumOfResFromCompletedList() -> Int {
        return completedReservationList.count
    }
    func getCompletedRes(pos: Int) -> MyReservation {
        if(completedReservationList.count == 0){
            let blankRes = MyReservation(date: kNANA, uuid: UUID(), CompName: kNA, name: kNA, size: 0)
            return blankRes
        }
        else{
            return completedReservationList[pos]
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
    func setCompanyMajorAndMinor(name: String){
        //var NAME = name.uppercased()
        //var firstChar = NAME.prefix(1)
        //var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        //var pos = alphabet.firstIndex(of: firstChar)
        self.companyMajor = 0 //first letter of name
        self.companyMinor = 0 //second letter of name
    }
    
    //Reservation setters for reservationList
    func appendAndSortCompanyReservationList(customerRes: MyReservation){
        reservationList.append(customerRes)
        reservationList.sort(){$0.getDate() < $1.getDate()}
    }
    func removeFromCompanyReservationList(ItemUUid:UUID){
        for index in 0...(reservationList.count - 1){
            
            if(reservationList[index].getUUID() == ItemUUid){
                let transferRes = reservationList[index]
                appendAndSortCompanyCompletedReservationList(Res: transferRes)
                reservationList.remove(at: index)
                return
            }
        }
    }

    //Reservation setters for completedReservationList
    func updateCompanyCompletedReservationList(itemUUID: UUID) {
        removeFromCompanyReservationList(ItemUUid: itemUUID)
    }
    func appendAndSortCompanyCompletedReservationList(Res: MyReservation){
        completedReservationList.append(Res)
        completedReservationList.sort(){$0.getDate() > $1.getDate()}
    }
    
    /*====================================================
    *               --ASync Functions--
    *               FireBase Functions
    *
    ====================================================*/
    
    //Function to populated it's own reservation list
    func populateSelf(completionClosure: @escaping () -> ()) {
        findMyName {
            self.pullReservations {
                completionClosure()
            }
        }
    }
    
    //Function used to find Company's name once signed in
    func findMyName(completionClosure: @escaping() -> ()) {
        
        // Create firebase reference and link to database
        let dataRef = Database.database().reference()
        
        //Call firebase and start looking for the Company's name via its ID
        dataRef.child(kUserList).observe(.value) { (datasnapshot) in
            guard let usersnapshot = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in usersnapshot {
                if (user.key == self.companyID){
                    let name = user.childSnapshot(forPath: kCompanyName).value as! String
                    //print("host name: \(name)")                           //DEBUGGING PURPOSES
                    self.companyName = name
                    self.setCompanyMajorAndMinor(name: name)
                }
            }
            completionClosure()
        }
    }
    
    func pullReservations(completionClosure: @escaping() -> ()){
        //print("inside of pullRes: ")
        //print("name: \(self.companyName)")
        //print("id: \(self.companyID)")
        let dataRef = Database.database().reference()
        
        dataRef.child(kCompanyList).observe(.value) { (datasnapshot) in
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
                        
                        if(reservation.key != kCompanyUserID){
                            // Store variables as a dictionary
                            let partyValues = reservation.value as! [String:Any]
                            
                            //print("partyValues: \(partyValues)")
                            // Dictionary containing each value pair of res
                            
                            // Collect variables from database
                            let currResUUID_Str = reservation.key
                            let currResUUID = UUID(uuidString: currResUUID_Str)!
                            let currResDate = partyValues[kPartyDate] as! String
                            let currResName = partyValues[kPartyName] as! String
                            let currResSize = partyValues[kPartySize] as! Int
                            
                            //print("UUID_Str: \(currResUUID_Str)")                           //DEBUGGING PURPOSES
                            //print("currResDate: \(currResDate)")                            //DEBUGGING PURPOSES
                            //print("currResName: \(currResName)")                            //DEBUGGING PURPOSES
                            //print("currResSize: \(currResSize)")                            //DEBUGGING PURPOSES
                            
                            //Convert data into a MyReservation NSObject
                            let currRes = MyReservation(date: currResDate, uuid: currResUUID, CompName: self.getName(), name: currResName, size: currResSize)
                            
                            //Add the reservation to the Company's list
                            self.appendAndSortCompanyReservationList(customerRes: currRes)
                        }
                    }
                }
            }
            completionClosure()
        }
    }
    
   /*
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
            //self.printTEST()
            //DispatchQueue.main.async(execute: {
                self.populateSelf()
            //})
        }
        
    }
     
     //Function used to find Company ID once signed in
     //Reference: https://firebase.google.com/docs/auth/ios/manage-users
     func whoAmI() {
     let user = Auth.auth().currentUser
     if let user = user {
     let uid = user.uid
     //print("company UUID: \(uid)")                                       //DEBUGGING PURPOSES
     setCompanyID(id: uid)
     }
     
     //DispatchQueue.main.async(execute: {
     //self.findMyName()})
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
                        self.appendAndSortCompanyReservationList(customerRes: currRes)
                    }
                }
            }
            //self.printAll()
        }
    }
    */
}
