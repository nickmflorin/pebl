//
//  GiveMatchPeblVC.swift
//  Pebl
//
//  Created by Nick Florin on 9/18/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class MessagePeblModal: UIViewController {
    
    /////////////////////////
    // MARK: Properties
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var small_indicator : UIActivityIndicatorView!
    var ref: FIRDatabaseReference!
    var storageRef:FIRStorageReference!
    
    var matched_userID : String?
    /////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Data Store References
        self.ref = FIRDatabase.database().reference()
        self.storageRef = FIRStorage.storage().reference()
        
        //Styling
        self.style()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        self.view.layer.cornerRadius = 2.0
    }
    /////////////////////////
    func style(){
        
        self.messageField.backgroundColor = UIColor.white
        self.messageField.layer.borderWidth = 1.0
        self.messageField.layer.borderColor = UIColorFromRGB(0x535187).cgColor
    }
    /////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /////////////////////////
    //MARK: Actions
    
    @IBAction func sendButtonClicked(_ sender: AnyObject) {
        
//        print("Creating Pebl")
//        //self.small_indicator.startAnimating()
//        
//        // Get Current User UID from Firebase Auth
//        let userID = FIRAuth.auth()?.currentUser?.uid
//        // Allow User to Add Data
//        self.ref.child("user_pebls").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//            
//            if self.matched_userID != nil{
//                if self.eventField.text != nil && self.messageField.text != nil{
//                    // Add Pebl to Created Pebls for User
//                    let post = ["event": self.eventField.text,"message":self.messageField.text]
//                    self.ref.child("user_pebls").child(userID!).child("created").childByAutoId().updateChildValues(post)
//                    // Add Pebl to Sent Pebls for User
//                    let post2 = ["event": self.eventField.text,"message":self.messageField.text,"userID":self.matched_userID]
//                    self.ref.child("user_pebls").child(userID!).child("sent").childByAutoId().updateChildValues(post2)
//                }
//                else{
//                    print("Missing Required Text Field Data")
//                }
//            }
//            else{
//                print("Missing Matched User ID")
//            }
//        })
    }
    /////////////////////////
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
//        self.view.removeFromSuperview()
//        let parentVC = self.parent as! ContainerA_Match
//        parentVC.enablePebls()
    }
}
