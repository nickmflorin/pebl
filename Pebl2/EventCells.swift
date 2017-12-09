//
//  EventTableViewCells.swift
//  Pebl
//
//  Created by Nick Florin on 10/20/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

class EventThumbNailCell: UICollectionViewCell {
    
    // MARK: Properties
    @IBOutlet weak var eventNameLabel: UILabel!
    var user_name : String?
    var user_id : String?
    /////////////////////
    var eventName: String = "" {
        didSet {
            eventNameLabel.text = eventName
        }
    }
//    /////////////////////
//    var profile_image: UIImage! {
//        didSet {
//            
//            thumbnailPhoto.setBackgroundColor(UIColor.clear, forState: UIControlState())
//            self.bringSubview(toFront: thumbnailPhoto)
//            thumbnailPhoto.setImage(profile_image, for: UIControlState())
//            
//            thumbnailPhoto.imageView?.layer.cornerRadius = thumbnailPhoto.frame.size.width / 2;
//            thumbnailPhoto.imageView?.clipsToBounds = true
//            
//            thumbnailPhoto.imageView?.layer.borderColor = dark_blue.cgColor
//            thumbnailPhoto.imageView?.layer.borderWidth = 1.0
//            
//        }
//    }
    /////////////////////
    // Mark: Actions

}
