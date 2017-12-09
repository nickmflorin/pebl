//
//  UserInfo.swift
//  Pebl2
//
//  Created by Nick Florin on 1/16/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import Cloudinary

//////////////////////////////////////////////////////////////////////////////
class UserInfo : FIRUserDataModel{
    
    var firstName : String!
    var lastName : String!
    var age : Int!
    
    var gender : String!
    var genderInterest : String!
    
    var career : String?
    var jobTitle : String?
    var schoolName : String?
    var majorName : String?
    var graduationYear : Int?
    
    var hobbies : [String] = []
    var photoIDs : [String] = []
    var images : [Int:UIImage] = [:]
    var profileImage : UIImage!
    
    static var endpoint : String = "info"
    
    // Init with User ID
    init(userID: String) {
        // Reference Retrieved when Initializing Super Object
        super.init(userID: userID, endpoint: User.endpoint)
        self.ref = Firebase.ref.child(User.endpoint).child(UserInfo.endpoint).child(self.userID)
    }
    
    // Init with Snapshot
    override init(snapshot: FIRDataSnapshot) {
        // Reference Retrieved when Initializing Super Object
        super.init(snapshot: snapshot)
    }
    
    // Convert Object to Dictionary Representation
    var dict : [String:AnyObject] { get
    {
        var returnData : [String:AnyObject] = [:]
        let mirrored_object = Mirror(reflecting: self)
        
        // Attribute to Dictionary
        // TO DO : This method might need to be improved upon.
        for (_, attr) in mirrored_object.children.enumerated() {
            if attr.value is String || attr.value is CGFloat || attr.value is Int {
                returnData[attr.label!] = attr.value as AnyObject?
            }
            else if attr.value is [String] || attr.value is [CGFloat] || attr.value is [Int ]{
                returnData[attr.label!] = attr.value as AnyObject?
            }
            else if attr.value is [String:AnyObject] || attr.value is [CGFloat:AnyObject] || attr.value is [Int:AnyObject]{
                returnData[attr.label!] = attr.value as AnyObject?
            }
        }
        return returnData
        }
    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ///////////////////////////////////////
    // Stores Data from Snapshot
    func storeSnapshotData(snapshot: FIRDataSnapshot){
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        // Unwrap and Store String Fields
        for attr in ["firstName","lastName","career","gender","genderInterest","jobTitle","schoolName","majorName"]{
            if let unwrapped_attr_val = snapshotValue[attr] as? String{
                self.setValue(unwrapped_attr_val, forKey: attr)
            }
            else{
                // Missing Data Error
                fatalError("\(attr) for User : \(self.userID) Missing")
            }
        }
        // Unwrap Other Data Types
        if let age = snapshotValue["age"] as? Int{
            self.age = age
        }
        else{
            // Missing Data Error
            fatalError("age for User : \(self.userID) Missing")
        }
        // Generate Hobbies List from Dictionary
        if snapshot.hasChild("hobbies"){
            let hobbiesSnapshot = snapshot.childSnapshot(forPath: "hobbies")
            if let hobbiesList = hobbiesSnapshot.value as? [String] {
                self.hobbies = hobbiesList
            }
        }
        
        // Generate Photo IDS List from Dictionary
        if snapshot.hasChild("photoIDs"){
            let photoIDSnapshot = snapshot.childSnapshot(forPath: "photoIDs")
            if let photoIDList = photoIDSnapshot.value as? [String] {
                self.photoIDs = photoIDList
            }
        }
    }
    ///////////////////////////////////////
    // If initialized without a snapshot, this optionality allows the software to load the data directly into the object
    // instead of passing in a snapshot value.
    func load(ref:FIRDatabaseReference,_ completion:@escaping(Bool)->()){
        
        self.ref = ref.child("user_info").child(self.userID)
        
        self.ref.observeSingleEvent(of: .value, with: { snapshot in
            self.storeSnapshotData(snapshot: snapshot)
            completion(true)
        })
    }
    /////////////////////////////////////////
    // Downloads Images from Cloudinary Configuration Setup
    func loadImage(cld : CLDCloudinary,imageNumber : Int,_ completion:@escaping(UIImage)->()){
        
        // Image Number of 0 Corresponds to Profile Image
        let photo_id = self.photoIDs[imageNumber]
        
        // Create URL for Image
        let url = cld.createUrl().generate(photo_id)
        cld.createDownloader().fetchImage(url!)
        
        let request = cld.createDownloader().fetchImage(url!, { (Progress) in
            // Handle progress
        }) { (responseImage, error) in
            if error != nil {
                fatalError("Error Downloading Image from URL")
            }
            else{
                print("Downloaded Image from URL : \(url)")
                self.images[imageNumber]=responseImage!
                if imageNumber == 0{
                    self.profileImage = responseImage!
                }
                completion(responseImage!)
            }

        }
    
    }
    /////////////////////////////////////////
    // Takes Available Career Data to Parse into String Sentence for Populating Data
    func parseCareer()->String{
        
        var careerString = ""
        if jobTitle != nil {
            careerString = careerString + jobTitle!
            if career != nil {
                careerString = careerString + " at "+career!
            }
        }
        else if career != nil {
            careerString = careerString + career!
        }
        return careerString
    }
    /////////////////////////////////////////
    // Takes Available Education Data to Parse into String Sentence for Populating Data
    func parseEducation()->String{
        
        var educationString = ""
        if majorName != nil {
            educationString = educationString + majorName!
            if schoolName != nil {
                educationString = educationString + " at "+schoolName!
            }
        }
        else if schoolName != nil {
            educationString = educationString + schoolName!
        }
        if (schoolName != nil && graduationYear != nil) || (majorName != nil && graduationYear != nil){
            educationString = educationString + ", "+String(describing: graduationYear)
        }

        return educationString
    }
    /////////////////////////////////////////
    // Takes Available Hobbies Data to Parse into String Sentence for Populating Data
    func parseHobbies()->String{
        
        var hobbiesString = ""
        if self.hobbies.count != 0 {
            for i in 0...self.hobbies.count - 1 {
                hobbiesString = hobbiesString + self.hobbies[i]
                if i != self.hobbies.count - 1 {
                    hobbiesString = hobbiesString + ", "
                }
            }
        }
        return hobbiesString
    }
}

