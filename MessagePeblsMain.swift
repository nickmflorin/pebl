//
//  MessagePeblsVCViewController.swift
//  Pebl2
//
//  Created by Nick Florin on 12/28/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

//////////////////////////////////////////////////////////////////////////////
class MessagePeblsViewController: UIViewController {
    
    ///////////////////////////////////////
    // Mark: Properties
    
    // Sliders, Headers and Tables
    var messagePeblSlider : MessagePeblSlider!
    var messagePeblTableVC : MessagePeblTableVC! // Message Pebl Table
    var messagePeblSliderHeader : PeblHeader!
    var messagePeblTableHeader : PeblHeader!
    
    var sliderLayout : UICollectionViewFlowLayout!
    
    // Progress Indicators
    var indicator : UIActivityIndicatorView?
    var spinner : loadingIndicator!
    
    // Pebl Response View
    var messagePeblResponseView : MessagePeblResponseView!
    
    // Screen Shot View for Blur and Background of Modal
    var screenShotView : UIImageView!

    ///////////////////////////////////////
    //MARK : Variables
    
    // Firebase
    var ref: FIRDatabaseReference!
    var storageRef:FIRStorageReference!
    var received_messagepeblRef : FIRDatabaseReference!
    var userRef : FIRDatabaseReference!
    
    var userID : String?
    var currentIndex : Int?
    
    // Keep Track of Pebls Downloaded
    var numNewMessagePebls : Int = 0
    var numMessagePebls : Int = 0
    var newMessagePebls = NSMutableDictionary()
    var activeMessagePebls = NSMutableDictionary()
    
    // Parameters for Message Modal View
    var messageResponseFrame : CGRect!
    var messageModalTopY : CGFloat = 100.0
    var messageModalHorizontalInset : CGFloat = 30.0
    var messageModalHeight : CGFloat = 120.0
    
    // Parameters for Slider for New Pebls
    var sliderHorizontalMargin : CGFloat = 0.0
    var sliderVerticalMargin : CGFloat = 15.0
    var sliderVerticalPadding : CGFloat = 3.0
    var messagePeblSliderHeight : CGFloat = 140.0
    
    var messagePeblSliderFrame : CGRect!
    var messagePeblTableFrame : CGRect!
    
    var headerRectHeight : CGFloat = 32.0
    var headerRectVerInset : CGFloat = 0.0
    
    ///////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Current User UID from Firebase Auth
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        // Firebase Setup ///////////////////////////////////////
        self.ref = FIRDatabase.database().reference()
        self.storageRef = FIRStorage.storage().reference()
        //self.received_messagepeblRef = self.ref.child("user-pebls").child(userID!).child("message-pebls").child("received")
        self.userRef = self.ref.child("users")
        
        // Setup Slider View and Header
        self.initializeSliderHeader()
        self.initializePeblSlider()
        
        // Setup Table View and Header
        self.initializeTableHeader()
        self.initializePeblTable()
        
        self.useFakePebls()
        
        ////////////////////////////////////////////////////////////////////////////////////
        
        // Attach Asynchronous Listener for User Matches Endpoint
//        let downloadQueue = DispatchQueue(label:"downloadQueue",qos:.default, target:nil)
//        let group = DispatchGroup()
//        
//        // Initial Data Download ///////////////////////////
//        self.received_messagepeblRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if snapshot.hasChildren(){
//                
//                //self.parentVC?.progressIndicator.startAnimating()
//                //self.parentVC?.progressIndicator.alpha = 1.0
//                
//                for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
//                    
//                    ///////// Asynchronous Download for Single User Data //////////////
//                    group.enter()
//                    downloadQueue.async(group: group,  execute: {
//                        self.downloadChildData(child,completion: { (newMessagePebl) -> () in
//                            group.leave()
//                            DispatchQueue.main.async {
//                                
//                                /// Determine How to Handle Pebl Based on if it is Viewed or Not
//                                if let peblViewed = newMessagePebl.viewed! as Bool! { // Unwrap
//                                    // Put Pebl in Table
//                                    if peblViewed{
//                                        
//                                        // Create New Table Veresion of Message Pebl (Convenience Object)
//                                        let newTableMessagePebl = tableMessagePebl(userID:newMessagePebl.userID!)
//                                        newTableMessagePebl.messagePebl = newMessagePebl
//                                        let indexPath = IndexPath(item: self.messagePebls.count-1, section: 0)
//                                        newTableMessagePebl.indexPath = indexPath
//                                        
//                                        //messagePeblTableVC.addMessagePebl(newTableMessagePebl:newTableMessagePebl)
//                                        
//                                    }
//                                    // Put Pebl in Thumbnails
//                                    else{
//                                        self.messagePeblSlider.addMessagePebl(newMessagePebl)
//                                    }
//                                }
//                            }
//                        })
//                    })
//                    ///////// When Download for All Matches Finishes /////////////////
//                    group.notify(queue: DispatchQueue.main, execute: {
//                        DispatchQueue.main.async {
//                            //self.attachUpdateListeners() // Attach Listeners for Updates
//                            //self.parentVC?.progressIndicator.stopAnimating()
//                            //self.parentVC?.progressIndicator.alpha = 0.0
//                        }
//                    })
//                } // End For Loop
//            }
//        })
    }
    ///////////////////////////////////////
    // Development Function Only
    func useFakePebls(){
//        // Generate and Retrieve Fake Message Pebls
//        let newPebls = generateFakeMessagePebls()
//        for pebl in newPebls{
//            self.handlePebl(messagePebl: pebl)
//        }
    }
    ///////////////////////////////////////
    // Determines Where to Put Pebl Based on if it is Viewed or Not
    func handlePebl(messagePebl:MessagePebl){
        
        // Determine How to Handle Pebl Based on if it is Viewed or Not
        if let peblViewed = messagePebl.viewed! as Bool! { // Unwrap
            // Put Pebl in Table
            if peblViewed{
                
                // Keep Track of Number of Existing Message Pebls
                numMessagePebls = numMessagePebls + 1
                self.messagePeblTableHeader.updateCount(count:numNewMessagePebls)
                
                self.activeMessagePebls.setObject(messagePebl, forKey: messagePebl.userID as! NSCopying)
                
                // Add Messge Pebl to Table VC
                let indexPath = IndexPath(item: self.activeMessagePebls.count-1, section: 0)
                messagePeblTableVC.addMessagePebl(messagePebl:messagePebl,indexPath:indexPath)
                
            }
            // Put Pebl in Thumbnails
            else{
                
                self.newMessagePebls.setObject(messagePebl, forKey: messagePebl.userID as! NSCopying)
                
                self.messagePeblSlider.addMessagePebl(messagePebl)
                // Keep Track of Number of New Message Pebls
                numNewMessagePebls = numNewMessagePebls + 1
                // Keep Track of Number of New Message Pebls in Header
                self.messagePeblSliderHeader.updateCount(count:numNewMessagePebls)
            }
        }
    }
    ///////////////////////////////////////
    // Functions that Creates Header for Pebl Slider and Table Showing Pebls
    func initializeSliderHeader(){
        
        let headerRect = CGRect(x: self.view.frame.minX, y: self.view.frame.minY+headerRectVerInset, width: self.view.frame.width, height: self.headerRectHeight)
        messagePeblSliderHeader = PeblHeader(frame: headerRect)
        messagePeblSliderHeader.setup(headerText:"New")
        self.view.addSubview(messagePeblSliderHeader)
    }
    ///////////////////////////////////////
    func initializeTableHeader(){
        
        // Figure Out Why +125.0 is Necessary
        let tableHeaderY : CGFloat = sliderLayout.itemSize.height + 35.0
        let headerRect = CGRect(x: self.view.frame.minX, y: tableHeaderY, width: self.view.frame.width, height: self.headerRectHeight)
        
        messagePeblTableHeader = PeblHeader(frame: headerRect)
        messagePeblTableHeader.setup(headerText:"Active")
        self.view.addSubview(messagePeblTableHeader)
    }
    ///////////////////////////////////////
    // Creates Pebl Slider for New Pebls
    func initializePeblSlider(){
        
        // Create Thumbnail Slider at Top for New Message Pebls
        sliderLayout = UICollectionViewFlowLayout()
        sliderLayout.sectionInset = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        sliderLayout.itemSize = CGSize(width: 85, height: 110)
        sliderLayout.scrollDirection = .horizontal
        
        sliderLayout.minimumLineSpacing = 8.0 /// Makes Single Row
        sliderLayout.minimumInteritemSpacing = 8.0
        
        messagePeblSlider = MessagePeblSlider(collectionViewLayout: sliderLayout)
        messagePeblSlider.collectionView?.showsHorizontalScrollIndicator = true
        messagePeblSlider.collectionView?.backgroundColor = UIColor.white
        
        // Create Frame to Allow for Padding with Cell Height and Width
        // Need to Figure Out Issue of Height Not Making Sense for Message Pebl Slider Frame (it effects the vertical position of the table header)
        
        messagePeblSliderFrame = CGRect(x: self.view.frame.minX, y: self.messagePeblSliderHeader.frame.maxY, width: self.view.frame.width, height: sliderLayout.itemSize.height + 165.0)
        messagePeblSlider.collectionView?.frame = messagePeblSliderFrame
        self.view.insertSubview(messagePeblSlider.collectionView!, at: 1)
    }
    ///////////////////////////////////////
    // Creates Pebl Table for Existing Pebls
    func initializePeblTable(){
        
        // Create Table View for Current Messages
        let storyBoard : UIStoryboard = UIStoryboard(name: "Base", bundle:nil)
        messagePeblTableVC = storyBoard.instantiateViewController(withIdentifier: "MessagePeblTableVC") as! MessagePeblTableVC
        
        // Find Frame for Leftover Portion of View
        let tableY = messagePeblTableHeader.frame.maxY
        messagePeblTableFrame = CGRect(x: self.view.frame.minX, y: tableY, width: self.view.bounds.width, height: self.view.frame.maxY-tableY)
        messagePeblTableVC.view.frame = messagePeblTableFrame
        
        self.view.addSubview(messagePeblTableVC.tableView)
        self.view.bringSubview(toFront: messagePeblTableVC.tableView)
        
        messagePeblTableVC.willMove(toParentViewController: self)
        self.addChildViewController(messagePeblTableVC)
        messagePeblTableVC.didMove(toParentViewController: self)
    }
    ///////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    ///////////////////////////////////////
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //self.ref.removeAllObservers()
        //self.received_messagepeblRef.removeAllObservers()
        //self.userRef.removeAllObservers()
        
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
    ///////////////////////////////////////
    // Creates Screen Shot View with Blur Effect for Background During Modal
    func createScreenShotView(){
        
        // Create Screenshot of Background
        UIGraphicsBeginImageContext(self.view.bounds.size)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIGraphicsEndImageContext()
        
        // Create Image View from Screen Shot
        screenShotView = UIImageView(frame: self.view.bounds)
        screenShotView.clipsToBounds = true
        screenShotView.image = screenshot
        
        // Create Blur Effect For Image View
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = screenShotView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.9
        
        // Add Blur Effect to Image View
        screenShotView.addSubview(blurEffectView)
    }
    ///////////////////////////////////////
    // MARK: Cell Delegate Commands
    
    // Function that Notifies Main Table View that Message Pebl Response Has been Clicked
    internal func messagePeblRespond(sender:MessagePeblTableViewCell){
        
        // Create Screenshot of Background
        self.createScreenShotView()
        
        // Add Blurred Screenshot as Subview
        self.view.addSubview(screenShotView)
        self.view.bringSubview(toFront: screenShotView)
        
        // Create Modal REsponse View
        messageResponseFrame = CGRect(x: messageModalHorizontalInset, y: messageModalTopY, width: self.view.bounds.width - 2.0*messageModalHorizontalInset, height: messageModalHeight)
        messagePeblResponseView = MessagePeblResponseView(frame: messageResponseFrame)
        
        // Setup Message Pebl Response View
        messagePeblResponseView.setup(messagePebl: sender.messagePebl)
        // Assign Delegate to Pebl Response View
        //messagePeblResponseView.delegate = self
        
        self.view.addSubview(messagePeblResponseView)
        self.view.bringSubview(toFront: messagePeblResponseView)
    }
    
    /////////////////////////////
    // Delegated when Close Button of Response View Clicked
    internal func closeResponseModal(sender: MessagePeblResponseView){
        
        // Remove the Message Pebl Response View from Superview
        if messagePeblResponseView != nil{
            messagePeblResponseView.removeFromSuperview()
            // Remove Blurred Screenshot from Background
            screenShotView.removeFromSuperview()
        }
    }

    
}
