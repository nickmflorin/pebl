//
//  SuggestionPeblsViewController.swift
//  Pebl2
//
//  Created by Nick Florin on 1/3/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase
import FirebaseDatabase

////////////////////////////////////////////////////////////////////////////
class SuggestionPeblsViewController: UIViewController {
    
    ///////////////////////////////////////
    //MARK : Properties
    
    // Sliders, Headers and Tables
    var suggestionPeblTableVC : SuggestionPeblTableVC! // Match Table
    
    // Progress Indicators
    //var indicator : UIActivityIndicatorView?
    //var spinner : loadingIndicator!
    
    // Firebase References
    var ref: FIRDatabaseReference!
    var storageRef:FIRStorageReference!
    var received_suggestionPeblRef : FIRDatabaseReference!
    var userRef : FIRDatabaseReference!
    
    // Keep Track of Pebls Downloaded
    var numSuggestionPebls : Int = 0
    var allSuggestionPebls : [SuggestionPebl] = []
    var suggestionPebls = Dictionary<String, Array<SuggestionPebl>>()
    var numUniqueUsers : Int = 0
    
    ///////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Current User UID from Firebase Auth
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        // Firebase Setup ///////////////////////////////////////
        self.ref = FIRDatabase.database().reference()
        self.storageRef = FIRStorage.storage().reference()
        self.userRef = self.ref.child("users")
        self.received_suggestionPeblRef = self.ref.child("user-pebls").child(userID!).child("suggestion-pebls").child("received")
        
        // Setup Table View
        self.initializeSuggestionPeblTable()
        self.useFakePebls()
        
        // Attach Asynchronous Listener for User Matches Endpoint
//        let downloadQueue = DispatchQueue(label:"downloadQueue",qos:.default, target:nil)
//        let group = DispatchGroup()
        
//        //////////////////////////////////////////////////////////////////////////////
//        // Initial Data Download ///////////////////////////
//        self.received_suggestionPeblRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if snapshot.hasChildren(){
//                
//                //self.parentVC?.progressIndicator.startAnimating()
//                //self.parentVC?.progressIndicator.alpha = 1.0
//                
//                for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
//                    ///////// Synchonous Download for Single User Data //////////////
//                    group.enter()
//                    downloadQueue.async(group: group,  execute: {
//                        self.downloadChildData(child,completion: { (newSuggestionPebl) -> () in
//                            let userID = newSuggestionPebl.userID! as String
//                            let currentUsers = self.singleUser_suggestionPebls.allKeys as! [String]
//                            if currentUsers.contains(userID) == false{
//                                
//                                let usersPebls = NSMutableArray()
//                                let user = newSuggestionPebl.user
//                                
//                                self.users.setObject(user, forKey: userID as NSCopying)
//                                self.userIDs.add(userID)
//                                
//                                self.singleUser_suggestionPebls.setObject(usersPebls, forKey: userID as NSCopying)
//                                self.singleUser_suggestionPebls.setObject(usersPebls, forKey: userID as NSCopying)
//                            }
//                            let current_userPebls = self.singleUser_suggestionPebls.value(forKey: userID) as! NSMutableArray
//                            current_userPebls.add(newSuggestionPebl)
//                            self.singleUser_suggestionPebls.setObject(current_userPebls, forKey: userID as NSCopying)
//                            
//                            // Sort Alphabetically for Now
//                            let users = self.userIDs as AnyObject as! [String]
//                            self.sortedUsers = users.sorted{ $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending}
//                            
//                            group.leave()
//                        })
//                    })
//                } // End For Loop
//                ///////// When Download for All Pebls Finishes /////////////////
//                group.notify(queue: DispatchQueue.main, execute: {
//                    DispatchQueue.main.async {
//                        //self.parentVC?.progressIndicator.stopAnimating()
//                        //self.parentVC?.progressIndicator.alpha = 0.0
//                        self.tableView.reloadData()
//                    }
//                })
//            }
//        })
//        //////////////////////////////////////////////////////////////////////////////
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
        
        //self.ref.removeAllObservers()
        //self.received_matchPeblRef.removeAllObservers()
        //self.userRef.removeAllObservers()
        //self.eventRef.removeAllObservers()
        
    }
    ///////////////////////////////////////
    // Development Function Only
    func useFakePebls(){
        // Generate and Retrieve Fake Message Pebls
//        let newPebls = generateFakeSuggestionPebls()
//        for pebl in newPebls{
//            self.handlePebl(pebl: pebl)
//        }
    }
    ///////////////////////////////////////
    // Handles Downloaded Match Data
    func handlePebl(pebl:SuggestionPebl){
        
        let userID = pebl.userID!
        print("Handling Suggestion Pebl for User : \(userID)")
        
        // Keep Track of Number of Existing Message Pebls
        numSuggestionPebls = numSuggestionPebls + 1
        allSuggestionPebls.append(pebl)
        
        if self.suggestionPebls[userID]==nil{
            let emptySuggestionPeblList : [SuggestionPebl] = []
            numUniqueUsers = numUniqueUsers + 1
            self.suggestionPebls[userID]=emptySuggestionPeblList
        }
        
        // Update Dictionaries for Indexes with New Pebls
        if var currentUserPebls = self.suggestionPebls[userID]{
            currentUserPebls.append(pebl)
            self.suggestionPebls[userID]=currentUserPebls
        }
        
        // Add Messge Pebl to Table VC
        let indexPath = IndexPath(item: self.suggestionPebls.count-1, section: 0)
        suggestionPeblTableVC.addPebl(pebl:pebl,indexPath:indexPath)
    }
    ///////////////////////////////////////
    // Creates Pebl Table for Existing Pebls
    func initializeSuggestionPeblTable(){
        
        // Create Table View for Current Messages
        let storyBoard : UIStoryboard = UIStoryboard(name: "Base", bundle:nil)
        suggestionPeblTableVC = storyBoard.instantiateViewController(withIdentifier: "SuggestionPeblTableVC") as! SuggestionPeblTableVC
        suggestionPeblTableVC.view.frame = self.view.frame
        
        self.view.addSubview(suggestionPeblTableVC.tableView)
        self.view.bringSubview(toFront: suggestionPeblTableVC.tableView)
        
        suggestionPeblTableVC.willMove(toParentViewController: self)
        self.addChildViewController(suggestionPeblTableVC)
        suggestionPeblTableVC.didMove(toParentViewController: self)
    }
    ///////////////////////////////////////////////////////////
    // Downloads Data using Asynch Function Calls and Adds Table Cell to View
    func downloadChildData(_ child:FIRDataSnapshot,completion: @escaping (MessagePebl)->()){
        
        // Unwrap Snapshot as Dictionary
        if let dataDict = child.value as? NSDictionary{
            
            let newMessagePebl = MessagePebl()
            print("Found Child Message Pebl with Data : ",dataDict)
            
            /////// Loading Pebl Block ///////////////
            let user_id = dataDict["user_id"] as! String
            
            let peblDateString = dataDict["peblDate"] as! String
            let peblDate = convert_string_to_nsdate(peblDateString)
            
            newMessagePebl.peblDate = peblDate as Date?
            newMessagePebl.userID = user_id
            newMessagePebl.active = dataDict["active"] as? Bool
            newMessagePebl.viewed = dataDict["viewed"] as? Bool
            newMessagePebl.message = dataDict["message"] as? String
            
            // Get User Data and Attach to Pebl Object
            let messageUser = User(userID: user_id)
//            messageUser.setup(ref:self.ref,{(finished) -> () in
//                
//                newMessagePebl.user = messageUser
//                completion(newMessagePebl)
//            })
        }
    }


}
