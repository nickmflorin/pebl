//
//  CreateStatusViewSlider.swift
//  Pebl2
//
//  Created by Nick Florin on 1/25/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

///////////////////////////////////
// View that shows the transition between steps for creating your status on the home page.
// Contains 3 separate subviews that are moved from left to right for each step

class CreateStatusViewSlider: UIView {
    
    var views : [UIView] = []
    var currentIndex : Int = 0
    var framesForIndex : [[CGRect]] = []
    
    var timeSelectField : TimeSelectField!
    var favoriteEventView : FavoriteEventView!
    var messageSelectionView : MessageSelectionView!
    
    var favoriteEventViewAdditionalHeight : CGFloat = 100.0 // Allow favorite event tiles to go past view's height
    var timeSelectFieldHorizontalMargin : CGFloat = 15.0
    
    var timeOptions = ["whenever","today","tomorrow","this week","next few days","next week","this weekend"]
    var animationDuration : TimeInterval = TimeInterval(0.5)
    
    //////////////////////////////
    //// Init from Coder
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    //////////////////////////////
    // Init for Drawing Underlying
    override func draw(_ rect: CGRect) {
        self.setupViews(rect:rect)
    }
    
    //////////////////////////////
    // Assigns Frames for Views
    func setFramesForViews(frames:[CGRect]){
        
        for i in 0...self.views.count - 1 {
            
            var useFrame : CGRect!
            useFrame = frames[i] // Default
            
            // Make Adjustmens to Frame Insets if Applicable
            if self.views[i] is TimeSelectField{
                let indexedFrame = frames[i]
                useFrame = CGRect(x: indexedFrame.minX + self.timeSelectFieldHorizontalMargin, y: indexedFrame.minY, width: indexedFrame.width - 2.0*self.timeSelectFieldHorizontalMargin, height: indexedFrame.height)
            }
            else if self.views[i] is FavoriteEventView{
                
                let indexedFrame = frames[i]
                useFrame = CGRect(x: indexedFrame.minX, y: indexedFrame.minY, width: indexedFrame.width, height: indexedFrame.height + self.favoriteEventViewAdditionalHeight)
                print("ORIGINAL FRAME : \(indexedFrame)")
                print("USING FRAME  : \(useFrame)")
            }
            self.views[i].frame = useFrame
        }

    }
    //////////////////////////////
    // Animates the Views Moving to the Corresponding Frames
    func animateFramesForViews(frames:[CGRect]){
        UIView.animate(withDuration: animationDuration, animations: {
            self.setFramesForViews(frames:frames)
        })
    }
    //////////////////////////////
    // Animates Views Moving to Left to Show Base View from Any Other View on Cancel
    func showFavoritesView(){
        
        if self.currentIndex != 1 && self.currentIndex != 2 {
            fatalError("Indexing Error in Status View Slider")
        }
        self.currentIndex = 0
        let frames = self.framesForIndex[self.currentIndex]
        self.animateFramesForViews(frames: frames)
    }
    //////////////////////////////
    // Animates Views Moving to Left to Show Time View from Base View
    func showTimeView(){
        if self.currentIndex != 0 {
            fatalError("Indexing Error in Status View Slider")
        }
        self.currentIndex = 1
        let frames = self.framesForIndex[self.currentIndex]
        self.animateFramesForViews(frames: frames)
        
    }
    //////////////////////////////
    // Animates Views Moving to Left to Show Message View from Time View
    func showMessageView(){
        if self.currentIndex != 1 {
            fatalError("Indexing Error in Status View Slider")
        }
        self.currentIndex = 2
        let frames = self.framesForIndex[self.currentIndex]
        self.animateFramesForViews(frames: frames)
    }
    //////////////////////////////
    // Creates the Different Views
    func setupViews(rect:CGRect){
        
        self.createFrames(rect:rect)
        
        let frames = self.framesForIndex[0]
        favoriteEventView = FavoriteEventView(frame: frames[0])
        
        self.views.append(favoriteEventView)
        
        // Create and Add Time Select Subview
        timeSelectField = TimeSelectField(frame: frames[1])
        timeSelectField.options = self.timeOptions
        self.views.append(timeSelectField)
        
        // Create and Add Message View
        messageSelectionView = MessageSelectionView(frame:frames[2])
        self.views.append(messageSelectionView)
        
        // Reset Frames so Custom Adjustments Can Be Made Before Adding
        self.setFramesForViews(frames:frames)
        
        // Add Views as Subviews
        for view in self.views{
            self.addSubview(view)
        }
        
    }

    
    // Creates the Different View Frames
    func createFrames(rect:CGRect){
        
        let centerFrame = rect
        let leftFrame = CGRect(x: rect.minX - rect.width, y: rect.minY, width: rect.width, height: rect.height)
        let farLeftFrame = CGRect(x: rect.minX - 2.0*rect.width, y: rect.minY, width: rect.width, height: rect.height)
        let rightFrame = CGRect(x: rect.minX + rect.width, y: rect.minY, width: rect.width, height: rect.height)
        let farRightFrame = CGRect(x: rect.minX + 2.0*rect.width, y: rect.minY, width: rect.width, height: rect.height)
        
        framesForIndex.append([centerFrame,rightFrame,farRightFrame])
        framesForIndex.append([leftFrame,centerFrame,rightFrame])
        framesForIndex.append([farLeftFrame,leftFrame,centerFrame])
    }

}
