//
//  Matches.swift
//  Pebl2
//
//  Created by Nick Florin on 3/6/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import Cloudinary

//////////////////////////////////////////
//// Object Reperesents User Data for Other Users
class UserMatches : FIRUserDataModel {
    
    var matches : [UserMatch]!
    static var endpoint : String = "matches"
    
    // Init with All Data
    init(userID: String) {
        super.init(userID:userID, endpoint:UserMatches.endpoint)
    }
    
    // Init with Snapshot
    override init(snapshot: FIRDataSnapshot) {
        
        // Reference Retrieved when Initializing Super Object
        super.init(snapshot: snapshot)
        
        // Snapshot Stored Single Value Variables, Not Pin Objects
        if snapshot.hasChildren(){
            self.matches = []
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let newMatch = UserMatch(snapshot: child)
                self.matches.append(newMatch)
            }
        }
    }
}

////////////////////////////////////////
// Object Reperesents User Data for Other Users
class UserMatch : NSObject {
    
    var userID : String!
    var matchedID : String!
    var createdDate : String!
    
    var snapshot: FIRDataSnapshot!
    var key: String!
    var ref : FIRDatabaseReference!
    
    // Init with AutoID of Pin, User ID and Pin Data
    init(userID: String, matchedID : String, createdDate : String) {
        super.init()
        
        self.userID = userID
        self.matchedID = matchedID
        self.createdDate = createdDate
    }
    
    // Initialization from Snapshot
    init(snapshot: FIRDataSnapshot) {
        
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
        
    }
    
    // Retrieve Dictionary Representation of Model
    var dict:[String:AnyObject] {
        return [
            "matchedID": matchedID as AnyObject,
            "createdDate": createdDate as AnyObject
        ]
    }

}
