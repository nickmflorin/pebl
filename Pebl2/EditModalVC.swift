//
//  EditModalVC.swift
//  Pebl
//
//  Created by Nick Florin on 8/25/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class EditModalVC: UIViewController {
    
    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var edit_typeLabel: UILabel!
    @IBOutlet weak var saveEdit: UIButton!
    @IBOutlet var editField: UITextView!
    
    let horizontal_padding = CGFloat(10.0)
    let vertical_padding = CGFloat(10.0)
    
    var edit_type : String?
    
    var small_indicator : UIActivityIndicatorView!
    var ref: FIRDatabaseReference!
    var storageRef:FIRStorageReference!
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColorFromRGB(0xF5FCFF)
        
        // Firebase Data Store References
        self.ref = FIRDatabase.database().reference()
        self.storageRef = FIRStorage.storage().reference()
    
        self.load_user_info()
        self.style()
    }
    ///////////////////////////////////////////////////////////
    func load_user_info(){
        
        edit_typeLabel.text = self.edit_type
        
        // Get Current User UID from Firebase Auth
        let userID = FIRAuth.auth()?.currentUser?.uid
        if userID != nil{
            // Allow User to Retrieve Their Data
            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dataDict = snapshot.value as? NSDictionary{
                    if self.edit_type == "About Me" {
                        // Get General User Info Data from Snapshot
                        if snapshot.childSnapshot(forPath: "about_me").exists(){
                            self.editField.text = dataDict["about_me"] as! String
                        }
                    }
                        ////////////////////
                    else if self.edit_type == "Hobbies" {
                        // Get General User Info Data from Snapshot
                        if snapshot.childSnapshot(forPath: "hobbies").exists(){
                            self.editField.text = dataDict["hobbies"] as! String
                        }
                    }
                        ////////////////////
                    else if self.edit_type == "Career" {
                        // Get General User Info Data from Snapshot
                        if snapshot.childSnapshot(forPath: "career").exists(){
                            self.editField.text = dataDict["career"] as! String
                        }
                    }
                        ////////////////////
                    else if self.edit_type == "Education" {
                        // Get General User Info Data from Snapshot
                        if snapshot.childSnapshot(forPath: "education").exists(){
                            self.editField.text = dataDict["education"] as! String
                        }
                    }

                }
            })
        }
        else{
            print("User ID is Nil")
        }
    }
    ///////////////////////////////////////////////////////////
    func saveInfo() {
        
        print("Saving User Info", terminator: "")
        self.small_indicator.startAnimating()
        // Get Current User UID from Firebase Auth
        let userID = FIRAuth.auth()?.currentUser?.uid
        // Allow User to Add Data
        self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get Username Value from Snapshot
        
            if self.edit_type == "About Me" {
                let post = ["about_me": self.editField.text]
                self.ref.child("users").child(userID!).updateChildValues(post)
            }
            else if self.edit_type == "Hobbies" {
                let post = ["hobbies": self.editField.text]
                self.ref.child("users").child(userID!).updateChildValues(post)
            }
            else if self.edit_type == "Career" {
                let post = ["career": self.editField.text]
                self.ref.child("users").child(userID!).updateChildValues(post)
            }
            else if self.edit_type == "Education" {
                let post = ["education": self.editField.text]
                self.ref.child("users").child(userID!).updateChildValues(post)
            }
            self.small_indicator.stopAnimating()
            // Close Modal Window
            NotificationCenter.default.post(name: Notification.Name(rawValue: "close_edit_tab"), object:nil)
            self.reload_profile()  // Reload Profile to Reflect Updated Info
        })
    }
    ///////////////////////////////////////////
    // Function to Reload Profile View After Changes Are Made
    func reload_profile(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadProfile"), object: nil)
    }
    ///////////////////////////////////////////
    func style(){
        
        // Style/Shape View
        let height = self.saveEdit.frame.maxY - self.edit_typeLabel.frame.minY
        self.view.bounds = CGRect(x: 0.0, y: 0.0, width: horizontal_padding + self.editField.frame.width, height: height+vertical_padding)
        
        // Give Small Indicator for Progress Saving
        small_indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        small_indicator.frame = self.view.bounds
        self.view.addSubview(small_indicator)
        self.view.bringSubview(toFront: small_indicator)

        self.view.layer.borderColor = UIColor.darkGray.cgColor
        self.view.layer.borderWidth = 1.0
        
        // Give Button Target
        saveEdit.addTarget(self, action: #selector(EditModalVC.saveInfoButtonClicked), for: .touchUpInside)
        
        ///////////////////////////////////////////
        // Styling Button
        saveEdit.backgroundColor = green
        saveEdit.setBackgroundColor(light_gray, forState: UIControlState.highlighted)
        
        saveEdit.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        saveEdit.layer.cornerRadius = 3.0
        saveEdit.layer.borderColor = dark_blue.cgColor
        saveEdit.layer.borderWidth = 1.0
        
        saveEdit.setTitle("Save Changes", for: UIControlState())
        saveEdit.setTitleColor(UIColor.white, for: UIControlState())
        saveEdit.titleLabel?.font = UIFont(name: font_name, size:10)
        
        ///////////////////////////////////////////
        // Styling Text Field
        editField.layer.borderColor = dark_blue.cgColor
        editField.layer.borderWidth = 1.0
    }
    ///////////////////////////////////////////
    // MARK: Actions
    func saveInfoButtonClicked(){
        print("Saving Info", terminator: "")
        self.saveInfo()
    }
    ///////////////////////////////////////////
    // Tell ContainerB to Remove Edit Modal View from Hierarchy
    @IBAction func closeButton(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "close_edit_tab"), object:nil)
    }
}




