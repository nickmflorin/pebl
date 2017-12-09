//
//  MatchesMainViewController.swift
//  Pebl2
//
//  Created by Nick Florin on 1/3/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import Cloudinary

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
class MatchesViewController: UIViewController,MatchesTableVCDelegate,MatchTableViewCellDelegate_MainView, MessagePeblFloatingButtonDelegate, SendMessagePeblViewDelegate {
    
    ///////////////////////////////////////
    //MARK : Properties
    
    // Sliders, Headers and Tables
    var matchTableVC : MatchesTableVC! // Match Table
    var matchEventVC : MatchEventVC! // Matches Event
    var eventShadowView : UIView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var floatingButton : MessagePeblFloatingButton!
    var coverAlphaView : UIView!
    
    // Send Message Pebl Modal
    @IBOutlet weak var sendMessagePeblView: SendMessagePeblView!
    var alphaModeActive : Bool = false

    // Profile View Controller
    var currentProfileVC : MatchProfileVC!
    
    // Firebase References
    var ref : FIRDatabaseReference!
    var cld : CLDCloudinary!

    // Keep Track of Pebls Downloaded
    var numMatches : Int = 0
    var matches = NSMutableDictionary()
    
    // View Parameters
    var matchEventViewHorizontalMargin : CGFloat = 5.0
    var matchEventViewTopMargin : CGFloat = 5.0
    var matchEventViewBottomMargin : CGFloat = 5.0
    
    let floatingButtonHeight : CGFloat = 40.0
    let floatingButtonWidth : CGFloat = 40.0
    
    var sendMessagePeblHorizontalMargin : CGFloat = 20.0
    var sendMessagePeblTopMargin : CGFloat = 100.0
    var sendMessagePeblHeight : CGFloat = 220.0
    var sendMessagePeblOffsetFrame : CGRect!
    var sendMessagePeblVisibleFrame : CGRect!
    var sendMessagePeblAlpha : CGFloat = 0.8
    
    var userID : String!
    
    ///////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get Current User UID from Firebase Auth
        userID = FIRAuth.auth()?.currentUser?.uid

        // Styling from Master Style
        self.styleMenu()
        self.navigationController?.styleTitle("Matches")
        self.view.backgroundColor = UIColor.clear
        
        // Firebase Setup ///////////////////////////////////////
        self.ref = FIRDatabase.database().reference()
        self.cld = CLDCloudinary(configuration: CLDConfiguration(cloudName: AppDelegate.cloudName, secure: true))

        // Initizlie Setup and Page
        self.initializeMatchTable()
        self.createFloatingButton()
        self.initializeMessagePeblView()
        
        //////////////////////////////////////////////////////////////////////////////
        // Attach Asynchronous Listener for User Matches Endpoint
        let downloadQueue = DispatchQueue(label:"downloadQueue",qos:.default, target:nil)
        let group = DispatchGroup()
        
        // Initial Data Download ///////////////////////////
        self.ref.child("user_matches").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren(){
                
                self.spinner.startAnimating()
                self.spinner.alpha = 1.0
                
                // Loop Over All Children Matches
                for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    
                    ///////// Asynchronous Download for Single User Data
                    group.enter()
                    downloadQueue.async(group: group,  execute: {
                        self.handleChildData(child,completion: { (newMatch) -> () in
                            group.leave()
                            DispatchQueue.main.async {
                                self.handleMatch(match:newMatch)
                            }
                        })
                    })
                    ///////// When Download for All Matches Finishes
                    group.notify(queue: DispatchQueue.main, execute: {
                        DispatchQueue.main.async {
                            self.attachUpdateListeners() // Attach Listeners for Updates
                            
                            // Stop Spinning Animation
                            self.spinner.startAnimating()
                            self.spinner.alpha = 1.0
                        }
                    })  
                } // End For Loop
                
            }
        })

    }
    ///////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Attach Update Listeners when View Appears for Updates to Views
        //self.attachUpdateListeners()
    }
    ///////////////////////////////////////
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.ref.removeAllObservers()
    }
    ///////////////////////////////////////////////////////////
    // Takes Snapshot Child Data and Creates New Match Object From It
    func handleChildData(_ child:FIRDataSnapshot,completion: @escaping (Match)->()){
        
        // To Do: Need to continue to load other images for the matched user, but we are going to want to
        // not hold up the thread for loading the data and instead do this in the background.
        let newMatch = Match(userID: self.userID, snapshot: child)

        // Get User Data and Attach to Match Object -
        let matchedUser : User = User(userID: newMatch.matchedUserID)

        // Asynchronously Load the User Status and User Info at the Same Time
        let getUserDataQueue = DispatchQueue(label:"getUserDataQueue",qos:.default, target:nil)
        let group = DispatchGroup()
        
        /// Group 1
//        group.enter()
//        getUserDataQueue.async {
//            matchedUser.loadUserInfo(ref: self.ref, {(finished) -> () in
//                // Photo IDS Retrieved - Now Get Profile Image
//                matchedUser.userInfo.loadImage(cld: self.cld, imageNumber: 0, {(finished) -> () in
//                    group.leave()
//                })
//            })
//        }
        /// Group 2
        group.enter()
        getUserDataQueue.async {

        
                self.ref.child("user_status").child(matchedUser.userID).observeSingleEvent(of: .value, with: {snapshot in
                    
                    if snapshot.exists(){
                        matchedUser.userStatus = UserStatus(userID: self.userID, snapshot: snapshot)
                        
                        matchedUser.userStatus.loadUserVenue({(finished) -> () in
                            // Populate data before loading image

//                            matchedUser.userStatus.userVenue.loadImage(completion: {(finished) -> () in
//                                group.leave()
//                                
//                            })
                        })
                    }
                })
        }

        
//                matchedUser.userStatus.loadUserVenue(ref: self.ref, {(finished) -> () in
//                    group.leave()
//                })
            //})
        //}
        // When asynchronous groups complete, return new match object that contains all the downloaded data
        group.notify(queue: DispatchQueue.main, execute: {
            DispatchQueue.main.async {
                newMatch.user = matchedUser
                completion(newMatch)
            }
        })
    }
    ///////////////////////////////////////
    // Handles Downloaded Match Data
    func handleMatch(match:Match){

        // Keep Track of Number of Existing Message Pebls
        numMatches = numMatches + 1
        self.matches.setObject(match, forKey: match.matchedUserID as NSCopying)
        
        // Add Messge Pebl to Table VC
        let indexPath = IndexPath(row: self.matches.count-1, section: 0)
        matchTableVC.addMatch(match:match,indexPath:indexPath)
    }
    ///////////////////////////////////////
    // Creates Pebl Table for Existing Pebls
    func initializeMatchTable(){
        
        // Create Table View for Current Messages
        let storyBoard : UIStoryboard = UIStoryboard(name: "Base", bundle:nil)
        matchTableVC = storyBoard.instantiateViewController(withIdentifier: "MatchesTableVC") as! MatchesTableVC
        matchTableVC.view.frame = self.view.frame
        
        // Assign Delegate
        matchTableVC.delegate = self
        
        self.view.addSubview(matchTableVC.tableView)
        self.view.bringSubview(toFront: matchTableVC.tableView)
        
        matchTableVC.willMove(toParentViewController: self)
        self.addChildViewController(matchTableVC)
        matchTableVC.didMove(toParentViewController: self)
    }
    ////////////////////////////////////////////////////////////////////
    // Initializes the Message Pebl View and Hides Off Screen
    func initializeMessagePeblView(){
        
        self.sendMessagePeblView.translatesAutoresizingMaskIntoConstraints = true
        self.sendMessagePeblView.delegate = self
        
        sendMessagePeblOffsetFrame = CGRect(x: sendMessagePeblHorizontalMargin,y: self.view.bounds.maxY,width: self.view.bounds.width - 2.0*sendMessagePeblHorizontalMargin,height: sendMessagePeblHeight)
        
        sendMessagePeblVisibleFrame = CGRect(x: sendMessagePeblHorizontalMargin,y: sendMessagePeblTopMargin,width: self.view.bounds.width - 2.0*sendMessagePeblHorizontalMargin,height: sendMessagePeblHeight)
        self.sendMessagePeblView.frame = sendMessagePeblOffsetFrame
    }
    
    ///////////////////////////////////////////////////////////
    // Attaches Listeners for Updates to User Info or Event
    func attachUpdateListeners(){
        
        // Attach Listener for Event Changes
//        self.eventRef.observe(.childChanged, with: {snapshot in
//            if let update_event_dataDict = snapshot.value as? NSDictionary{
//                if snapshot.exists(){
//                    let userID = snapshot.key
//                    // Create Updated Event
//                    let updatedEvent = UserEvent()
//                    updatedEvent.event_name = update_event_dataDict["event_name"] as? String
//                    updatedEvent.event_time = update_event_dataDict["event_time"] as? String
//                    
//                    // Update Existing Match with New Event
//                    let existingMatch = self.matches[userID] as? Match
//                    existingMatch?.user?.userEvent = updatedEvent
//                    existingMatch?.eventUpdate = true
//                    self.tableView.reloadData()
//                }
//            }
//        })
        
    }    
    ///////////////////////////////////////////////////////////
    // Creates Floating Button for Pebls in Bottom Right
    func createFloatingButton(){
        
        let floatingFrame = CGRect(x: self.view.frame.maxX - floatingButtonWidth-20.0, y: self.view.frame.maxY - floatingButtonHeight-160.0, width: floatingButtonWidth, height: floatingButtonHeight)
        floatingButton = MessagePeblFloatingButton(frame: floatingFrame)
        floatingButton.delegate = self
        self.view.addSubview(floatingButton)
        self.view.bringSubview(toFront: floatingButton)
    }
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// MARK: Table Cell Delegate

extension MatchesViewController{
    
    // Shows Users Profile
    internal func showProfile(matchTableViewCell:MatchTableViewCell){
        
        let showMatch = matchTableViewCell.match!
        let user = showMatch.user!
            
        // Initialize New Profile VC
        self.currentProfileVC = self.storyboard!.instantiateViewController(withIdentifier: "MatchProfileVC") as? MatchProfileVC
        if self.currentProfileVC != nil {
            
            // Pass In Required Data to Profile VC
            self.currentProfileVC!.user = user
            self.currentProfileVC!.ref = self.ref
            //self.currentProfileVC!.storageRef = self.storageRef
            
            self.navigationController?.pushViewController(self.currentProfileVC!, animated: false) // Present View Controller
        }
            
        
    }
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// MARK: Send Message Pebl Delegate

extension MatchesViewController{
    
    // Closes Modal to Send Message Pebl //////////
    internal func closeResponseModal(sender: SendMessagePeblView) {
        self.closeMessagePeblView()
    }
}


//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// MARK: Floating Button Delegate


extension MatchesViewController{

    // Activates View to Select Message Pebl Recipient
    internal func optionActivated(messagePeblFloatingButton: MessagePeblFloatingButton){
        matchTableVC.activateMessagePeblMode()
    }
    // Deactivates View to Select Message Pebl Recipient
    internal func optionDeactivated(messagePeblFloatingButton: MessagePeblFloatingButton){
        matchTableVC.deactivateMessagePeblMode()
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// MARK: MatchTableVCDelegate

extension MatchesViewController{
    
    // Function to Bring Black Faded View Over Background When Modal Present
    func toggleCoverAlphaView(){
        if alphaModeActive{
            coverAlphaView.removeFromSuperview()
            self.alphaModeActive = false
        }
        else{
            coverAlphaView = UIView(frame: self.view.bounds)
            coverAlphaView.backgroundColor = secondaryColor
            coverAlphaView.alpha = sendMessagePeblAlpha
            self.view.addSubview(coverAlphaView)
            self.view.bringSubview(toFront: coverAlphaView)
            
            self.alphaModeActive = true
        }
    }
    // Closes Modal to Send Message Pebl //////////
    func closeMessagePeblView(){
        self.sendMessagePeblView.alpha = 0.0
        // Move Message Pebl View Back Down Below
        self.sendMessagePeblView.frame = sendMessagePeblOffsetFrame
        self.toggleCoverAlphaView()
        self.alphaModeActive = false
    }
    
    // Brings in Modal to Send Message Pebl //////////
    internal func showMessagePeblView(matchTableViewCell: MatchTableViewCell) {
        
        self.toggleCoverAlphaView()
        self.sendMessagePeblView.setup(match:matchTableViewCell.match)
        
        // Animate Modal View for Message Pebl Coming Up
        UIView.animate(withDuration: TimeInterval(0.4), animations: {
            self.sendMessagePeblView.frame = self.sendMessagePeblVisibleFrame
            self.sendMessagePeblView.alpha = 1.0
            self.view.bringSubview(toFront: self.sendMessagePeblView)
        })
        
        // Deactivate Plus Button
        self.floatingButton.deactivate()
    }
    
    // Removes View for Event //////////
    internal func hideMatchEvent(matchTableViewCell: MatchTableViewCell) {
        
        // Animate View Moving Into Screen
        UIView.animate(withDuration: 0.3, animations: {
            
            // Move View with Frame Outside Bounds
            self.matchEventVC.view.frame = CGRect(x: self.view.bounds.maxX, y: self.matchTableVC.cellHeight, width: self.view.bounds.width-2.0*self.matchEventViewHorizontalMargin, height: self.view.frame.height - self.matchTableVC.cellHeight-self.matchEventViewHorizontalMargin-self.matchEventViewBottomMargin)
            
            self.eventShadowView.frame = self.matchEventVC.view.frame
        })
        
        eventShadowView.removeFromSuperview()
        matchEventVC.view.removeFromSuperview()
    }
    
    // Brings In View for Event //////////
    internal func showMatchEvent(matchTableViewCell: MatchTableViewCell) {
        
        // Instantiate Event VC for Match Event
        self.matchEventVC = self.storyboard!.instantiateViewController(withIdentifier: "MatchEventVC") as? MatchEventVC
        
        let match = matchTableViewCell.match!
        matchEventVC.match = match
        matchEventVC.view.translatesAutoresizingMaskIntoConstraints = true
        
        // Setup View with Frame Outside Bounds
        matchEventVC.view.frame = CGRect(x: self.view.bounds.maxX, y: matchTableVC.cellHeight, width: self.view.bounds.width-2.0*matchEventViewHorizontalMargin, height: self.view.frame.height - self.matchTableVC.cellHeight-matchEventViewHorizontalMargin-matchEventViewBottomMargin)
        
        eventShadowView = UIView(frame: self.matchEventVC.view.frame)
        
        eventShadowView.layer.borderColor = accentColor.cgColor
        eventShadowView.layer.borderWidth = 0.6
        eventShadowView.layer.cornerRadius = 5.0
        eventShadowView.layer.masksToBounds = false
        eventShadowView.layer.backgroundColor = UIColor.white.cgColor
        
        // Add Shadow
        eventShadowView.layer.shadowColor = accentColor.cgColor
        eventShadowView.layer.shadowOpacity = 0.6
        eventShadowView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        self.view.addSubview(eventShadowView)
        
        // Adjusts Image View Custom Based on Image
        //matchEventVC.adjust()
        self.view.addSubview(matchEventVC.view)
        self.view.bringSubview(toFront: matchEventVC.view)
        
        // Animate View Moving Into Screen
        UIView.animate(withDuration: 0.3, animations: {
            
            self.matchEventVC.view.frame = CGRect(x: self.view.bounds.minX+self.matchEventViewHorizontalMargin, y: self.matchTableVC.cellHeight+self.matchEventViewTopMargin, width: self.view.bounds.width-2.0*self.matchEventViewHorizontalMargin, height: self.view.frame.height - self.matchTableVC.cellHeight-self.matchEventViewHorizontalMargin-self.matchEventViewBottomMargin)
            
            self.eventShadowView.frame = self.matchEventVC.view.frame
            self.view.bringSubview(toFront: self.matchEventVC.view)
        })
        
    }
    
    
}
