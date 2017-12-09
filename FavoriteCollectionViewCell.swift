//
//  FavoriteCollectionViewCell.swift
//  Pebl2
//
//  Created by Nick Florin on 1/25/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

//////////////////////////////////////////////////////////////////////////
class FavoriteCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var venueNameField: UILabel!
    @IBOutlet weak var selectButton: VenueImageSelectButton!
    
    var venue : Venue!
    var indexPath : IndexPath!
    
    var imageViewBorderWidth : CGFloat = 1.0
    var imageViewBorderColor : UIColor = accentColor
    
    /////////////////////////////////////
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
        
        Bundle.main.loadNibNamed("FavoriteCollectionViewCell", owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
    }
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        Bundle.main.loadNibNamed("FavoriteCollectionViewCell", owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
        
    }

    //////////////////////////////
    // Init for Drawing Underlying
    override func draw(_ rect: CGRect) {
        
    }
    /////////////////////////////////////
    func setup(_ venue:Venue) {
        
        self.backgroundColor = UIColor.clear
        self.venue = venue
        self.poplulateInfo()

    }
    /////////////////////////////////////
    // Populates Info in Collection View Cell
    func poplulateInfo(){
        
        let brightnessLevel = 0.05
        
        let image = venue.image
        let cgImage = image?.cgImage
        var coreImage = CIImage(cgImage: cgImage!)
        
        // Apply Filter to Image
        let filter = CIFilter(name: "CIColorControls")
        let filter2 = CIFilter(name:"CIExposureAdjust")

        let ciContext = CIContext()
        if let unwrwappedFilter : CIFilter = filter  {
            
            unwrwappedFilter.setDefaults()
            unwrwappedFilter.setValue(coreImage, forKey: kCIInputImageKey)
            unwrwappedFilter.setValue(brightnessLevel,forKey:kCIInputBrightnessKey)
            
            if let outputImage : CIImage = unwrwappedFilter.outputImage {
                let createdCGImage = ciContext.createCGImage(outputImage,from:outputImage.extent)
                coreImage = CIImage(cgImage: createdCGImage!)
                
                if let unwrwappedFilter2 : CIFilter = filter2  {
                    
                    unwrwappedFilter2.setDefaults()
                    unwrwappedFilter2.setValue(coreImage, forKey: kCIInputImageKey)
                    unwrwappedFilter2.setValue(0.9,forKey:kCIInputEVKey)
                    
                    if let outputImage2 : CIImage = unwrwappedFilter2.outputImage {
                        let createdCGImage2 = ciContext.createCGImage(outputImage2,from:outputImage2.extent)
                        imageView.image = UIImage(cgImage: createdCGImage2!)
                        imageView.contentMode = .scaleAspectFill
                    }
                    
                }
                imageView.image = UIImage(cgImage: createdCGImage!)
                imageView.contentMode = .scaleAspectFill
            }
            
        }
        imageView.clipsToBounds = true
        
        // Put drop shadow around text to make white text more visible
        venueNameField.text = venue.name
        venueNameField.layer.shadowOpacity = 0.9
        venueNameField.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        selectButton.layer.shadowOpacity = 0.9
        selectButton.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
    }
    // Mark: Actions
    @IBAction func selectButtonClicked(_ sender: AnyObject) {
        // Send notification that cancel button was clicked from time select view
        let dataDict = ["sender":self,"venue":self.venue] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "venueSelected"), object:dataDict)
    }

}




