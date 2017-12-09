//
//  MatchProfileVC.swift
//  Pebl
//
//  Created by Nick Florin on 11/9/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import Dispatch
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Cloudinary

//////////////////////////////////////////////////////////////////////////////////////
class MatchProfileVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var matchEventTileView: MatchEventTileView!
    @IBOutlet weak var eventImageView: UIImageView!
    var profileInfoView : ProfileInfoView!
    
    var profileInfoVisibleFrame : CGRect!
    var profileInfoHiddenHeight : CGFloat = 90.0
    var profileInfoHiddenFrame : CGRect!
    var infoShowing : Bool = false
    
    var infoSlidUp : Bool = false
    var infoOffset : CGFloat = 345.0
    var alphaViewAlpha : CGFloat = 0.6
    
    var infoButton : InfoButton!
    var infoButtonWidth : CGFloat = 100.0
    var infoButtonHeight : CGFloat = 40.0
    var infoButtonYOffset : CGFloat = 20.0
    
    // Firebase References
    var ref: FIRDatabaseReference!
    var cld : CLDCloudinary!
    
    var user : User!
    var userImages : [UIImage]!
    
    var currentIndex : Int = 0
    var Pages : [ProfileImagePage] = []
    
    @IBOutlet weak var pageControl: UIPageControl!
    private var pendingIndex: Int = 0
    var pageViewController: ProfileImagePageViewController!
    
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cld = CLDCloudinary(configuration: CLDConfiguration(cloudName: AppDelegate.cloudName, secure: true))
        
        self.matchEventTileView.layer.borderColor = UIColor.clear.cgColor
        self.matchEventTileView.layer.borderWidth = 1.3
        self.matchEventTileView.layer.shadowColor = secondaryColor.cgColor
        self.matchEventTileView.layer.shadowOpacity = 0.6
        self.matchEventTileView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        // Setup Page View Controller
        pageViewController = ProfileImagePageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
    
        // Give Delegate
        pageViewController.dataSource = self
        pageViewController.delegate = self
    
    }
    ///////////////////////////////////////////
    override func viewDidLayoutSubviews() {
        
        // Add Page View Controller View to Container and Add Child
        pageViewController.view.frame = self.imageContainer.bounds
        
        self.imageContainer.addSubview(pageViewController.view)
        pageViewController.willMove(toParentViewController: self)
        self.addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: self)
        
        pageViewController.currentIndex = 0
        
        /// Setup Profile Info
        profileInfoVisibleFrame = CGRect(x: 8.0, y: self.imageContainer.frame.minY+5.0, width: self.view.bounds.width - 16.0, height: self.imageContainer.frame.height - 5.0)
        profileInfoHiddenFrame = CGRect(x: 8.0, y: self.imageContainer.frame.maxY - profileInfoHiddenHeight, width: self.view.bounds.width - 16.0, height: profileInfoHiddenHeight)
        
        profileInfoView = ProfileInfoView(frame:profileInfoHiddenFrame)
        profileInfoView.backgroundColor = UIColor.clear
        profileInfoView.clipsToBounds = true
        
        self.view.addSubview(profileInfoView)
        self.view.bringSubview(toFront: self.profileInfoView)
        
        // Setup Button
        let buttonFrame = CGRect(x: self.imageContainer.frame.maxX - infoButtonWidth, y: self.imageContainer.frame.maxY - infoButtonHeight - infoButtonYOffset, width: infoButtonWidth, height: infoButtonHeight)
        infoButton = InfoButton(frame: buttonFrame)
        
        infoButton.addTarget(self, action: #selector(self.toggleProfileInfo), for: .touchUpInside)
        
        self.view.addSubview(infoButton)
        self.view.bringSubview(toFront: infoButton)
        
        if self.user != nil {
            self.setup()
        }

        let dummyEvent = UserEvent(userID: "Test")
        self.matchEventTileView.setup(event:dummyEvent)
        
    }
    ///////////////////////////////////////////
    // Populate Info from Match Object
    func setup(){
        
        // Setup Profile Info
        self.profileInfoView.userInfo = self.user!.userInfo
        self.profileInfoView.setup()
    
        // Assign Match Images to Profile Page VC
        
        // Need to load all of the images, not just profile image
        self.userImages = []
        self.user.userInfo.loadImage(cld: self.cld, imageNumber: 0, {(image) -> () in
            self.userImages.append(image)
            self.setupPageView()
        })
    }
    
    ///////////////////////
    func toggleProfileInfo(){
        if infoShowing{
            
            self.profileInfoView.dottedLines1.hideDots()
            self.profileInfoView.dottedLines2.hideDots()
            
            UIView.animate(withDuration: TimeInterval(0.5), animations: {
                self.profileInfoView.frame = self.profileInfoHiddenFrame
            })
            self.infoShowing = false
        }
        else{
            
            self.profileInfoView.dottedLines1.drawDots()
            self.profileInfoView.dottedLines2.drawDots()
            
            UIView.animate(withDuration: TimeInterval(0.5), animations: {
                self.profileInfoView.frame = self.profileInfoVisibleFrame
            })
            self.infoShowing = true
        }
    }
    
    ///////////////////////////////////////////////////////////
    // MARK: Datasource for Page View Controller

    // Populates and Sets Up Page View Controllers for Images
    func setupPageView(){
        
        var countIndex = 0
        for image in self.userImages{
            let newVC = ProfileImagePage()
            
            newVC.index = countIndex
            newVC.alphaViewAlpha = self.alphaViewAlpha
            newVC.setup(image:image)
            self.Pages.append(newVC)
            countIndex = countIndex + 1
        }
        
        // Default Behavior
        let initialVC = self.getViewControllerAtCurrentIndex()
        var initialVCList : [UIViewController] = []
        initialVCList.append(initialVC)
        pageViewController.setViewControllers(initialVCList, direction: .forward, animated: false, completion: nil)
    }
    ///////////////////////
    // Gets the View Controller in [ViewController] Corresponding to Index
    func getViewControllerAtCurrentIndex()->UIViewController{
        
        var foundViewController : UIViewController!
        for page in self.Pages{
            if page.index == self.currentIndex{
                foundViewController = page
            }
        }
        return foundViewController
    }
    ///////////////////////
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentIndex == 0 {
            return nil
        }
        // Decrement Index
        currentIndex = abs((self.currentIndex - 1) % self.Pages.count)
        pendingIndex = currentIndex
        return getViewControllerAtCurrentIndex()
    }
    ///////////////////////
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if currentIndex == self.Pages.count-1{
            return nil
        }
        // Decrement Index
        currentIndex = abs((self.currentIndex + 1) % self.Pages.count)
        pendingIndex = currentIndex
        return getViewControllerAtCurrentIndex()
    }
    //////////////////////
    // Delegate for controlling the page control indicator
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if completed {
            currentIndex = pendingIndex
            pageControl.currentPage = currentIndex
        }
    }
}




