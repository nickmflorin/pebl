//
//  HomeEventTableViewCell.swift
//  Pebl2
//
//  Created by Nick Florin on 1/25/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

// Delegate to Allow Cell to Communicate with Table View
protocol HomeEventTableViewCellDelegate {

}

////////////////////////////////////////////////////
class HomeEventTableViewCell: UITableViewCell {
    
    // Mark: Properties
    @IBOutlet weak var venueCategoryIcon: UIImageView!
    @IBOutlet weak var venueCategoryField: UILabel!
    @IBOutlet weak var venueImageButton: UIButton!
    @IBOutlet weak var venueNameField: UILabel!
    @IBOutlet weak var venueAddressField: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    var whiteRoundedView : UIView!
    
    // Information Parameters
    var indexPath : IndexPath!
    var venue : Venue!
    var venueID : String!
    
    var delegate : HomeEventTableViewCellDelegate?
    //////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization Code
        self.isHighlighted = false
        self.isSelected = false
    }
    /////////////////////////////////////////////////////////////
    // Called after match object designated to cell, populates info in cell
    // with venue object.
    func setup(){
        
        if self.venue == nil {
            fatalError("Error : Venue Nil for Event Table View Cell")
        }
        // Populate Venue Data in Cell
        self.venueID = venue.id
        self.venueNameField.text = self.venue.name
        
        if self.venue.location != nil && self.venue.location.address != nil {
            self.venueAddressField.text = self.venue.location.address
        }

        //self.venueCategoryField.text = self.venue.subCategoryName
        self.venueCategoryField.sizeToFit()
        
        self.venueCategoryIcon.contentMode = .scaleAspectFit
        self.venueCategoryIcon.image = UIImage(named:"BarIcon")
        
        // Readjust rame of Venue Cateogry Icon After Text Placed
        self.venueCategoryIcon.frame = CGRect(x: self.venueCategoryField.frame.maxX + 10.0, y: self.venueCategoryField.frame.minY+2.0, width: self.venueCategoryField.frame.height-4.0, height: self.venueCategoryField.frame.height-4.0)
        
        self.venueImageButton.contentMode = .scaleAspectFill
        self.venueImageButton.setImage(self.venue.image, for: .normal)
        
    }
    // MARK: Actions
    @IBAction func selectButtonClicked(_ sender: AnyObject) {
        // Send notification that cancel button was clicked from time select view
        let dataDict = ["sender":self,"venue":self.venue] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "venueSelected"), object:dataDict)
    }
}
