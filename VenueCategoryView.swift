//
//  VenueCategoryView.swift
//  Pebl2
//
//  Created by Nick Florin on 2/20/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

//
//  MatchEventTagView.swift
//  Pebl2
//
//  Created by Nick Florin on 1/8/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

//////////////////////////////////////////////////////////////////////////////////////////////////////
class VenueCategory : UIView {
    
    var index : Int! // Used to Keep Track of Time Selects
    var labelHorizontalPadding : CGFloat = 6.0
    var labelVerticalPadding : CGFloat = 6.0
    let labelHeight : CGFloat = 14.0
    
    var labelText : String!
    var label : UILabel!
    
    var backgroundC : UIColor = light_blue
    var textColor : UIColor = UIColor.white
    var borderColor : UIColor = UIColor.clear
    let textFont = UIFont (name: "SanFranciscoDisplay-Medium", size:12)
    
    var minimumSelectWidth : CGFloat = 60.0
    var cornerRadiusFactor : CGFloat = 0.25 // Percent of Height for Radius
    
    //////////////////////////////////
    // Init with Frame Programatically
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clear
    }
    /////////////////////////////
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
    }
    /////////////////////////////
    // Creates Correctly Sized/Formatted Label from String
    func generateLabel(){
        
        if self.labelText != nil {
            
            label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: labelHeight, height: labelHeight))
            label.textAlignment = .center
            label.text = self.labelText
            label.font = textFont
            label.textColor = textColor
            label.backgroundColor = UIColor.clear
            
            label.sizeToFit() // Determines Minimium Width of Frame
            
            // Update TimeSelect View Frame Based on Label Size
            var sizedWidth : CGFloat = label.bounds.width
            var totalWidth : CGFloat = sizedWidth + 2.0*labelHorizontalPadding
            
            // Keep Total Width Larger than Minimum
            if totalWidth <= minimumSelectWidth {
                totalWidth = minimumSelectWidth
                sizedWidth = totalWidth - 2.0*labelHorizontalPadding
            }
            
            let currentHeight = label.frame.height + 2.0*labelVerticalPadding
            self.bounds = CGRect(x: 0.0, y: 0.0, width: totalWidth, height: currentHeight)
            
            // Add Label to Updated Frame Size
            let minY = 0.5*(self.bounds.height - labelHeight)
            label.frame = CGRect(x: labelHorizontalPadding, y: minY, width: sizedWidth, height: labelHeight)
            self.addSubview(label)
        }
        // Style After Label Drawn so Height is Correct
        self.style()
    }
    /////////////////////////////
    // Styles Background of Label
    func style(){
        
        self.backgroundColor = backgroundC // Default Color
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadiusFactor * self.bounds.height
        self.layer.borderWidth = 1.0
        self.layer.borderColor = borderColor.cgColor
        
    }
    /////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
class VenueCategoryView: UIView {
    
    var activeSelection : String!
    var activeIndex : Int!
    
    var options : [String]!
    var tags : [VenueCategory] = []
    
    var horizontalPadding : CGFloat = 8.0
    
    var selectionColor : UIColor = green
    var inactiveColor : UIColor = secondaryColor
    var textColor : UIColor = UIColor.black
    
    var maxWidth : CGFloat!
    let cornerRadius : CGFloat = 4.0
    
    var maxTags : Int = 4
    //////////////////////////////
    //// Init from Coder
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
    }
    /////////////////////////////
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
    }
    /////////////////////////////
    func generateTags(){
        
        self.tags = []
        if maxWidth == nil{
            maxWidth = self.bounds.width
        }
        
        var currentXPosition = self.bounds.minX
        var currentYPosition = self.bounds.minY
        
        guard self.options != nil && self.options.count != 0 else{
            return
        }

        //Put First Time Select Down - Width Doesn't Matter, Will be Changed, Height Will be Changed as Well
        let addTag = VenueCategory(frame: CGRect(x: currentXPosition, y: currentYPosition, width: 0.0, height: 0.0))
        addTag.labelText = self.options[0]
        addTag.index = 0
        addTag.generateLabel()
        
        // Update Selection Frame Based on Current Positions
        let selectWidth : CGFloat = addTag.bounds.width
        let selectHeight : CGFloat = addTag.bounds.height
        addTag.frame = CGRect(x: currentXPosition, y: currentYPosition, width: selectWidth, height: selectHeight)
        
        self.tags.append(addTag)
        self.addSubview(addTag)
        
        // Create Rest of Labels Dependent on First Placement
        // Can't Have Only 1 Option Beyond This Point
        guard self.options.count != 1 else {
            return
        }
        
        for i in 1...options.count - 1 {
            
            currentXPosition = self.tags[i-1].frame.maxX + horizontalPadding
            currentYPosition = self.tags[i-1].frame.minY // Always  in Same Row
            
            // Create New Time Select
            let addTag = VenueCategory(frame: CGRect(x: currentXPosition, y: currentYPosition, width: 0.0, height: 0.0))
            addTag.labelText = self.options[i]
            addTag.index = i
            addTag.generateLabel()
            
            // Update Label Frame Based on Current Positions
            let selectWidth : CGFloat = addTag.bounds.width
            let selectHeight : CGFloat = addTag.bounds.height
            
            // Check if New Label Would be Out of Bounds to Right
            let currentMaxX = self.tags[i-1].frame.maxX + horizontalPadding + selectWidth
            
            // Check if Max Exceeded - Reset X and Increment Y
            if currentMaxX >= maxWidth {
                // Don't Add Tag
                return
            }
            
            // X has Already Been Incremented (or Reset)
            addTag.frame = CGRect(x: currentXPosition, y: currentYPosition, width: selectWidth, height: selectHeight)
            self.tags.append(addTag)
            self.addSubview(addTag)
        }
    }
    
    
}




