//
//  Firebase.swift
//  Pebl2
//
//  Created by Nick Florin on 1/27/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Firebase

let FirebaseUrl = "https://pebl-246f9.firebaseio.com/"

class Firebase {
    static var ref : FIRDatabaseReference = FIRDatabase.database().reference()
    static var FirebaseUrl = "https://pebl-246f9.firebaseio.com/"
}

protocol DictionaryConvertible {
    init?(dict:[String:AnyObject])
    var dict:[String:AnyObject] { get }
}
class FIRDataObject: NSObject {
    
    let snapshot: FIRDataSnapshot
    var key: String { return snapshot.key }
    var ref: FIRDatabaseReference { return snapshot.ref }
    
    required init(snapshot: FIRDataSnapshot) {
        
        self.snapshot = snapshot
        
        super.init()
        
        for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
            if responds(to: Selector(child.key)) {
                setValue(child.value, forKey: child.key)
            }
        }
    }
}

// Model refers to all data models that reference a specific endpoint for a
// user based on the User ID.  This represents a ChildbyAutoID Child of a Specific Endpoint
class FIRUserDataModel: NSObject {
    
    var userID : String!
    var endpoint : String!
    var snapshot: FIRDataSnapshot!
    var key: String!
    var ref : FIRDatabaseReference!
    var id : String!
    
    // Initialization from User ID and Endpoint Name - Won't Have ID This Way - ID is Child by Auto ID
    init(userID:String, endpoint: String) {
        
        self.userID = userID
        self.endpoint = endpoint
        
        // Establish Reference Endpoint
        self.ref = Firebase.ref.child(User.endpoint).child(self.userID).child(self.endpoint)
        super.init()
    }
    // Initialization from Snapshot
    init(snapshot: FIRDataSnapshot) {
        
        self.snapshot = snapshot
        self.userID = snapshot.key
        
        self.ref = self.snapshot.ref
        self.key = snapshot.key
        self.id = snapshot.key
        
        super.init()
        
        // Store Data from Snapshot
        for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
            if responds(to: Selector(child.key)) {
                setValue(child.value, forKey: child.key)
            }
        }
    }
    
    // Gets snapshot at endpoint.
    func retrieveSnapshot(){
        
        
        
    }
}

protocol FIRDatabaseReferenceable {
    var ref: FIRDatabaseReference { get }
}

extension FIRDatabaseReferenceable {
    var ref: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
}
