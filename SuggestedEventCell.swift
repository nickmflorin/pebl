//
//  SuggestedEventSliderView.swift
//  Pebl2
//
//  Created by Nick Florin on 1/4/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

let SuggestedEventCollectionViewCell_Identifier = "SuggestedEventCollectionViewCell"

//////////////////////////////////////////////////////////////////////////
class SuggestedEventCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    @IBOutlet weak var eventNameField: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    var suggestedEvent : SuggestedEvent!
    
    var indexPath : IndexPath!
    var imageViewInsets : CGFloat = 2.0
    
    var imageViewCornerRadius : CGFloat = 4.5
    var imageViewBorderColor : UIColor = UIColor.lightGray
    var imageViewBorderWidth : CGFloat = 1.5
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Styling of Cell and General Default Styling
        self.backgroundColor = UIColor.clear
        eventNameField.textColor = UIColor.white
    }
    /////////////////////////////////////
    // Performs the Necessary Setup of Cell After Suggestion Pebls Provided
    func setup() {
        
        // Styling of Image View
        
        // Event Image View is Defaulted to Scale Aspect Fit for Default Missing Image 
        // In Future, This Will Be for Small Icon or Other Item That We Don't Want to Fill Entire Image View
        self.eventImageView.image = self.suggestedEvent.eventImage
        self.eventImageView.contentMode = .scaleAspectFill
        
        eventImageView.clipsToBounds = true
        eventImageView.layer.cornerRadius = imageViewCornerRadius
        eventImageView.layer.borderWidth = imageViewBorderWidth
        eventImageView.layer.borderColor = imageViewBorderColor.cgColor
        eventImageView.layer.masksToBounds = true
        
        // Label
        eventNameField.text = suggestedEvent.event_name
    }
    
}

//////////////////////////////////////////////////////////////////////////
class SuggestedEventSliderView: UICollectionView{
    
    
    ////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
