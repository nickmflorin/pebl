//
//  Pins.swift
//  Pebl2
//
//  Created by Nick Florin on 3/6/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import Cloudinary
import AFDateHelper

//////////////////////////////////////////
//// Object Reperesents User Data for Other Users
class UserPins : FIRUserDataModel {

    var pins : [UserPin]!
    static var endpoint : String = "pins"
    
    // Init with All Data
    init(userID: String) {
        super.init(userID:userID, endpoint: UserPins.endpoint)
    }
    
    // Init with Snapshot
    override init(snapshot: FIRDataSnapshot) {
        
        // Reference Retrieved when Initializing Super Object
        super.init(snapshot: snapshot)
        
        // Snapshot Stored Single Value Variables, Not Pin Objects
        if snapshot.hasChildren(){
            self.pins = []
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let newPin = UserPin(userID: self.userID, snapshot: child)
                self.pins.append(newPin)
            }
        }
    }
}

////////////////////////////////////////
// Object Reperesents User Data for Other Users
class UserPin : NSObject {
    
    var userID : String!
    var venueID : String!
    var createdDate : String!
    var createdDateDate : Date!
    var formattedCreatedDate : String!
    
    var snapshot: FIRDataSnapshot!
    var key: String!
    var ref : FIRDatabaseReference!
    
    // Venue data associated with pin
    var venue : Venue!
    
    // Init with AutoID of Pin, User ID and Pin Data
    init(userID: String, venueID : String, createdDate : String) {
        
        // Initializes Specific Reference Point
        super.init()
        self.userID = userID
        self.venueID = venueID
        self.createdDate = createdDate
        
        self.createdDateDate = Date(fromString: self.createdDate, format: .isoDate)
        self.formattedCreatedDate = self.createdDateDate.toString(format: .custom("MMM d"))
        
        // This ref only represents the reference for all of the pins - additional reference
        // must be created by Auto ID or Current ID from Snapshot
        self.ref = Firebase.ref.child("users").child(self.userID).child(UserPins.endpoint)
    }
    // Init with Actual Date Object
    init(userID: String, venueID : String, createdDateDate : Date) {
        
        // Initializes Specific Reference Point
        super.init()
        self.userID = userID
        self.venueID = venueID
        self.createdDateDate = createdDateDate
        self.formattedCreatedDate = self.createdDateDate.toString(format: .custom("MMM d"))
        
        // This ref only represents the reference for all of the pins - additional reference
        // must be created by Auto ID or Current ID from Snapshot
        self.ref = Firebase.ref.child("users").child(self.userID).child(UserPins.endpoint)
    }
    
    // Initialization from Snapshot
    init(userID: String, snapshot: FIRDataSnapshot) {
        
        self.userID = userID
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.snapshot = snapshot
        super.init()
        
        // Store Data from Snapshot if Snapshot Was Used to Initialize in Child
        for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
            if responds(to: Selector(child.key)) {
                setValue(child.value, forKey: child.key)
            }
        }
        // Initialize Date Object
        if self.createdDate != nil {
            self.createdDateDate = Date(fromString: self.createdDate, format: .isoDate)
            self.formattedCreatedDate = self.createdDateDate.toString(format: .custom("MMM d"))
        }
    }
    
    // Retrieve Dictionary Representation of Model
    var dict:[String:AnyObject] {
        return [
            "venueID": venueID as AnyObject,
            "createdDate": createdDate as AnyObject
        ]
    }
    
}

