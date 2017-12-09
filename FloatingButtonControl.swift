//
//  FloatingButton.swift
//  Pebl2
//
//  Created by Nick Florin on 12/20/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

//////////////////////////////////////////////////////////
class FloatingButton: UIView {
    
    // MARK: Properties
    var plusButton : UIView!
    var messagePeblButton : UIView!
    var suggestionPeblButton : UIView!
    
    // Horizontal Label
    var horizontalLabel : UILabel!
    var labelText : String = "Select a receipient!"
    var labelFont : UIFont = UIFont(name: "SanFranciscoDisplay-Medium", size: 12.0)!
    var labelWidth : CGFloat = 60.0
    var labelLeftInset : CGFloat = 18.0
    
    // Bar Layers
    var verticalRectLayer : CAShapeLayer!
    var horizontalRectLayer : CAShapeLayer!
    var barLayerColor : UIColor = secondaryColor.withAlphaComponent(0.5)
    
    // Horizontal Bar Width and Frame
    var horizontalPct : CGFloat = 0.6 // Specifies Percent Length of Vertical Bar that Horizontal Bar Is
    var horizontalExpandedFrame : CGRect!
    
    // Path Properties for Layers
    var verticalExpandedPath : CGPath!
    var verticalOriginalPath : CGPath!
    var horizontalOriginalPath : CGPath!
    var horizontalExpandedPath : CGPath!
    
    var newVFrame : CGRect!
    
    // Animations
    var verticalAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
    var verticalCollapseAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
    let animDuration = TimeInterval(0.2)
    
    var showMessagePeblAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
    var showSuggestionPeblAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
    var hideMessagePeblAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
    var hideSuggestionPeblAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
    
    var horizontalAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
    var horizontalCollapseAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
    
    // Button Positions and Centers
    var c1 : CGFloat!
    var c2 : CGFloat!
    var c3 : CGFloat!
    
    // Expanded Frames for Buttons 2 and 3
    var f2 : CGRect!
    var f3 : CGRect!
    
    var universalFrame : CGRect!
    
    // Tracking
    var verticalExpanded : Bool = false
    var horizontalExpanded : Bool = false
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.draw(frame)
    }
    /////////////////////////////
    // Draws the Different Portions of the Button
    override func draw(_ rect: CGRect) {
        
        // Determine Center Positionings for Buttons
        c1 = self.bounds.maxY - 0.5*self.bounds.width
        c2 = 0.5*(self.bounds.maxY-self.bounds.minY)
        c3 = self.bounds.minY + 0.5*self.bounds.width
        
        // Determine Frame Positions for Expanded Buttons
        f2 = CGRect(x: self.bounds.minX, y: c2-0.5*self.bounds.width, width: self.bounds.width, height: self.bounds.width)
        f3 = CGRect(x: self.bounds.minX, y: c3-0.5*self.bounds.width, width: self.bounds.width, height: self.bounds.width)
        
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
    // Creates and Positions the Layers, Paths and Frames for the Horizontal and Veritcal Rounded
    // Rectangular Views
    func createLayers(rect:CGRect){
        
        // Original V Frame is Unexpanded Version of Frame
        let cornerRadius = 0.5*self.bounds.width
        
        // Paths for Expanded and Original Vertical Portions
        verticalOriginalPath = UIBezierPath(roundedRect: self.universalFrame, cornerRadius: cornerRadius).cgPath
        verticalExpandedPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        
        // Expanded Horizontal Frame
        let horizontalWidth = horizontalPct * self.bounds.height
        let horMinX = self.bounds.maxX - horizontalWidth
        horizontalExpandedFrame = CGRect(x: horMinX, y: self.bounds.maxY-self.bounds.width, width: horizontalWidth, height: self.bounds.width)
        
        // Paths for Expanded and Original Horizontal Portions
        horizontalOriginalPath = UIBezierPath(roundedRect: self.universalFrame, cornerRadius: cornerRadius).cgPath
        horizontalExpandedPath = UIBezierPath(roundedRect: horizontalExpandedFrame, cornerRadius: cornerRadius).cgPath
        
        // Create Layers for Horizontal and Vertical Portions
        horizontalRectLayer = CAShapeLayer()
        horizontalRectLayer.path = horizontalOriginalPath
        horizontalRectLayer.fillColor = barLayerColor.cgColor
        
        verticalRectLayer = CAShapeLayer()
        verticalRectLayer.path = verticalOriginalPath
        verticalRectLayer.fillColor = barLayerColor.cgColor
        
        // Add Layers to Sub Layer
        self.layer.addSublayer(verticalRectLayer)
        self.layer.addSublayer(horizontalRectLayer)
    
    }
    /////////////////////////////
    //Create Plus Button, Message Pebl Button and Suggestion Pebl Button
    func drawButtons(rect:CGRect){
        
        // Find Frames of Each Button

        plusButton = PlusButton(frame: self.universalFrame)
        // Attach Tap Gesture to Button
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FloatingButton.plusButtonTapped))
        plusButton.addGestureRecognizer(tapGesture)
        
        messagePeblButton = MessagePeblButton(frame: self.universalFrame)
        // Attach Tap Gesture to Buttons
        let tapGesture2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FloatingButton.messagePeblButtonTapped))
        messagePeblButton.addGestureRecognizer(tapGesture2)
        
        suggestionPeblButton = SuggestionPeblButton(frame: self.universalFrame)
        // Attach Tap Gesture to Buttons
        let tapGesture3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FloatingButton.suggestionPeblButtonTapped))
        suggestionPeblButton.addGestureRecognizer(tapGesture3)
        
        self.addSubview(suggestionPeblButton)
        self.addSubview(messagePeblButton)
        self.addSubview(plusButton)
        
        self.bringSubview(toFront: suggestionPeblButton)
        self.bringSubview(toFront: messagePeblButton)
        self.bringSubview(toFront: plusButton)
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
        
        // Animation - New Path for Vertical Bar Expanded
        verticalAnimation = CABasicAnimation(keyPath: "path")
        verticalAnimation.fromValue = verticalOriginalPath
        verticalAnimation.toValue = verticalExpandedPath
        verticalAnimation.duration = animDuration
        verticalAnimation.isRemovedOnCompletion = false
        
        // Animation -  New Path for Vertical Bar Collapsed
        verticalCollapseAnimation = CABasicAnimation(keyPath: "path")
        verticalCollapseAnimation.fromValue = verticalExpandedPath
        verticalCollapseAnimation.toValue = verticalOriginalPath
        verticalCollapseAnimation.duration = animDuration
        verticalCollapseAnimation.isRemovedOnCompletion = false
        
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
    // Performs the Vertical Expansion from the Plus Button
    func expandVertical(){
        if self.verticalExpanded == false {
            
            verticalRectLayer.add(verticalAnimation, forKey: "verticalAnimation")
            verticalRectLayer.path = verticalExpandedPath
            self.verticalExpanded = true
            
            // Animate Buttons Sliding Up
            UIView.animate(withDuration: animDuration, animations: {
                // Message Pebl On Top
                self.messagePeblButton.frame = self.f3
                self.suggestionPeblButton.frame = self.f2
            })
        }
    }
    /////////////////////////////
    // Performs the Vertical Collapse to the Plus Button
    func collapseVertical(){
        if self.verticalExpanded == true {
            
            verticalRectLayer.add(verticalCollapseAnimation, forKey: "verticalAnimation")
            verticalRectLayer.path = verticalOriginalPath
            self.verticalExpanded = false
            
            // Animate Buttons Sliding Down
            UIView.animate(withDuration: animDuration, animations: {
                self.messagePeblButton.frame = self.universalFrame
                self.suggestionPeblButton.frame = self.universalFrame
            })
        }
    }
    /////////////////////////////
    // Performs the Horizontal Expansion from the Plus Button
    func expandHorizontal(){
        if self.horizontalExpanded == false {

            horizontalRectLayer.add(horizontalAnimation, forKey: "horizontalAnimation")
            horizontalRectLayer.path = horizontalExpandedPath
            self.horizontalExpanded = true
            self.showLabel()
        }
    }
    /////////////////////////////
    // Performs the Horizontal Collapse to the Plus Button
    func collapseHorizontal(){
        if self.horizontalExpanded == true {

            horizontalRectLayer.add(horizontalCollapseAnimation, forKey: "horizontalAnimation")
            horizontalRectLayer.path = horizontalOriginalPath
            self.horizontalExpanded = false
            self.hideLabel()
        }
    }
    /////////////////////////////
    // Tap Handler for Buttons
    func plusButtonTapped(tapGR: UITapGestureRecognizer) {
        // Collapse Vertical if Expanded
        if self.verticalExpanded{
            self.collapseVertical()
            return
        }
        // Collapse Horizontal if Expanded
        else if self.horizontalExpanded{
            self.collapseHorizontal()
            return
        }
        // If Nothing Expanded - Expand Vertical
        else{
            self.expandVertical()
            return
        }
    }
    /////////////////////////////
    // When Suggestion Pebl Button is Tapped, Slide Down Vertical Portion and Slide Out Horizontal
    func suggestionPeblButtonTapped(tapGR: UITapGestureRecognizer){
        if self.verticalExpanded{
            self.collapseVertical()
            // Expand Horizontal Portion
            self.expandHorizontal()
        }
    }
    /////////////////////////////
    // When Message Pebl Button is Tapped, Slide Down Vertical Portion and Slide Out Horizontal
    func messagePeblButtonTapped(tapGR: UITapGestureRecognizer){
        if self.verticalExpanded{
            self.collapseVertical()
            // Expand Horizontal Portion
            self.expandHorizontal()
        }
    }
    /////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
