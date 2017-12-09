//
//  PeblModels.swift
//  Pebl
//
//  Created by Nick Florin on 10/29/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


////////////////////////////////////////
// DEPRECATED
class Event: NSObject {
    var userID: String?
    var eventDate : Date? // Need to Remove
    
    var event_name : String?
    var event_time : String?
    
    var eventMessage : String? // Need to Remove
    var eventImage : UIImage?
}

////////////////////////////////////////
class SuggestedEvent: NSObject {
    
    var userID: String?
    var event_name : String?
    var event_time : String?
    var eventMessage : String? // Need to Remove
    var eventImage : UIImage?
    
    ///////////////////////////////////////
    init(userID: String) {
        self.userID = userID
    }
    ///////////////////////////////////////
    convenience override init() {
        self.init(userID:  "")
    }
}


////////////////////////////////////////
class SuggestionPebl: NSObject {
    
    var userID: String?
    var peblDate : Date?
    var user : User?
    
    var daysRemaining : UInt32?
    var progress : Float?
    var daysAllowed : Int = 24
    
    var active : Bool?
    var viewed : Bool?
    
    var suggestedEvent : SuggestedEvent?
    
    ///////////////////////////////////////
    init(userID: String) {
        self.userID = userID
    }
    ///////////////////////////////////////
    convenience override init() {
        self.init(userID:  "")
    }
    ///////////////////////////////////////
    // Determines How Much Time Remaining for Match
    func determinePeblTiming(){
        
        // Determine Expiration Time Left
        if self.peblDate != nil{
            let calendar: Calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let start = calendar.startOfDay(for: self.peblDate! as Date)
            
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

////////////////////////////////////////
class MessagePebl: NSObject {

    var message : String?
    
    var userID: String?
    var peblDate : Date?
    var user : User?
    
    var daysRemaining : UInt32?
    var progress : Float?
    var daysAllowed : Int = 24
    
    var active : Bool?
    var viewed : Bool?
    
    ///////////////////////////////////////
    init(userID: String) {
        self.userID = userID
    }
    ///////////////////////////////////////
    convenience override init() {
        self.init(userID:  "")
    }
    ///////////////////////////////////////
    // Determines How Much Time Remaining for Match
    func determinePeblTiming(){
        
        // Determine Expiration Time Left
        if self.peblDate != nil{
            let calendar: Calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let start = calendar.startOfDay(for: self.peblDate! as Date)
            
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
