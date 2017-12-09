//
//  MainModels.swift
//  Pebl
//
//  Created by Nick Florin on 8/3/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth

////////////////////////////////////////
// Object Reperesents User Data for User Logged In
class AuthUser: NSObject {
    
    var uid : String

    var username: String?
    var email : String?
    
    var userInfo : UserInfo!
    var userImages : UserImages!
    var userEvent : UserEvent!
    var ref : FIRDatabaseReference!
    
    /////////////////////////////////
    init(uid: String) {
        
        self.uid = uid
        self.userInfo = UserInfo(userID: self.uid)
        self.userEvent = UserEvent(userID: self.uid)
        self.userImages = UserImages(userID: self.uid)
    }
    /////////////////////////////////
    convenience override init() {
        self.init(uid:  "")
    }
    /////////////////////////////////
    // Loads All Necessary Data and Waits for Downloads to Finish Before Returning Completion
    func setup(_ completion: @escaping (Bool)->()){
        
        let downloadQueue = DispatchQueue(label:"downloadQueue",qos:.default, target:nil)
        let downloadGroup = DispatchGroup()
        
        /////// Loading User Auth Block ///////////////
        downloadQueue.async(group: downloadGroup,  execute: {
            downloadGroup.enter()
            self.loadAuth({ (finished) -> () in
                if finished{
                    print("Current User Info Loaded Successfully")
                    downloadGroup.leave()
                }
            })
        })
        
        /////// Loading User Info Block ///////////////
        downloadQueue.async(group: downloadGroup,  execute: {
            downloadGroup.enter()
            self.userInfo.load(ref:self.ref,{ (finished) -> () in
                if finished{
                    print("Current User Info Loaded Successfully")
                    downloadGroup.leave()
                }
            })
        })
        /////// Loading User Image Block ///////////////
        downloadQueue.async(group: downloadGroup,  execute: {
            downloadGroup.enter()
            self.userImages.loadProfileImage({ (userImage) -> () in
                print("Current User Image Loaded Successfully")
                downloadGroup.leave()
            })
        })
        /////// Loading User Event Block ///////////////
        downloadQueue.async(group: downloadGroup,  execute: {
            downloadGroup.enter()
            self.userEvent.load({(finished)->() in
                if finished{
                    print("Current User Event Loaded Successfully")
                    downloadGroup.leave()
                }
            })
        })
        ////// All Downloads Finished ////////////////
        downloadGroup.notify(queue: DispatchQueue.main, execute: {
            completion(true)
        })
    }
    /////////////////////////////////
    func loadAuth(_ completion: @escaping (Bool)->()){
        self.email = FIRAuth.auth()?.currentUser?.email
        self.username = FIRAuth.auth()?.currentUser?.displayName
        completion(true)
        
    }
}




//////////////////////////////////////////////////////////////////////////////
class UserEvent : NSObject {
    
    //////////////////
    // MARK: Properties
    var userID: String

    var eventDate : Date? // Need to Remove
    
    var event_name : String?
    var event_time : String?
    
    var eventMessage : String? // Need to Remove
    var eventImage : UIImage?
    var eventRating : Int?
    var eventAddress : String?
    
    var tags : [String]?
    var ref : FIRDatabaseReference
    var eventRef : FIRDatabaseReference!
    
    ///////////////////////////////////////
    init(userID: String) {
        self.userID = userID
        
        // Firebase Setup ///////////////////////////////////////
        self.ref = FIRDatabase.database().reference()
        self.eventRef = self.ref.child("user_events").child(userID)
    }
    ///////////////////////////////////////
    convenience override init() {
        self.init(userID:  "")
    }
    ///////////////////////////////////////
    func load(_ completion:@escaping(Bool)->()){
        
        self.eventRef.observeSingleEvent(of: .value, with: { snapshot in
            print("Gathering User Info for \(self.userID)")
            if let event_dataDict = snapshot.value as? NSDictionary{
                if snapshot.exists(){
                    self.event_name=event_dataDict["event_name"] as? String
                    self.event_time=event_dataDict["event_time"] as? String
                    self.eventMessage = event_dataDict["event_message"] as? String
                }
                self.eventRef.removeAllObservers()
                completion(true)
            }
        })
    }
}



/////////////////////////////////////
class CellInfoItem{
    var user_name : String?
    var first_name : String?
    var age : String?
    var image : UIImage?
    var user_id : String?
    var custom_event : String?
    var custom_event_message : String?

}
/////////////////////////////////////
class MessageTileInfo{
    var user_name : String?
    var first_name : String?
    var age : String?
    var image : UIImage?
    var user_id : String?
    var message : String?
    
}
/////////////////////////////////////
class EventTileInfo{
    var user_name : String?
    var first_name : String?
    var age : String?
    var image : UIImage?
    var user_id : String?
    var message : String?
    
}
/////////////////////////////////////
class SuggestionTileInfo{
    var user_name : String?
    var first_name : String?
    var age : String?
    var image : UIImage?
    var user_id : String?
    var message : String?
}

/////////////////////////////////////
class UserImage: NSManagedObject {
    
    @NSManaged var photo_id: String?
    @NSManaged var photo: Data?
    @NSManaged var user_id: String?
    
}
