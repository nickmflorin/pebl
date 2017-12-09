//
//  MessagePeblFloatingButton.swift
//  Pebl2
//
//  Created by Nick Florin on 1/8/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

// Delegate to Allow View to Communicate that Button Activated
protocol MessagePeblFloatingButtonDelegate {
    func optionActivated(messagePeblFloatingButton: MessagePeblFloatingButton)
    func optionDeactivated(messagePeblFloatingButton: MessagePeblFloatingButton)
}


//////////////////////////////////////////////////////////
class MessagePeblFloatingButton: UIView, PlusButtonDelegate {

    // MARK: Properties
    var controlButton : PlusButton!
    
    // Horizontal Label
    var horizontalLabel : UILabel!
    var labelText : String = "Select a receipient!"
    var labelFont : UIFont = UIFont(name: "SanFranciscoDisplay-Medium", size: 12.0)!
    var labelWidth : CGFloat = 60.0
    var labelLeftInset : CGFloat = 18.0
    
    // Bar Layers
    var horizontalRectLayer : CAShapeLayer!
    var barLayerColor : UIColor = secondaryColor.withAlphaComponent(0.5)
    
    // Horizontal Bar Width and Frame
    var horizontalExpandedLength : CGFloat = 120.0 // Specifies Length of Horizontal Bar
    var horizontalExpandedFrame : CGRect!
    
    // Path Properties for Layers
    var horizontalOriginalPath : CGPath!
    var horizontalExpandedPath : CGPath!
    var newVFrame : CGRect!
    
    // Animations
    var horizontalAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
    var horizontalCollapseAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
    let animDuration = TimeInterval(0.2)
    var universalFrame : CGRect!
    
    // Tracking
    var horizontalExpanded : Bool = false
    var delegate : MessagePeblFloatingButtonDelegate?
    
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.draw(frame)
    }
    /////////////////////////////
    // Draws the Different Portions of the Button
    override func draw(_ rect: CGRect) {
        
        // Universal Frame for Collapse
        universalFrame = CGRect(x: self.bounds.minX, y: self.bounds.maxY-self.bounds.width, width: self.bounds.width, height: self.bounds.width)
        
        // Draw the Buttons
        
        // Wait Until Plus Button Drawn to Create Bar Paths (they depend on size)
        self.createLayers(rect:rect)
        self.drawButtons(rect: rect)
        self.createLabel()
        self.initializeAnimations()
    }
    /////////////////////////////
    // Mark: PlusButton Delegate
    internal func activated(plusButton: PlusButton){
        self.expandHorizontal()
        self.showLabel()
        self.horizontalExpanded = true
        self.delegate?.optionActivated(messagePeblFloatingButton: self)
    }
    /////////////////////////////
    internal func deactivated(plusButton: PlusButton){
        self.collapseHorizontal()
        self.hideLabel()
        self.horizontalExpanded = false
        self.delegate?.optionDeactivated(messagePeblFloatingButton: self)
    }
    ////////////////////////////
    // Used to Deactivate from Superview
    func deactivate(){
        self.collapseHorizontal()
        self.hideLabel()
        self.horizontalExpanded = false
        self.controlButton.buttonClicked() // Manually Call to Push Back Plus Button
    }
    /////////////////////////////
    // Creates and Positions the Layers, Paths and Frames for the Horizontal and Veritcal Rounded
    // Rectangular Views
    func createLayers(rect:CGRect){
        
        // Original V Frame is Unexpanded Version of Frame
        let cornerRadius = 0.5*self.bounds.width
        
        // Expanded Horizontal Frame
        let horizontalWidth = horizontalExpandedLength
        let horMinX = self.bounds.minX - horizontalWidth
        horizontalExpandedFrame = CGRect(x: horMinX, y: self.bounds.maxY-self.bounds.width, width: horizontalWidth+self.bounds.width, height: self.bounds.width)
        
        // Paths for Expanded and Original Horizontal Portions
        horizontalOriginalPath = UIBezierPath(roundedRect: self.universalFrame, cornerRadius: cornerRadius).cgPath
        horizontalExpandedPath = UIBezierPath(roundedRect: horizontalExpandedFrame, cornerRadius: cornerRadius).cgPath
        
        // Create Layers for Horizontal and Vertical Portions
        horizontalRectLayer = CAShapeLayer()
        horizontalRectLayer.path = horizontalOriginalPath
        horizontalRectLayer.fillColor = barLayerColor.cgColor

        // Add Layers to Sub Layer
        self.layer.addSublayer(horizontalRectLayer)
        
    }
    /////////////////////////////
    //Create Plus Button, Message Pebl Button and Suggestion Pebl Button
    func drawButtons(rect:CGRect){
        
        // Find Frames of Each Button
        controlButton = PlusButton(frame: universalFrame)
        controlButton.delegate = self
        
        self.addSubview(controlButton)
        self.bringSubview(toFront: controlButton)
    }
    ////////////////////////////
    // Adds the Label to the Horizontal Slide Out Bar
    func createLabel(){
        
        let labelFrame = CGRect(x: horizontalExpandedFrame.minX + labelLeftInset, y: horizontalExpandedFrame.minY, width: labelWidth, height: horizontalExpandedFrame.height)
        horizontalLabel = UILabel(frame: labelFrame)
        horizontalLabel.text = labelText
        horizontalLabel.font = labelFont
        horizontalLabel.textColor = UIColor.white
        
        horizontalLabel.lineBreakMode = .byWordWrapping
        horizontalLabel.numberOfLines = 0
        
        // Hide Label at First
        horizontalLabel.alpha = 0.0
        self.addSubview(horizontalLabel)
    }
    // Adds the Label to Horizontal Slide Out Bar When it Slides Out
    func showLabel(){
        horizontalLabel.alpha = 1.0
    }
    // Hides the Label to Horizontal Slide Out Bar When it Slides Out
    func hideLabel(){
        horizontalLabel.alpha = 0.0
    }
    ////////////////////////////
    // Sets Up Layer Animations for Use
    func initializeAnimations(){
        
        // Animation - New Path for Horizontal Bar Expanded
        horizontalAnimation = CABasicAnimation(keyPath: "path")
        horizontalAnimation.fromValue = horizontalOriginalPath
        horizontalAnimation.toValue = horizontalExpandedPath
        horizontalAnimation.duration = animDuration
        horizontalAnimation.isRemovedOnCompletion = false
        
        // Animation -  New Path for Horizontal Bar Collapsed
        horizontalCollapseAnimation = CABasicAnimation(keyPath: "path")
        horizontalCollapseAnimation.fromValue = horizontalExpandedFrame
        horizontalCollapseAnimation.toValue = horizontalOriginalPath
        horizontalCollapseAnimation.duration = animDuration
        horizontalCollapseAnimation.isRemovedOnCompletion = false
    }
    /////////////////////////////
    // Performs the Horizontal Expansion from the Plus Button
    func expandHorizontal(){
        if self.horizontalExpanded == false {
            horizontalRectLayer.add(horizontalAnimation, forKey: "horizontalAnimation")
            horizontalRectLayer.path = horizontalExpandedPath
        }
    }
    /////////////////////////////
    // Performs the Horizontal Collapse to the Plus Button
    func collapseHorizontal(){
        if self.horizontalExpanded == true {
            horizontalRectLayer.add(horizontalCollapseAnimation, forKey: "horizontalAnimation")
            horizontalRectLayer.path = horizontalOriginalPath
        }
    }
    /////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
