//
//  EventTableViewCell.swift
//  Pebl2
//
//  Created by Nick Florin on 1/22/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

////////////////////////////////////////////////////
class EventTableViewCellFeed: UITableViewCell {

    // Mark: Properties
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var venueNameField: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var tipDescriptionField: UILabel!
    
    @IBOutlet weak var firstPinnedUser: UILabel!
    @IBOutlet weak var otherMatchPinField: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationIconView: UIImageView!

    var boldFontName = "ProximaNovaCond-Regular"
    var regularFontName = "ProximaNovaCond-Light"

    // Information Parameters
    var indexPath : IndexPath!
    var venue : Venue!
    
    // To Do: Determine if more convenient to attribute User objects or User IDs for Match Pins
    //var pinnedUsers : [User]! // Matched Users Associated With Pins
    var pinnedUserIDs : [String]!
    var pinnedUserFirstNames : [String] = []
    
    var currentLocation : CLLocation! // User Location
    
    //////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization Code
        self.isHighlighted = false
        self.isSelected = false
        
        // Default Settings of Labels
        self.firstPinnedUser.text = "No Matches" //Default
        let fontSize : CGFloat = self.firstPinnedUser.font.pointSize
        self.firstPinnedUser.font = UIFont(name: self.regularFontName, size: fontSize)
        
        self.otherMatchPinField.text = ""
        self.locationLabel.text = ""
        
        self.locationIconView.alpha = 0.0
        self.ratingView.alpha = 0.0
    }
    // Only for Development Purposes
    @IBAction func devDetails(_ sender: Any) {
        log.info("Venue ID : \(self.venue.id)")
        log.info("Matched User IDS : ")
        log.info(pinnedUserFirstNames)
        
    }
    /////////////////////////////////////////////////////////////
    // Called after match object designated to cell, populates info in cell
    // with venue object.
    func setup(){
        
        if self.venue == nil {
            fatalError("Error : Venue Nil for Event Table View Cell")
        }
        
        // Populate Venue Data in Cell
        self.venueNameField.text = self.venue.name
        // Find distance from the user that the venue is
        if self.venue.location != nil {
            
            // Venue Location Can be Missing but If Location Present, Lattitude/Longitude Should Be there
            if self.venue.location.lattitude == nil || self.venue.location.longitude == nil {
                fatalError("Venue Lattitude and Longitude Missing from Location")
            }
            
            //Calculate Distance Betwteen User and Venue Location
            let venueLattitude = Double(self.venue.location.lattitude)
            let venueLongitude = Double(self.venue.location.longitude)
            let venueLoc = CLLocation(latitude: venueLattitude, longitude: venueLongitude)
            
            guard self.currentLocation != nil else {
                fatalError("Missing Location Data for User in Event Table Cell")
            }
            
            // Probably Want to Stick with Doubles Later
            let distanceMeters : CGFloat = CGFloat(venueLoc.distance(from: self.currentLocation))
            let distanceMiles = convertMetersToMiles(meters: distanceMeters)
            
            // Show Location Data in Cell
            self.locationIconView.alpha = 1.0
            self.locationLabel.text = String(describing: distanceMiles)+" mi"
        }
        
        // Handle Pinned Users 
        // TO DO : Create String Dynamically as Users are Encountered and Names Loaded
        //if self.pinnedUsers != nil && self.pinnedUsers.count != 0 {
        if self.pinnedUserIDs != nil && self.pinnedUserIDs.count != 0 {
            DispatchQueue.main.async {
                
                let group = DispatchGroup()
                //for user in self.pinnedUsers {
                for userID in self.pinnedUserIDs {
                    
                    // To Do: How to handle empty first names that appear.
                    group.enter()
                    //user.getInfo({userInfo in
                    User(userID: userID).getInfo({userInfo in
                        self.pinnedUserFirstNames.append(userInfo.firstName)
                        group.leave()
                    })
                    // Once All Names Retrieved - Create String
                    group.notify(queue: DispatchQueue.main, execute: {
                        
                        // If more than 4 matches, include first two names in bold and 
                        // others as other matches, otherwise, only use first name as bold.
                        
                        // First Bold Match
                        var boldPinnedUsers = self.pinnedUserFirstNames[0]
                        var leftoverIndex = 1
                        if self.pinnedUserFirstNames.count >= 4 {
                            boldPinnedUsers += ", "+self.pinnedUserFirstNames[1]
                            leftoverIndex = 2
                        }
                        let fontSize = self.firstPinnedUser.font.pointSize
                        self.firstPinnedUser.font = UIFont(name: self.boldFontName, size: fontSize)
                        self.firstPinnedUser.text = boldPinnedUsers
                        
                        // Leftover Names
                        if self.pinnedUserFirstNames.count > leftoverIndex {
                            let numLeftover = self.pinnedUserFirstNames.count - leftoverIndex
                            self.otherMatchPinField.text = "and "+String(describing: numLeftover)+" other matches"
                        }
                    })
                }
            
            }
        }
    
        // Handle Tips - Desired tip should already be valid and have valid attributes
        if self.venue.desiredTip != nil {
            self.tipDescriptionField.text = self.venue.desiredTip.text
            self.tipDescriptionField.sizeToFit()
            
        }
        // Apply Venue Rating
        if self.venue.rating != nil {
            self.ratingView.rating = self.venue.rating
            self.ratingView.orientation = "right"
            self.ratingView.alpha = 1.0
        }
    }

}
