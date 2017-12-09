//
//  SwipeViewController.swift
//  Pebl
//
//  Created by Nick Florin on 11/6/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SwipeViewController: UIViewController {

    //////////////////////////
    //MARK : Properties
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ageField: UILabel!
    @IBOutlet weak var distanceField: UILabel!
    @IBOutlet weak var firstNameField: UILabel!
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!

    var potentialUserIDs = NSMutableArray()
    var potentialMatches = NSMutableDictionary()
    var ref: FIRDatabaseReference!
    var storageRef:FIRStorageReference!
    var userRef : FIRDatabaseReference!
    
    var infoSlidUp : Bool = false
    var infoOffset : CGFloat = 345.0
    
    var profileImageVC : SwipeProfileImageVC?
    var profileInfoVC : SwipeProfileInfoViewController?
    var profileImageView : UIView?
    var profileInfoView : UIView?
    //////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: progressIndicator)
        self.progressIndicator.alpha = 0.0
        
        // Firebase Setup ///////////////////////////////////////
        self.ref = FIRDatabase.database().reference()
        self.storageRef = FIRStorage.storage().reference()
        self.userRef = self.ref.child("users")
        
        // Styling from Master Style
        self.styleMenu()
        self.navigationController?.styleTitle("Match")

        // Attach Asynchronous Listener for User Matches Endpoint
        let downloadQueue = DispatchQueue(label:"downloadQueue",qos:.default, target:nil)
        let group = DispatchGroup()
        
        // Initial Data Download ///////////////////////////
        self.userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren(){ // This should always be the case
                
                self.progressIndicator.startAnimating()
                self.progressIndicator.alpha = 1.0
                
                for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    
                    ///////// Asynchronous Download for Single User Data //////////////
                    group.enter()
                    downloadQueue.async(group: group,  execute: {
                        self.downloadChildData(child,completion: { (newPotentialMatch,genderValid) -> () in
                            group.leave()
                            
                            // Only Continue for User IDS Matching Filter Criteria
                            if genderValid {
                                DispatchQueue.main.async {
                                    self.potentialUserIDs.add(newPotentialMatch.userID! as String)
                                    self.potentialMatches[newPotentialMatch.userID! as String]=newPotentialMatch
                                    
                                    // If the Potential User ID is the First in Dictionary - Load Profile Info Immediately
                                    print(self.potentialUserIDs.index(of: newPotentialMatch.userID! as String))
                                    if self.potentialUserIDs.index(of: newPotentialMatch.userID! as String) == 0{
                                        DispatchQueue.main.async {
                                            self.setupProfile(newPotentialMatch)
                                            self.progressIndicator.stopAnimating()
                                            self.progressIndicator.alpha = 0.0
                                        }
                                    }
                                }
                            }
                        })
                    })
                    ///////// When Download for All Matches Finishes /////////////////
                    group.notify(queue: DispatchQueue.main, execute: {
                        //DispatchQueue.main.async {
                            //self.attachUpdateListeners() // Attach Listeners for Updates
                            print("Finished Loading Potential Matches")
                        //}
                    })
                } // End For Loop
                
            }
        })
    }
    ///////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    ///////////////////////////////////////
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.ref.removeAllObservers()
        self.userRef.removeAllObservers()
    }
    ///////////////////////////////////////////////////////////
    // Toggles Profile Info from Slid Up to Slid Down/Vice Versa
    func toggleProfileInfo(){
        // Slide Down
        if self.infoSlidUp{
            UIView.animate(withDuration: TimeInterval(1.0), animations: {
                self.profileInfoView?.frame = (self.profileInfoView?.frame.offsetBy(dx: 0.0, dy: self.infoOffset))!
            })
            self.infoSlidUp = false
        }
        // Slide Up
        else{
            UIView.animate(withDuration: TimeInterval(1.0), animations: {
                self.profileInfoView?.frame = (self.profileInfoView?.frame.offsetBy(dx: 0.0, dy: -1*self.infoOffset))!
            })
            self.infoSlidUp = true

        }
    }
    ///////////////////////////////////////////////////////////
    func setupProfile(_ newPotentialMatch : PotentialMatch){
        
        // Add Info to Header
        //self.firstNameField.text = newPotentialMatch.user?.userInfo?.first_name
        self.ageField.text = String(describing:newPotentialMatch.user?.userInfo?.age)
        
        // Temporary for Now
        self.distanceField.text = "3"
        
        self.createInfoSwipeView(newPotentialMatch)
        self.createImageSwipeView(newPotentialMatch)
    }
    ///////////////////////////////////////////////////////////
    func createInfoSwipeView(_ newPotentialMatch : PotentialMatch){
        
        // Remove Subview if Already There for Transitioning
        if profileInfoView != nil{
            self.profileInfoView?.removeFromSuperview()
        }
        // Add Swipe Profile View and View Controller as Subview/Child VC
        self.profileInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "SwipeProfileInfoViewController") as? SwipeProfileInfoViewController
        
        self.profileInfoVC?.potentialMatch = newPotentialMatch
        self.profileInfoVC?.view.frame = self.containerView.bounds.offsetBy(dx: 0.0, dy: self.infoOffset)
        self.containerView.addSubview((self.profileInfoVC?.view)!)
        self.profileInfoView = self.profileInfoVC?.view
        
        self.profileInfoVC?.willMove(toParentViewController: self)
        self.addChildViewController((self.profileInfoVC)!)
        self.profileInfoVC?.didMove(toParentViewController: self)
        
        self.containerView.bringSubview(toFront: self.profileInfoView!)
    }
    ///////////////////////////////////////////////////////////
    func createImageSwipeView(_ newPotentialMatch : PotentialMatch){
        
        // Remove Subview if Already There for Transitioning
        if profileImageView != nil{
            self.profileImageView?.removeFromSuperview()
        }
        // Add Swipe Profile View and View Controller as Subview/Child VC
        self.profileImageVC = self.storyboard!.instantiateViewController(withIdentifier: "SwipeProfileImageVC") as? SwipeProfileImageVC
        
        self.profileImageVC?.potentialMatch = newPotentialMatch
        self.profileImageVC?.view.frame = self.containerView.bounds
        self.containerView.addSubview((self.profileImageVC?.view)!)
        
        self.profileImageVC?.willMove(toParentViewController: self)
        self.addChildViewController((self.profileImageVC)!)
        self.profileImageVC?.didMove(toParentViewController: self)
        
        if self.profileInfoView != nil{
            self.containerView.bringSubview(toFront: self.profileInfoView!)
        }
    }
    ///////////////////////////////////////////////////////////
    // Downloads Data using Asynch Function Calls and Adds Table Cell to View
    func downloadChildData(_ child:FIRDataSnapshot,completion: @escaping (PotentialMatch, Bool)->()){
        
        // Unwrap Snapshot as Dictionary
        if let dataDict = child.value as? NSDictionary{
            
            let newPotentialMatch = PotentialMatch()
            print("Found Child Potential Match with Data : ",dataDict)
            
            /////// Loading Match Block ///////////////
            let user_id = child.key
            newPotentialMatch.userID = user_id

//            // Get User Data and Attach to Match Object
//            let matchedUser = User(userID: user_id)
//            matchedUser.setup(ref:self.ref,{(finished) -> () in
//                
//                newPotentialMatch.user = matchedUser
//                completion(newPotentialMatch,true)
//            })
        }
    }
    ///////////////////////////////////////////
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
