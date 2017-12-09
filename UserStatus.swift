//
//  UserStatus.swift
//  Pebl2
//
//  Created by Nick Florin on 1/19/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Foundation
import Firebase
import FirebaseDatabase


//////////////////////////////////////////////////////////////////////////////
class UserStatus : FIRDataObject{
    
    //////////////////
    // MARK: Properties
    var userID : String = ""
    var venueID : String = ""
    var eventComment : String = ""
    var eventTime : String = ""
    
    // List of Associated Venue IDs
    var favoritedVenues : [String] = []
    
    // To Attach a User Venue to the User Status Object
    var userVenue : Venue!
    
    // Initializer for this child class requires User Id
    init(userID: String,snapshot: FIRDataSnapshot) {
        self.userID = userID
        super.init(snapshot:snapshot)
    }
    //// Required initializer for parent class
    required init(snapshot: FIRDataSnapshot) {
        fatalError("init(snapshot:) has not been implemented")
    }
    
    /////////////////////////////////
    // Loads User Info Data
    func loadUserVenue( _ completion: @escaping (Bool)->()){
        
        print("Loading User Venue : Venue ID : \(self.venueID)")
        if self.venueID != "" {
            print(self.ref.parent?.parent)
            self.ref.parent?.parent?.child("venues").child(self.venueID).observeSingleEvent(of: .value, with: {snapshot in
                print(snapshot.value)
                print(self.venueID)
                
                print("User Venue Snapshot : \(snapshot)")
                print(snapshot.exists())
                
                if snapshot.exists(){
                    //self.userVenue = Venue(venueID: self.venueID, snapshot: snapshot)
                    completion(true)
                }
            })
        }
        else{
            fatalError("Error Loading User Venue : Missing Venue ID")
        }
    }
    
    // Sets new values of user's status and pushes data to Firebase
    func setNewStatus(venue:Venue,eventTime:String,eventComment:String,_ completion: @escaping (Bool)->()){
        
        self.eventTime = eventTime
        self.eventComment = eventComment
        self.userVenue = venue
        self.venueID = venue.id
        print("Updating Venue for New Status with ID : \(self.venueID)")
        
        if self.venueID != "" {
            let uploadData : [String:String] = ["venueID":self.venueID,"eventComment":eventComment,"eventTime":eventTime]
            ref.updateChildValues(uploadData)
            completion(true)
        }
        else{
            fatalError("Error Loading User Venue : Missing Venue ID")
        }
    }
}

