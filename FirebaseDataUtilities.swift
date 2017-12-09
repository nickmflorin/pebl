//
//  FirebaseDataUtilities.swift
//  Pebl2
//
//  Created by Nick Florin on 3/5/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import CoreLocation


func simulate(){
    generateFakePins()
}






////////////////////////////////////////////////////////////////////////////////////////////////////////
// Assigns Fake Matches to the Primary Authenticated User by Randomly Selecting from the Fake User IDS
func generateFakeMatches(){
    
    let numMatches = 12
    
    // Get Current User UID from Firebase Auth
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    // Get All User IDS:
    var userIds : [String] = []
    let group = DispatchGroup()
    
    group.enter()
    Firebase.ref.child(User.endpoint).observeSingleEvent(of: .value, with: {snapshot in
        for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
            let user = User(snapshot:child)
            userIds.append(user.id)
        }
        group.leave()
    })
    // All Groups Finished - Randomly Select
    group.notify(queue: DispatchQueue.main, execute: {
        
        // Delete Matches First
        User(userID: userID!).ref.child("matches").removeValue()
        
        for _ in 0...numMatches {
            let randomIndex = Int(arc4random_uniform(UInt32(userIds.count)))
            let randomUID = userIds[randomIndex]
            
            var matchData : [String:AnyObject] = [:]
            matchData = ["userID":randomUID as AnyObject,"createdDate":generateRandomDate() as AnyObject]
            print("Adding Match for User : \(userID)")
            User(userID: userID!).ref.child("matches").childByAutoId().setValue(matchData)
        }
    })
}
//////////////////////////////////////////////////
// Generates Fake Pins for Other Users in Database as Well As the Logged In User
func generateFakePins(){
    
    let numPinsPerOtherUser : Int = 5
    let numPinsPerPrimaryUser : Int = 10
    
    let group = DispatchGroup()
    
    // Search for Venues in Area to Get IDs for Pins
    let locationManager = CLLocationManager() // Initialize Location Manager
    
    let currentLocation = locationManager.location
    let lattitude = CGFloat(Float((currentLocation?.coordinate.latitude)!))
    let longitude = CGFloat(Float((currentLocation?.coordinate.longitude)!))
    
    let query = FourSquareQuery()
    var venues : [Venue] = []
    query.lattitude = lattitude
    query.longitude = longitude
    
    var test : [String:String] = [:]
    group.enter()
    query.search({result in
        if result.value != nil {
            venues = result.value!
            
            for venue in venues {
                test[venue.id]=venue.name!
            }
            group.leave()
        }
    })
    
    // All Groups Finished - Get User IDS in Firebase and Add Pins for Each
    group.notify(queue: DispatchQueue.main, execute: {
        
        // Get All User IDS: - Take Pins for All Other Users in DB
        Firebase.ref.child(User.endpoint).observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                
                let user = User(snapshot:child)
                User(userID: user.id).ref.child("pins").removeValue() // Delete Current Pins
                for _ in 0...numPinsPerOtherUser {
                    
                    // Randomly Select Venue from List
                    let randomIndex = Int(arc4random_uniform(UInt32(venues.count)))
                    let randomVenue = venues[randomIndex]
                    let newPin = UserPin(userID: user.userID, venueID: randomVenue.id, createdDate: generateRandomDate())
                    newPin.ref.childByAutoId().setValue(newPin.dict)
                }
                
            }
        })
        
        // Get Current User UID from Firebase Auth
        let userID = FIRAuth.auth()?.currentUser?.uid
        User(userID: userID!).ref.child("pins").removeValue() // Delete Current Pins
        
        for _ in 0...numPinsPerPrimaryUser {
            
            // Randomly Select Venue from List
            let randomIndex = Int(arc4random_uniform(UInt32(venues.count)))
            let randomVenue = venues[randomIndex]
            let newPin = UserPin(userID: userID!, venueID: randomVenue.id, createdDate: generateRandomDate())
            newPin.ref.childByAutoId().setValue(newPin.dict)
        }
    })

    
}
