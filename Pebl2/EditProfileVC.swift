//
//  EmbedMatchProfile.swift
//  Pebl
//
//  Created by Nick Florin on 7/24/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage

////////////////////////////////////////////////////////
class EditProfileVC2: UIViewController {
    
    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var profilePicView: UIImageView!
    
    // Container View Controllers
    var containerB : ContainerB_EditProfile?
    
    var user_info_item : UserInfo?
    var slideup_visible : Bool = true
    var ref: FIRDatabaseReference!
    var storageRef:FIRStorageReference!
    
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        self.storageRef = FIRStorage.storage().reference()
        
        self.setup()
        
        // Notification Listeners for Switching Between Container A and Container B
        //NotificationCenter.default.addObserver(self, selector: "show_more_info", name: NSNotification.Name(rawValue: "more_info"), object:nil)
        //NotificationCenter.default.addObserver(self, selector: "show_less_info", name: NSNotification.Name(rawValue: "less_info"), object:nil)
    }
    ///////////////////////////////////////////
    // Sets Up Image View and Info Slide Containers for Profile View
    func setup(){
        
        if self.user_info_item != nil {
            
            // Set Photo
            //self.profilePicView.image = user_info_item!.user_image
            
            /////////////////////////////////////////////
            // Create Slide Up View Controller/View and Set Frame/Translucent Background
            let slide_up_storyboard = UIStoryboard.init(name: "Base", bundle: nil)
            
            // Use Specific Slide Up Info VC for Viewing Match Profile
            self.containerB = slide_up_storyboard.instantiateViewController(withIdentifier: "ContainerB_EditProfile") as? ContainerB_EditProfile
            self.containerB?.user_info_item = self.user_info_item

            ///////////////////
            // Attach Gestures Before Adding to View
            self.attach_gestures()
            
            ///////////////////////////////////////////////////////
            // Create and Add Container B as Child
            self.containerB?.willMove(toParentViewController: self)
            self.addChildViewController(self.containerB!)
            self.containerB?.didMove(toParentViewController: self)

            ////////////////////////////////////////////////////
            // Container B Only Container
            self.view.addSubview(self.containerB!.view)
        }
    }
    ///////////////////////////////////////////
    // Attaches Sliding Gestures to Info Slides and Image
    func attach_gestures(){
        
        let up_gestureB = UISwipeGestureRecognizer(target:self,action:#selector(EditProfileVC2.slideUp))
        up_gestureB.direction = UISwipeGestureRecognizerDirection.up
        self.containerB?.view.addGestureRecognizer(up_gestureB)
        
        let down_gestureB = UISwipeGestureRecognizer(target:self,action:#selector(EditProfileVC2.slideDown))
        down_gestureB.direction = UISwipeGestureRecognizerDirection.down
        self.containerB?.view.addGestureRecognizer(down_gestureB)
    }
    ///////////////////////////////////////////
    func slideUp(){
        if self.slideup_visible == true{
            return
        }
        //////// Animation
        UIView.animate(withDuration: 0.5, animations: {
            
            // Hide Edit Photos Button
            let parentVC = self.parent as! EditProfileViewController2
            parentVC.editPhotosButton.alpha = 0.0

            let y_top = self.containerB?.about_meField.frame.maxY
            
            // Calculate Offset Distance for Sliding Up/Down So That About Me Section Always Showing When Slid Down
            let y_bottom = self.view.frame.height
            let buffer = CGFloat(20.0)
            let y_offset = -1*(y_bottom-y_top! - buffer)
            
            // Set Visible Bool Variable to Keep Track of State of Slide Up
            self.slideup_visible = true
            self.containerB?.view.frame = (self.containerB?.view.frame.offsetBy(dx: 0.0, dy: y_offset))!
            
        }) 
    }
    ///////////////////////////////////////////
    func slideDown(){
        if self.slideup_visible == false{
            return
        }
        ///////// Animation
        UIView.animate(withDuration: 0.5, animations: {
            
            // Make Edit Photos Button Visible
            let parentVC = self.parent as! EditProfileViewController2
            parentVC.editPhotosButton.alpha = 1.0
            
            let y_top = self.containerB?.about_meField.frame.maxY
            
            // Calculate Offset Distance for Sliding Up/Down So That About Me Section Always Showing When Slid Down
            let y_bottom = self.view.frame.height
            let buffer = CGFloat(20.0)
            
            let y_offset = y_bottom-y_top! - buffer
            // Set Visible Bool Variable to Keep Track of State of Slide Up
            self.slideup_visible = false
            self.containerB?.view.frame = (self.containerB?.view.frame.offsetBy(dx: 0.0, dy: y_offset))!
        }) 
    }
    
}
