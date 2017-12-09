//
//  TimeSelect.swift
//  Pebl2
//
//  Created by Nick Florin on 1/25/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

protocol TimeSelectDelegate: class {
    func selectTime(selectedTime: TimeSelect)
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
class TimeSelect : UIView {
    
    var index : Int! // Used to Keep Track of Time Selects
    var labelHorizontalPadding : CGFloat = 6.0
    var labelVerticalPadding : CGFloat = 6.0
    let labelHeight : CGFloat = 14.0
    
    var labelText : String!
    var label : UILabel!
    
    var selectionColor : UIColor = green
    var inactiveColor : UIColor = accentColor
    var textColor : UIColor = UIColor.white
    var borderColor : UIColor = UIColor.clear
    let textFont = UIFont (name: "SanFranciscoDisplay-Medium", size:14)
    
    var minimumSelectWidth : CGFloat = 60.0
    var cornerRadiusFactor : CGFloat = 0.25 // Percent of Height for Radius
    var selected : Bool = false
    
    weak var delegate: TimeSelectDelegate?
    //////////////////////////////////
    // Init with Frame Programatically
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    /////////////////////////////
    override func draw(_ rect: CGRect) {
        
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
        
        // Create Tap Gesture
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TimeSelect.setAsSelected))
        self.addGestureRecognizer(tapGesture)
    }
    /////////////////////////////
    // Styles Background of Label
    func style(){
        
        self.backgroundColor = inactiveColor // Default Color
        if self.selected {
            self.backgroundColor = selectionColor // Default Color
        }
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadiusFactor * self.bounds.height
        self.layer.borderWidth = 1.0
        self.layer.borderColor = borderColor.cgColor
        
    }
    /////////////////////////////////////
    // Denotes Cell as Selected and Performs Associated Actions
    func setAsSelected(_ sender: UITapGestureRecognizer){
        print("Selecting Cell : \(self.labelText)")
        self.select()
    }
    /////////////////////////////
    // Selects the View
    func select(){
        self.selected = true
        self.backgroundColor = selectionColor
        // Call Delegate Handler of Entire Field - Selects This Cell, Deselects All Others
        self.delegate?.selectTime(selectedTime: self)
    }
    /////////////////////////////
    // Deselects the View
    func deselect(){
        self.selected = false
        self.backgroundColor = inactiveColor
    }
    /////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
