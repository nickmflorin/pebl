//
//  Match.swift
//  Pebl2
//
//  Created by Nick Florin on 1/16/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

////////////////////////////////////////
class Match : NSObject{
    
    var userID: String!
    var matchedUserID : String!
    var matchDate : Date!
    
    var user : User!
    
    var active : Bool!
    var viewed : Bool!
    
    var daysRemaining : UInt32?
    var progress : Float?
    var daysAllowed : Int = 24
    
    var eventUpdate : Bool = false
    var ref : FIRDatabaseReference!
    
    ///////////////////////////////////////
    init(userID: String,matchedUserID:String) {
        self.userID = userID
        self.matchedUserID = matchedUserID
        self.ref = nil
    }
    ///////////////////////////////////////
    init(userID:String, snapshot: FIRDataSnapshot) {
        
        self.userID = userID
        self.matchedUserID = snapshot.key
        self.ref = snapshot.ref
        super.init()
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        ///////////// Unwrap and Handle Matched Date
        if let matchDateString = snapshotValue["matchDate"] as? String{
            let matchDate = convert_string_to_nsdate(matchDateString)
            if let matchedDate = matchDate as? Date {
                self.matchDate = matchedDate
            }
        }
        else{
            fatalError("Match Date for Match with User : \(self.userID) and Matched User : \(self.matchedUserID) Missing")
        }
    
        ///////////// Unwrap and Handle Match Active
        if let active = snapshotValue["active"] as? Bool{
            self.active = active
        }
        else{
            fatalError("Active Flag for Match with User : \(self.userID) and Matched User : \(self.matchedUserID) Missing")
        }
        ///////////// Unwrap and Handle Match Viewed
        if let viewed = snapshotValue["viewed"] as? Bool{
            self.viewed = viewed
        }
        else{
            fatalError("Viewed Flag for Match with User : \(self.userID) and Matched User : \(self.matchedUserID) Missing")
        }
    }
    
    ///////////////////////////////////////
    // Determines How Much Time Remaining for Match
    func determineMatchTiming(){
        
        // Determine Expiration Time Left
        if self.matchDate != nil{
            let calendar: Calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let start = calendar.startOfDay(for: self.matchDate as Date)
            
            let flags = NSCalendar.Unit.day
            let components = (calendar as NSCalendar).components(flags, from: start, to: today, options: [])
            
            let daysRemaining = components.day
            let daysRemainingInt = UInt32(daysRemaining!)
            self.daysRemaining = daysRemainingInt
            
            let progress = 1.0 - Float(daysRemaining!)/Float(self.daysAllowed)
            self.progress = progress
        }
    }
}
