//
//  HomeViewController+Delegate.swift
//  Pebl2
//
//  Created by Nick Florin on 1/26/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

//////////////////////////////////////////
// Mark: Notification Listener Handlers for Notifications

extension HomeViewController {
    
    // Function to add notification listeners
    func addNotificationListeners(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.venueSelected),name: NSNotification.Name(rawValue: "venueSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.cancelButtonClicked),name: NSNotification.Name(rawValue: "cancelButtonClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.nextButtonClicked),name: NSNotification.Name(rawValue: "nextButtonClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.searchButtonClicked),name: NSNotification.Name(rawValue: "searchButtonClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.categoryButtonClicked),name: NSNotification.Name(rawValue: "categoryButtonClicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.finishButtonClicked),name: NSNotification.Name(rawValue: "finishButtonClicked"), object: nil)
    }
}

//////////////////////////////////////////
// Functions Called on Notifications

extension HomeViewController {
    
    // Called from Message Field
    internal func finishButtonClicked(notification: NSNotification){
        
        let dict = notification.object as! NSDictionary
        let sender = dict["sender"] as! UIView
        let message = dict["selectedMessage"] as! String
        
        self.selectedMessage = message
        
        // Send from Time Field
        if sender is MessageSelectionView{

            // Unwrappings will crash if it finds nil value for any field - will need to change to allow for optional messsages
            let venue = self.selectedVenue!
//            print("Finishing Status : Venue ID : \(venue.venueID)")
//            if venue.venueID == "" {
//                fatalError("Cannot Finish Status - Missing Venue ID")
//            }
//            
            let time = self.selectedTime!
            let message = self.selectedMessage!
            
            // Push Data as New Status to Firebase
            self.spinner.startAnimating()
            self.user.userStatus.setNewStatus(venue: venue, eventTime: time, eventComment: message, { (completion) in
                self.spinner.stopAnimating()
                
                // Move Slider Back to Original Place and Clear Temporary Data
                self.selectedVenue = nil
                self.selectedTime = nil
                self.selectedMessage = nil
                
                self.createStatusView.eventSearchField.clear()
                self.createStatusView.defaultStates() // Default States for labels and buttons
                self.createStatusView.createStatusViewSlider.showFavoritesView() // Show Favorites View
            })
            
        }
        else{
            fatalError("Sender Not Correct for Finish Button")
        }

        
    }
    
    // Called from Search Field
    internal func categoryButtonClicked(notification: NSNotification){
        
    }
    
    // Called from Search Field
    internal func searchButtonClicked(notification: NSNotification){
        
        // Initialize New Profile VC
        self.currentEventVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeEventViewController") as? HomeEventViewController
        if self.currentEventVC != nil {

            // Pass In Required Data to Profile VC
            self.currentEventVC!.ref = self.ref
            self.currentEventVC!.userID = self.userID
            
            // Present View Controller on top of navigation stack
            self.navigationController?.pushViewController(self.currentEventVC!, animated: false)
        }
    }
    
    // Called from Time Select View to Move to Message View
    internal func nextButtonClicked(notification: NSNotification) {
        
        let dict = notification.object as! NSDictionary
        let sender = dict["sender"] as! UIView
        
        // Send from Time Field
        if sender is TimeSelectField{
            let selectedTime = dict["selectedTime"]
            self.selectedTime = selectedTime as! String!
            self.createStatusView.createStatusViewSlider.showMessageView()
            
            self.createStatusView.statesView2()
        }
        else{
            fatalError("Sender Not Correct for Next Button")
        }
    }
    
    // Called from Time Select View to Cancel
    internal func cancelButtonClicked(notification: NSNotification) {
        
        self.selectedVenue = nil
        self.selectedTime = nil
        self.createStatusView.eventSearchField.clear()
        
        self.createStatusView.defaultStates() // Default States for labels and buttons
        self.createStatusView.createStatusViewSlider.showFavoritesView() // Show Favorites View
        
    }
    
    // Called from Specific Select Favorite Cell
    internal func venueSelected(notification: NSNotification){
        
        let dict = notification.object as! NSDictionary
        let sender = dict["sender"] as! UIView
        let venue = dict["venue"] as! Venue
        
        // If venue selected from events page, pop over nav controller to Move
        // back to home View
        if sender is HomeEventTableViewCell{
            self.navigationController?.popViewController(animated: true)
        }
        
        if venue.name == "" {
            fatalError("Selected Venue Has No Name")
            return
        }
        
        if venue.id == "" {
            fatalError("Selected Venue Has No ID")
            return
        }
        
        // Select Venue and Move to Time View of Slider
        self.selectedVenue = venue
        
        self.createStatusView.statesView1() // Label and button states for time view
        self.createStatusView.eventSearchField.setText(textString: venue.name)
        self.createStatusView.createStatusViewSlider.showTimeView() // Show Time View
        
        // Deselect favorite cell select button
        if sender is FavoriteCollectionViewCell{
            let cell = sender as! FavoriteCollectionViewCell
            cell.selectButton.deselectButton()
        }
    }

    
}
