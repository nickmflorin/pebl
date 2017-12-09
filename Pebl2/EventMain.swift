//
//  EventViewController.swift
//  Pebl
//
//  Created by Nick Florin on 7/10/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import PagingMenuController
import FirebaseAuth
import Firebase
import FirebaseStorage

struct TestObject {
    
    var check : String = ""
    
}
///////////////////////////////////////////
class EventViewController: UIViewController, EventTableViewControllerPinnedDelegate, EventTableViewControllerFeedDelegate {
    
    // MARK: Properties
    //@IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var menuPadding : CGFloat = 3.0 // Spacing between bottom of Menu View and Table
    
    //////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spinner.alpha = 0.0
        
        // Attach Listener on Search Field for When Search Finishes
        //searchField.addTarget(self, action: #selector(self.searchEvents), for: .editingChanged)
        
        // Styling from Master Style
        self.styleMenu()
        self.navigationController?.styleTitle("Events")
        self.view.backgroundColor = UIColor.clear
        
        // Page View Controller Data Source
        let options = EventMenuOptions()
        
        // Add Delegates for Each 
        for vc in options.pagingControllers {
            
            if vc is EventTableViewControllerFeed {
                let eventTableVC = vc as! EventTableViewControllerFeed
                eventTableVC.delegate = self
            }
            else if vc is EventTableViewControllerPinned {
                let eventTableVC = vc as! EventTableViewControllerPinned
                eventTableVC.delegate = self
            }
        }
        
        let pagingMenuController = PagingMenuController(options: options)
        
        // Control Spacing/Layout of Page Menu View and Content View
        pagingMenuController.view.frame.origin.y += menuPadding
        pagingMenuController.view.frame.size.height -= menuPadding

        pagingMenuController.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case .didScrollStart:
                print("Scroll start")
            case .didScrollEnd:
                print("Scroll end")
            }
        }
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)

    }
    ///////////////////////////////////////////
    override func viewDidLayoutSubviews() {
        //self.originalTableFrame = CGRect(x: self.containerView.frame.minX, y: self.containerView.frame.minY, width: self.containerView.frame.width, height: self.containerView.frame.height)
        //self.offsetTableFrame = CGRect(x: self.originalTableFrame.minX, y: self.originalTableFrame.minY + self.filterHeightOffset, width: self.originalTableFrame.width, height: self.originalTableFrame.height - self.filterHeightOffset)
    }
    
    // Search venues from API when text field finishes editing
    func searchEvents(){
//        if let searchText = searchField.text {
//            
//            self.spinner.alpha = 1.0
//            self.spinner.startAnimating()
//            
//            // Clear Current Data
//            self.tableVC.clearPlaces()
//            //self.tableVC.searchMorePlaces(searchString:searchText)
//        }
    }
    
    
    
    // Mark: Table View Controller Delegate
    internal func showSpinner(sender: UIViewController){
        self.view.bringSubview(toFront: self.spinner)
        self.spinner.alpha = 1.0
        self.spinner.startAnimating()
    }
    ///////////
    internal func hideSpinner(sender: UIViewController){
        self.spinner.alpha = 0.0
        self.spinner.stopAnimating()
    }
    ////////////
    internal func showVenue(venue:Venue){
        
        // Initialize New Profile VC
        let detailVC = VenueDetailViewController.instantiateFromStoryboard()
        
        // Need to force VC to load hierarchy by referencing its view.
        detailVC.view.backgroundColor = UIColor.white
        detailVC.setup(venue:venue)
        
        // For development ease, print venue ID to console so that we have a reference.
        log.info("Print Opening Venue : \(venue.id)")
        
        self.navigationController?.pushViewController(detailVC, animated: false) // Present View Controller
    }
    
    
    ///////////////////////////////////////////
    // MARK: Actions
    @IBAction func menu_buttonToggle() {
        let baseVC = self.parent?.parent?.parent as! BaseViewController
        baseVC.toggleMenu()
    }

}


