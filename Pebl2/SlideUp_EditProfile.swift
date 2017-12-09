//
//  EmbedSlideUpInfo.swift
//  Pebl
//
//  Created by Nick Florin on 7/24/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

///////////////////////////////////////////
// Similiar to Slide Up Info VC But Has No Container A (Container A Shows Events of User, Don't Need 
// for User Editing Their Own Profile

class SlideUpInfo_EditProfile_ViewController: UIViewController {
    
    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var containerB: UIView!

    var containerB_ViewController : ContainerB_EditProfile?
    
    var user_info_item : UserInfo?
    var ref: FIRDatabaseReference!
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        
        // Styling
        self.view.backgroundColor = self.view.backgroundColor!.withAlphaComponent(0.5)
        
        /////////////////////////////////////////////
        // Add Container Container B VC to Container
        
        // Create Slide Up View Controller/View and Set Frame/Translucent Background
        let slide_up_storyboard = UIStoryboard.init(name: "Base", bundle: nil)
        
        // Use Specific Slide Up Info VC for Editing Profile
        self.containerB_ViewController = slide_up_storyboard.instantiateViewController(withIdentifier: "ContainerB_EditProfile") as? ContainerB_EditProfile
        self.containerB_ViewController?.user_info_item = self.user_info_item
        
        // Add Container B View to Subview
        self.containerB.addSubview(self.containerB_ViewController!.view)
        self.containerB_ViewController!.view.frame = self.containerB.bounds
        
        // Move Container B View Controller to Child View Controller
        self.containerB_ViewController?.willMove(toParentViewController: self)
        self.addChildViewController(self.containerB_ViewController!)
        self.containerB_ViewController?.didMove(toParentViewController: self)
        
    }
}
