//
//  UserImages.swift
//  Pebl2
//
//  Created by Nick Florin on 1/16/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

//////////////////////////////////////////////////////////////////////////////
class UserImages : NSObject{
    
    // MARK: Properties
    var userID: String
    var user_name : String?
    
    var profileImage: UIImage!
    var image1 : UIImage?
    var image2 : UIImage?
    var image3 : UIImage?
    var image4 : UIImage?
    
    var images : [UIImage]!
    var ref : FIRDatabaseReference
    var storageRef:FIRStorageReference!
    var photoRef : FIRDatabaseReference!
    ///////////////////////////////////////
    init(userID: String) {
        self.userID = userID
        
        // Firebase Setup ///////////////////////////////////////
        self.ref = FIRDatabase.database().reference()
        self.storageRef = FIRStorage.storage().reference()
        self.photoRef = self.ref.child("user_images").child(userID)
    }
    ///////////////////////////////////////
    convenience override init() {
        self.init(userID:  "")
    }
    ///////////////////////////////////////
    // Loads the Images for the Given User
    func loadImages(){
        
    }
    ///////////////////////////////////////
    // Combine Images into List Format
    func combineImages(){
        
        self.images = [profileImage]
        if image1 != nil{
            self.images.append(image1!)
            if image2 != nil{
                self.images.append(image2!)
                if image3 != nil{
                    self.images.append(image3!)
                    if image4 != nil{
                        self.images.append(image4!)
                    }
                }
            }
            
        }
    }
    ///////////////////////////////////////
    func loadProfileImage(_ completion: @escaping (UIImage)->()){
        self.photoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let photo_dataDict = snapshot.value as? NSDictionary{
                // Case When No Photos Exist
                if snapshot.exists(){
                    print("Retrieving Photo for \(self.userID) from Firebase Storage")
                    let photo_id = photo_dataDict["profile_image"] as! String
                    self.storageRef.child(photo_id).data(withMaxSize: 10 * 1024 * 1024, completion: { (data, error) in
                        let userImage = UIImage(data: data!)
                        self.profileImage = userImage
                        
                        self.photoRef.removeAllObservers()
                        completion(userImage!)
                    })
                }
                    // Case When No Photos Exist
                else{
                    print("User : \(self.userID) Does Not Have Any Photo IDs Stored in Firebase")
                    let missingImage = UIImage(named: "MissingPhotoImage")
                    self.photoRef.removeAllObservers()
                    completion(missingImage!)
                }
            }
        })
    }
    
}
