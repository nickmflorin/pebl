//
//  ViewProfileViewController.swift
//  Pebl
//
//  Created by Nick Florin on 7/10/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
////////////////////////////////////////////////////////
class EditProfileViewController2: UIViewController, UIPopoverPresentationControllerDelegate {

    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var profileViewContainer: UIView!
    @IBOutlet weak var editPhotosButton: UIButton!
    
    var current_image_index : Int = 0
    var slideup_visible : Bool = true
    
    var user_info_item : UserInfo!
    
    var edit_photosVC : PhotoEditProfileVC?
    
    var spinner : loadingIndicator!
    var ref: FIRDatabaseReference!
    var storageRef:FIRStorageReference!
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initially Hide Edit Photos Button Since Slide Up in Up Position
        self.editPhotosButton.alpha = 0.0
        
        ///////////////////////
        // Activity Indicator
        spinner = loadingIndicator(targetView: self.view)
        self.view.addSubview(spinner)
        self.view.bringSubview(toFront: spinner)
        self.spinner.startSpinning("Loading User Data")
        
        self.ref = FIRDatabase.database().reference()
        self.storageRef = FIRStorage.storage().reference()
        
        ////////////////////////////////////////////////
        // Notification Listener to Reload Profile
        //NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.reload_profile(_:)), name: NSNotification.Name(rawValue: "reloadProfile"), object: nil)
    
        //Styling
        self.profileViewContainer.clipsToBounds = true
        self.profileViewContainer.backgroundColor = UIColor.clear
        self.profileViewContainer.layer.borderColor = dark_blue.cgColor
        self.profileViewContainer.layer.borderWidth = 2.0
        self.edit_menu_button()

        self.load_user_info()
        self.view.bringSubview(toFront: editPhotosButton)
    }
    ///////////////////////////////////////////
    // Styling
    func edit_menu_button(){
        let menu_image = UIImage(named: "MenuButton")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        // Remove Menu Button Title
        menuButton.title = ""
        let new_image = menu_image.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0))
        // Remove Bar Button Item Image
        menuButton.setBackgroundImage(new_image, for: UIControlState(), barMetrics: .default)
    }
    ///////////////////////////////////////////////////////////
    // Reloads Profile After View Loaded Initially If Changes Made
    func reload_profile(_ notification: Notification){
        print("Reloading Information in Profile", terminator: "")
        self.load_user_info()
    }
    ///////////////////////////////////////////////////////////
    func load_user_info(){
        
        // Get Current User UID from Firebase Auth
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        if userID != nil {
            
            //self.user_info_item = UserInfo()
            //self.user_info_item.userID = userID!
            
            let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
            let load_group = DispatchGroup()
            
            //////////////////////// Getting Events for User ////////////////////////
            queue.async(group: load_group, execute: {
                load_group.enter()
                self.ref.child("user_events").child(userID!).observeSingleEvent(of: .value, with: { snapshot in
                    // Get User Event Info for User Item
//                    if let dataDict = snapshot.value as? NSDictionary{
//                        if snapshot.childSnapshot(forPath: "custom_event").exists() && snapshot.childSnapshot(forPath: "event_message").exists(){
//                            self.user_info_item.custom_event = dataDict["custom_event"] as? String
//                            self.user_info_item.custom_event_message = dataDict["event_message"] as? String
//                        }
//                    }
                    load_group.leave()
                })
            })
            //////////////////////// Getting Info for User ////////////////////////
            queue.async(group: load_group, execute: {
                load_group.enter()
                // Get User Info
                self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { snapshot in
                    ////////// Retrieving Info for User //////////////////
                    if let dataDict = snapshot.value as? NSDictionary{
                        //self.user_info_item.age = dataDict["age"] as? String
                        //self.user_info_item.career = dataDict["career"] as? String
                        //self.user_info_item.education = dataDict["education"] as? String
                        //self.user_info_item.hobbies = dataDict["hobbies"] as? String
                        //self.user_info_item.user_name = dataDict["user_name"] as? String
                        //self.user_info_item.aboutMe = dataDict["about_me"] as? String
                        ///self.user_info_item.first_name = dataDict["first_name"] as? String
                        
                    }
                    load_group.leave()
                })
            })
            //////////////////////// Getting Images for User ////////////////////////
            queue.async(group: load_group, execute: {
                load_group.enter()
                self.ref.child("user_images").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Case When Photos Exist
                    if snapshot.exists() {
                        if snapshot.childSnapshot(forPath: "profile_image").exists(){
                            if let dataDict = snapshot.value as? NSDictionary{
                                let photo_id = dataDict["profile_image"] as! String
                                retrieve_photo(userID!,photo_id:photo_id, photoHandler: {(image) -> Void in
                                    //self.user_info_item.user_image = image
                                    load_group.leave()
                                })
                            }
                        }
                        else{
                            print("Error : User Has Photo ID's but No Designated Profile Image")
                            load_group.leave()
                        }
                    }
                    // Case When No Photos Exist
                    else{
                        print("User : \(userID) Does Not Have Any Photo IDs Stored in Firebase")
                        //self.user_info_item.user_image = UIImage(named:"BlankPhoto")
                        load_group.leave()
                    }
                })
            })
            //////////////////////// Dispatch to Main Queue to Setup Info Slide ////////////////////////
            load_group.notify(queue: DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high),  execute: {
                DispatchQueue.main.async(execute: {
                    self.setup_info_slide()
                    self.spinner.stopSpinning()
                })
            });
        }
        else{
            print("UserID is Nil")
        }
    }
    ///////////////////////////////////////////
    func setup_info_slide(){

        // Create Initial VC for Profile View of Match
        let profile_vc = self.storyboard!.instantiateViewController(withIdentifier: "EditProfile") as! EditProfileVC2
        self.profileViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Pass in Usernames to Embed Profile VC
        profile_vc.user_info_item = user_info_item
        
        // Set Match Profile VC to Correct Frame
        profile_vc.view.frame = self.profileViewContainer.bounds
        
        self.profileViewContainer.addSubview(profile_vc.view)
        
        let horizontalConstraint = NSLayoutConstraint(item: profile_vc.view, attribute: .centerX, relatedBy: .equal, toItem: self.profileViewContainer, attribute: .centerX, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: profile_vc.view, attribute: .width, relatedBy: .equal, toItem: self.profileViewContainer, attribute: .width, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: profile_vc.view, attribute: .height, relatedBy: .equal, toItem: self.profileViewContainer, attribute: .height, multiplier: 1, constant: 100)
        
        self.profileViewContainer.addConstraint(widthConstraint)
        self.profileViewContainer.addConstraint(horizontalConstraint)
        self.profileViewContainer.addConstraint(heightConstraint)
        
        profile_vc.willMove(toParentViewController: self)
        self.addChildViewController(profile_vc)
        profile_vc.didMove(toParentViewController: self)
        
    }
    ///////////////////////////////////////////
    // Function to Add Back Button When Edit Photos Button Clicked
    func add_backButton(){
        
        // Create UI Bar Button Item
        let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(EditProfileViewController2.backButton_clicked))
        // Add Bar Button Item to View
        self.navigationItem.setRightBarButton(button, animated: true)
        
    }
    ///////////////////////////////////////////
    func backButton_clicked(){
        
        // Remove Navigation Bar Button Item
        self.navigationItem.rightBarButtonItem = nil
        // Remove View and View Controllers for Match View
        self.edit_photosVC!.view?.removeFromSuperview()
        self.edit_photosVC?.removeFromParentViewController()
    }

    ///////////////////////////////////////////
    // Button That Moves View to Edit Photos View
    @IBAction func editPhotosButton(_ sender: AnyObject) {
        print("Moving to Editing Photos View", terminator: "")
        // Create Photo Editing View Controller
        self.edit_photosVC = self.storyboard!.instantiateViewController(withIdentifier: "PhotoEditProfile") as! PhotoEditProfileVC
        self.view.addSubview(edit_photosVC!.view!)
        self.edit_photosVC!.view!.frame = self.view.bounds
        
        self.edit_photosVC!.willMove(toParentViewController: self)
        self.addChildViewController(self.edit_photosVC!)
        self.edit_photosVC!.didMove(toParentViewController: self)
        
        // Add Back Button to Nav Bar to Go Back
        self.add_backButton()
    
    }
    ///////////////////////////////////////////
    // Performs Segue for Showing Popover Menu
    @IBAction func menu_buttonToggle(_ sender: AnyObject) {
        let baseVC = self.parent?.parent as! BaseViewController
        baseVC.toggleMenu()
    }
    ///////////////////////////////////////////
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    ///////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


