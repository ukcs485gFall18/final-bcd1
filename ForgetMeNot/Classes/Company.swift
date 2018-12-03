//
//  CompData.swift
//
//  Created by David Mercado on 11/29/18.
//

import Foundation

// Created Company model for retrieving data (Host)
class Company/*: NSObject*/{
    
    //Local Variables
    var companyName : String                        //Host's name
    var companyID : String                          //Host's ID
    var reservationList : [MyReservation]           //Host's list of Current Reservations
    var prevReservationList : [MyReservation]       //Host's list of Past Reservations
    //var partyNames : [String]                       //Host's list of Party names
    
    init (cName: String, ID: String){
        companyName = cName
        companyID = ID
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
            print(res)
        }
    }
    
    /* ===================================================
     *              "Set" Functions
     *  Modify a variable from outside of the class
     * ===================================================
     */
    
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
}

