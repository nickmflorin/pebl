//
//  Utilities.swift
//  Pebl
//
//  Created by Nick Florin on 6/25/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

func randomStringWithLength (_ len : Int) -> NSString {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for _ in 0...len{
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    
    return randomString
}

/////////////////////////////////////////////////////////
// Resizes photo for more compact S3 data storage
func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

///////////////////////////////////////////////////////////
// Checks if Photo in Core Data - If Not, Downloads and Saves to Core Data
func retrieve_photo(_ user_id:String,photo_id:String,photoHandler : @escaping (UIImage) -> ()){
    
    let storageRef = FIRStorage.storage().reference()
    
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    
    //Temporary for Fake Matches
    let fileName = photo_id
    //let fileName = user_id + "_" + photo_id
    
    if (FIRAuth.auth()?.currentUser != nil) {
        let stored_ids = core_user_photos().query_photo_ids(user_id)
        
        /// Photo Stored in Core Data
        if stored_ids.contains(photo_id){
            print("Photo ID : \(photo_id) Stored in Core Data")
            let stored_item = core_user_photos().fetch_photo_item_by_id(photo_id)
            let image_data = stored_item?.photo
            let uiimage = UIImage(data:image_data!)
            photoHandler(uiimage!)
        }
        // Photo Not Stored in Core Data
        else{
            print("Photo ID : \(photo_id) Not Stored in Core Data")

            print("Downloading File : \(fileName) from Firebase Storage")
            
            var filePath : String = ""
            var straight_path : String = ""
            
            if fileName.range(of: ".") != nil{
                filePath = "file:\(documentsDirectory)/\(photo_id)"
                straight_path = "\(documentsDirectory)/\(photo_id)"
            }
            else{
                filePath = "file:\(documentsDirectory)/\(photo_id).png"
                straight_path = "\(documentsDirectory)/\(photo_id).png"
            }

            
            print("Downloading to File Path : \(filePath)")
            // Download Actual Image Locally and Retrieve After
            
            storageRef.downloadURL { (url, error) in
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                
                DispatchQueue.main.async(execute: {
                    core_user_photos().save_uiimage(user_id, photo_id: photo_id, uiimage: image!)
                })
                photoHandler(image!)
            }
        } // End of Case When Photo Not in Core Data
    } // End of IF Statement for Current User is Nil
    else{
        print("Current User is Nil")
    }
}
