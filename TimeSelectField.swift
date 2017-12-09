//
//  TimeSelectField.swift
//  Pebl2
//
//  Created by Nick Florin on 12/14/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation


class TimeSelectField: UIView, TimeSelectDelegate {

    var activeSelection : String!
    var activeIndex : Int!
    
    var options : [String]!
    
    var timeSelects : [TimeSelect] = []
    
    var horizontalMargin : CGFloat = 8.0
    var verticalMargin : CGFloat = 8.0
    var horizontalPadding : CGFloat = 8.0
    var verticalPadding : CGFloat = 6.0
    
    var selectionColor : UIColor = green
    var inactiveColor : UIColor = secondaryColor
    var textColor : UIColor = UIColor.black
    
    let textFont = UIFont (name: "SanFranciscoDisplay-Regular", size:14)
    
    var maxWidth : CGFloat!
    let cornerRadius : CGFloat = 4.0

    //////////////////////////////
    // Initialization for Laying Out Subviews
    override func layoutSubviews() {
        self.generateSelections(rect:self.frame)
    }
    //////////////////////////////
    //// Init from Coder
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
    }
    
    //////////////////////////////////
    // Init with Frame Programatically
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clear
    }
    
    /////////////////////////////
    override func draw(_ rect: CGRect) {
        
    }
    /////////////////////////////
    // Delegate Handler for Time Select Cell Selection
    internal func selectTime(selectedTime: TimeSelect) {
        
        // For default selection of first tile, timeSelects will have empty
        // length.  So for default selection we need to not deslect all the other fields
        if self.timeSelects.count != 0 {
            // Unselect All Other Time Selects
            for timeSelect in self.timeSelects{
                if timeSelect.index != selectedTime.index{
                    timeSelect.deselect()
                }
            }
        }
        // Select New Time Select
        self.activeIndex = selectedTime.index
        self.activeSelection = selectedTime.labelText
    }
    /////////////////////////////
    func generateSelections(rect: CGRect){
        
        self.timeSelects = []
        guard let options = self.options else{
            fatalError("Cannot Generate Time Select Options - Missing Options")
        }
        
        if maxWidth == nil{
            maxWidth = rect.width - 2.0*horizontalMargin
        }

        var currentXPosition = horizontalMargin
        var currentYPosition = verticalMargin
        
        self.layer.borderColor = UIColor.black.cgColor
        
        if self.options.count == 0{
            return
        }
        //Put First Time Select Down - Width Doesn't Matter, Will be Changed, Height Will be Changed as Well
        let addTimeSelect = TimeSelect(frame: CGRect(x: currentXPosition, y: currentYPosition, width: 0.0, height: 0.0))
        addTimeSelect.labelText = self.options[0]
        addTimeSelect.index = 0
        addTimeSelect.delegate = self
        addTimeSelect.generateLabel()

        // Update Selection Frame Based on Current Positions
        let selectWidth : CGFloat = addTimeSelect.bounds.width
        let selectHeight : CGFloat = addTimeSelect.bounds.height
        addTimeSelect.frame = CGRect(x: currentXPosition, y: currentYPosition, width: selectWidth, height: selectHeight)
        
        // Default Select First Time Option
        addTimeSelect.select()
        
        self.timeSelects.append(addTimeSelect)
        self.addSubview(addTimeSelect)
        
        // Create Rest of Labels Dependent on First Placement
        for i in 1...options.count - 1 {
            
            currentXPosition = self.timeSelects[i-1].frame.maxX + horizontalPadding
            currentYPosition = self.timeSelects[i-1].frame.minY // Assume its in Same Row
            
            // Create New Time Select
            let addTimeSelect = TimeSelect(frame: CGRect(x: currentXPosition, y: currentYPosition, width: 0.0, height: 0.0))
            addTimeSelect.labelText = self.options[i]
            addTimeSelect.index = i
            addTimeSelect.delegate = self
            addTimeSelect.generateLabel()
            
            // Update Label Frame Based on Current Positions
            let selectWidth : CGFloat = addTimeSelect.bounds.width
            let selectHeight : CGFloat = addTimeSelect.bounds.height
            
            // Check if New Label Would be Out of Bounds to Right
            let currentMaxX = self.timeSelects[i-1].frame.maxX + horizontalPadding + selectWidth + horizontalMargin
            
            // Check if Max Exceeded - Reset X and Increment Y
            if currentMaxX >= maxWidth {
                // Move to Next Row
                currentXPosition = horizontalMargin
                currentYPosition = currentYPosition + verticalPadding + self.timeSelects[i-1].bounds.height
            }
            
            // X has Already Been Incremented (or Reset)
            addTimeSelect.frame = CGRect(x: currentXPosition, y: currentYPosition, width: selectWidth, height: selectHeight)
            self.timeSelects.append(addTimeSelect)
            self.addSubview(addTimeSelect)
        }
    }
}
