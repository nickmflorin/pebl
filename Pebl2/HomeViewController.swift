//
//  HomeViewController.swift
//  Pebl
//
//  Created by Nick Florin on 11/4/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Cloudinary

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate, FIRDatabaseReferenceable {
    
    //////////////////////////////////////////////////////////
    // MARK: Properties

    // Top View
    @IBOutlet weak var statusTile: UIView!

    @IBOutlet weak var profileImageIconView: UIImageView!
    @IBOutlet weak var header1: UILabel!
    @IBOutlet weak var createStatusView: CreateStatusView!
    
    @IBOutlet weak var eventButton: UpDownButton!
    @IBOutlet weak var eventNameField: UILabel!
    @IBOutlet weak var whenField: UILabel!
    @IBOutlet weak var eventMessageField: UILabel!
    @IBOutlet weak var venueImageView: UIImageView!
    
    @IBOutlet weak var categoryNameField: UILabel!
    @IBOutlet weak var categoryNameIcon: UIImageView!
    
    @IBOutlet weak var spinner : UIActivityIndicatorView!
    
    var currentEventVC : HomeEventViewController!
    
    var favoritedVenueIDs : [String]!
    var favoritedVenues : [Venue] = []
    
    var selectedMessage : String!
    var selectedTime : String!
    var selectedVenue : Venue!
    
    // Dispatch Groups for Async
    var asyncQueue : DispatchQueue!
    var downloadGroup : DispatchGroup!
    
    var cld : CLDCloudinary!
    
    var user : User!
    var userID : String!
    
    //////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cld = CLDCloudinary(configuration: CLDConfiguration(cloudName: AppDelegate.cloudName, secure: true))

        // Get Current User UID from Firebase Auth
        userID = FIRAuth.auth()?.currentUser?.uid
        
        // Styling from Master Style
        self.styleMenu()
        self.navigationController?.styleTitle("Home")
        self.view.backgroundColor = UIColor.white
        
        self.addNotificationListeners()
        
        // Style Subviews
        statusTile.layer.borderColor = accentColor.cgColor
        statusTile.layer.borderWidth = 0.6
        statusTile.layer.cornerRadius = 1.0
        statusTile.layer.masksToBounds = false
        statusTile.layer.backgroundColor = UIColor.white.cgColor
        
        self.profileImageIconView.contentMode = .scaleAspectFill
       
        // Load necessary data
        
        user = User(userID: self.userID)
        self.spinner.startAnimating()
        
        // Asynchronously Load the User Status and User Info at the Same Time
        asyncQueue = DispatchQueue(label:"getUserDataQueue",qos:.default, target:nil)
        downloadGroup = DispatchGroup()
        
        asyncQueue.async {
            // Favorites Loaded After User Status
            self.loadUserStatus(completion: {(finished) -> () in
                self.loadUserFavorites(completion: {(finished) -> () in
                    print("Print status finished")
                })
            })
        }
        asyncQueue.async {
            self.loadUserInfo(completion: {(finished) -> () in
                print("Info finished")
            })
        }
        downloadGroup.notify(queue: asyncQueue, execute: {
            self.spinner.stopAnimating()
        })        
    }
    // Attach Listeners and Detach on View Appearance
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
       
//        // To Do: Attach update listeners for favorites and user info as well.
//        self.ref.child("user_status").child(self.userID).observe(.childChanged, with: {snapshot in
//            print("User Status Changed ... ")
//            if snapshot.exists(){
//                if snapshot.key == "venueID"{
//                    self.user.userStatus.venueID = snapshot.value as! String
//                    self.user.userStatus.loadUserVenue({(finished)->() in
//                        self.populateUserStatusData()
//                    })
//                    self.user.userStatus.userVenue.loadImage(completion: {(finished)->() in
//                        DispatchQueue.main.async {
//                            self.venueImageView.image = self.user.userStatus.userVenue.venueImage
//                        }
//                    })
//                }
//                else{
//                    self.user.userStatus.setValue(snapshot.value, forKey: snapshot.key)
//                    self.populateUserStatusData()
//                }
//            }
//        })
    }
    
    // Override layout of subviews for image layers
    override func viewDidLayoutSubviews() {
        
        self.venueImageView.clipsToBounds = true
        self.venueImageView.layer.cornerRadius = 2.0
        self.venueImageView.layer.borderColor = UIColor.clear.cgColor
        
        self.profileImageIconView.clipsToBounds = true
        self.profileImageIconView.layer.cornerRadius = 0.5*self.profileImageIconView.frame.width
        
    }
    
    // Load info related to the user's info object
    func loadUserInfo(completion: @escaping (Bool)->()){
        
        self.downloadGroup.enter()
//    
//        self.user.loadUserInfo(ref: self.ref, {(finished) -> () in
//            
//            // Populate User Info Data
//            self.populateUserInfoData()
//            
//            // Photo IDS Retrieved - Now Get Profile Image
//            self.user.userInfo.loadImage(cld:self.cld,imageNumber: 0, {(UIImage) -> () in
//                DispatchQueue.main.async{
//                    self.profileImageIconView.contentMode = .scaleAspectFill
//                    self.profileImageIconView.image = UIImage
//                }
//                self.downloadGroup.leave()
//                completion(true)
//            })
//            
//        })
    }
    
    // Load info related to the user's status
    func loadUserStatus(completion: @escaping (Bool)->()){
        
        self.downloadGroup.enter()
        
        self.ref.child("user_status").child(self.userID).observeSingleEvent(of: .value, with: {snapshot in

            if snapshot.exists(){
                self.user.userStatus = UserStatus(userID: self.userID, snapshot: snapshot)
                
                self.user.userStatus.loadUserVenue({(finished) -> () in
                    // Populate data before loading image
                    self.populateUserStatusData()
//                    
//                    self.user.userStatus.userVenue.loadImage(completion: {(finished) -> () in
//                        self.venueImageView.contentMode = .scaleAspectFill
//                        self.venueImageView.image = self.user.userStatus.userVenue.venueImage
//                        
//                        self.downloadGroup.leave()
//                        completion(true)
//                    })
                })
            }
        })
    }
    
    ///////////////////////////////////////////
    // Loads Favorited Events for User
    func loadUserFavorites(completion: @escaping (Bool)->()){
        
//        if self.user.userStatus.favoritedVenues.count == 0 {
//            print("No Favorite Venue IDS")
//            return
//        }
//        self.favoritedVenueIDs = self.user.userStatus.favoritedVenues
//        
//        self.downloadGroup.enter()
//        let subdownloadGroup = DispatchGroup()
//        
//        // Use Venue IDs to Retrieve Info for Each Venue
//        self.favoritedVenues = []
//        for i in 0...favoritedVenueIDs.count-1{
//            
//            subdownloadGroup.enter()
//            let venueID = self.favoritedVenueIDs[i]
//            self.ref.child("venues").child(venueID).observeSingleEvent(of: .value, with: {snapshot in
//                if snapshot.exists(){
//                    
//                    let newVenue = Venue(venueID: venueID, snapshot: snapshot)
//                    // Load image for new venue now that we have the URL
//                    newVenue.loadImage(completion: { (finished) in
//                        
//                        print("Finished Request \(i)")
//                        self.favoritedVenues.append(newVenue)
//                        
//                        // Dispatch adding venue to main queue to avoid background thread issues
//                        DispatchQueue.main.async {
//                            self.createStatusView.createStatusViewSlider.favoriteEventView.favoriteEventSlider.addVenue(newVenue)
//                            print("Adding Favorite Venue with ID : \(newVenue.venueID)")
//                            subdownloadGroup.leave()
//                        }
//                        
//                    })
//                }
//            })
//        }
//        // When asynchronous groups complete, return new user object that contains all the downloaded data
//        subdownloadGroup.notify(queue: DispatchQueue.main, execute: {
//            self.downloadGroup.leave()
//            completion(true)
//        })
    }

    ///////////////////////////

    // Populate data from the user's info
    func populateUserInfoData(){
        self.header1.text = "What " + user.userInfo.firstName + " is looking to do"
    }
        
    // Populate data from the user's status
    func populateUserStatusData(){
        
        //self.eventNameField.text = user.userStatus.userVenue.name
        //self.whenField.text = user.userStatus.eventTime
        //self.eventMessageField.text = user.userStatus.eventComment
        //self.categoryNameField.text = user.userStatus.userVenue.subCategoryName
        
        self.categoryNameIcon.contentMode = .scaleAspectFit
        self.categoryNameIcon.image = UIImage(named: "BarIcon")
    
    }
    // Performs Segue for Showing Popover Menu
    func menu_buttonToggle() {
        let baseVC = self.parent?.parent?.parent as! BaseViewController
        baseVC.toggleMenu()
    }
    ///////////////////////////////////////////
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}


