//
//  User.swift
//  Pebl2
//
//  Created by Nick Florin on 3/6/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import Cloudinary

////////////////////////////////////////
// Object Reperesents User Data for Other Users
class User : FIRUserDataModel {
    
    var createdDate : String!
    var email : String!
    var userName : String!
    
    // Model Objects Attributed
    var userInfo : UserInfo!
    var userPins : UserPins!
    var userStatus : UserStatus!
    var userMatches : UserMatches!
    
    static var endpoint : String = "users"
    
    // Init with User ID
    init(userID: String) {
        // Reference Retrieved when Initializing Super Object
        super.init(userID: userID, endpoint: User.endpoint)
        self.ref = Firebase.ref.child(User.endpoint).child(self.userID)
    }
    
    // Init with Snapshot
    override init(snapshot: FIRDataSnapshot) {
        // Reference Retrieved when Initializing Super Object
        super.init(snapshot: snapshot)
        self.userID = snapshot.key
    }
    
    // To Do: Maybe we want to associate the retrieved values with the user object 
    // as well.
    
    // Gets User Info and Returns Object - Stores User Info Object to User
    func getInfo(_ completionHandler: @escaping (UserInfo) -> Void) {
        
        // To DO: Include Error/Result Wrapping for Completion Handler Results
        self.ref.child(UserInfo.endpoint).observeSingleEvent(of: .value, with: {snapshot in
            let userInfo = UserInfo(snapshot: snapshot)
            self.userInfo = userInfo
            completionHandler(userInfo)
        })
    }

    
    // Gets Pins for User and Returns as List
    func getPins(_ completionHandler: @escaping (UserPins?) -> Void) {
        
        // To DO: Include Error/Result Wrapping for Completion Handler Results
        self.ref.child(UserPins.endpoint).observeSingleEvent(of: .value, with: {snapshot in
            // Need to handle here situation in which the snapshot was not there.
            if snapshot.exists() {
                let userPins = UserPins(snapshot:snapshot)
                self.userPins = userPins
                completionHandler(userPins)
            }
            // Snapshot Doesn't Exist
            completionHandler(nil)
        })
    }
    
    // Gets Matches Associated with User
    func getMatches(_ completionHandler: @escaping (UserMatches) -> Void) {
        
        // To DO: Include Error/Result Wrapping for Completion Handler Results
        self.ref.child(UserMatches.endpoint).observeSingleEvent(of: .value, with: {snapshot in
            let userMatches = UserMatches(snapshot: snapshot)
            self.userMatches = userMatches
            completionHandler(userMatches)
        })
    }
    
    // Retrieve Dictionary Representation of Model
    var dict:[String:AnyObject] {
        return [
            "userID": self.userID as AnyObject,
            "email": email as AnyObject,
            "userName": userName as AnyObject,
            "createdDate": createdDate as AnyObject
        ]
    }
    
}
