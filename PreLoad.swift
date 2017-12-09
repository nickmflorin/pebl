//
//  PreLoad.swift
//  Pebl2
//
//  Created by Nick Florin on 3/9/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import CoreLocation

// Contains functions that download and setup data to prepare the app for user before the user is fully
// entered into the user environment.

struct PreLoad {
    
    static var numMatches = 12
    static var numPinsPerOtherUser : Int = 5
    static var numPinsPerPrimaryUser : Int = 10
    
    func preload(_ completionHandler: @escaping (Bool) -> Void){
        PreLoad.generateFakeMatches(completionHandler)
//        PreLoad.generateFakePins({finished in
//            PreLoad.generateFakeMatches(completionHandler)
//        })
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Assigns Fake Matches to the Primary Authenticated User by Randomly Selecting from the Fake User IDS
    static func generateFakeMatches(_ completionHandler: @escaping (Bool) -> Void){
        
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
            
            for _ in 0...PreLoad.numMatches {
                let randomIndex = Int(arc4random_uniform(UInt32(userIds.count)))
                let randomUID = userIds[randomIndex]
                
                var matchData : [String:AnyObject] = [:]
                matchData = ["userID":randomUID as AnyObject,"createdDate":generateRandomDate() as AnyObject]
                print("Adding Match for User : \(userID)")
                User(userID: userID!).ref.child("matches").childByAutoId().setValue(matchData)
            }
            completionHandler(true)
        })
    }
    //////////////////////////////////////////////////
    // Generates Fake Pins for Other Users in Database as Well As the Logged In User
    static func generateFakePins(_ completionHandler: @escaping (Bool) -> Void){
        
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
        
        let group = DispatchGroup()
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
            
            let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
            let primaryGroup = DispatchGroup()
            
            // Upload Pins for Primary User ////////////////////////////////////////////////
            let userID = FIRAuth.auth()?.currentUser?.uid
            User(userID: userID!).ref.child("pins").removeValue() // Delete Current Pins
        
            // Upload Pins for Other Users ////////////////////////////////////////////////
            var otherUsers : [User] = []
            let otherGroup = DispatchGroup()
            
            // Get All Other User IDS
            otherGroup.enter()
            queue.async {
                print("async 2")
                print("Entering Other Group")
                Firebase.ref.child(User.endpoint).observeSingleEvent(of: .value, with: {snapshot in
                    for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                        let user = User(snapshot:child)
                        otherUsers.append(user)
                    }
                    print("Leaving Other Group")
                    otherGroup.leave()
                })
            }
            // Asynchronously Store New Pins for Other Users in Background
            otherGroup.notify(queue: queue, execute: {
                print("Other Group Notified")
                queue.async {
                    print("Entering Queue to Pin Other Users")
                    for user in otherUsers {
                        User(userID: user.id).ref.child("pins").removeValue() // Delete Current Pins
                        // Async Block for Loading Single Other User Pins
                        for i in 0...PreLoad.numPinsPerOtherUser {
                            
                            // Randomly Select Venue from List
                            let randomIndex = Int(arc4random_uniform(UInt32(venues.count)))
                            let randomVenue = venues[randomIndex]
                            let newPin = UserPin(userID: user.userID, venueID: randomVenue.id, createdDate: generateRandomDate())
                            
                            //print("Saving \(i)th Pin for User : \(user.id)")
                            newPin.ref.childByAutoId().setValue(newPin.dict)
                        }
                    }
                }
            })
            
            print("Entered Primary Group")
            queue.async {
                print("async 1")
                for i in 0...PreLoad.numPinsPerPrimaryUser {
                    // Randomly Select Venue from List
                    let randomIndex = Int(arc4random_uniform(UInt32(venues.count)))
                    let randomVenue = venues[randomIndex]
                    let newPin = UserPin(userID: userID!, venueID: randomVenue.id, createdDate: generateRandomDate())
                    newPin.ref.childByAutoId().setValue(newPin.dict)
                    print("Updating Pin \(i) for Primary User")
                }
                print("Leaving Primary Group")
                
                // Only Need Primary Group Pins to Finish Before Proceeding
                completionHandler(true)
                
            }
            
        })
        

 
        
        
        
    }
}
