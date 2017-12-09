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
class EventTableViewCellPinned: UITableViewCell {
    
    // Mark: Properties
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var venueNameField: UILabel!
    @IBOutlet weak var categoryTagField: UILabel!
    
    @IBOutlet weak var unpinIcon: UIButton!
    @IBOutlet weak var pinIcon: UIImageView!
    @IBOutlet weak var pinDateField: UILabel!
    
    // Information Parameters
    var pinnedCellData : PinnedCellData!
    var currentLocation : CLLocation! // User Location

    //////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization Code
        self.isHighlighted = false
        self.isSelected = false
        
        // Default Settings of Labels and Icons
        self.categoryTagField.text = ""
        self.pinIcon.alpha = 0.0
        self.pinDateField.text = ""
    }
    // Called after match object designated to cell, populates info in cell
    // with venue object.
    func setup(){
        
        // Pinned Cell Data Venue will never be nil since it is a struct but we may pull in
        // venue from other object in future so leave this implementation.
        guard self.pinnedCellData != nil && self.pinnedCellData.venue != nil else {
            fatalError("Error : Venue Nil for Event Table View Cell")
            return
        }
        
        // Populate Venue Data in Cell
        self.venueNameField.text = self.pinnedCellData.venue.name
        if self.pinnedCellData.venue.categories != nil {
            self.categoryTagField.text = self.pinnedCellData.venue.createCategoryString()
        }
        
        // Populate Primary User Pin Date Data
        if self.pinnedCellData.userPin.formattedCreatedDate != nil {
            self.pinIcon.alpha = 1.0
            self.pinDateField.text = self.pinnedCellData.userPin.formattedCreatedDate
        }
        
        
    }
    
}
