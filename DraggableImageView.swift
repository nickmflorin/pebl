//
//  DraggableImageView.swift
//  Pebl2
//
//  Created by Nick Florin on 11/17/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit


class DraggableImageView: UIImageView {
    
    ////////////////
    // Mark: Properties
    var dragStartPositionRelativeToCenter : CGPoint?
    var whiteRoundedView : UIView!
    var separated : Bool = false
    var expandedContainer : Bool = false
    var originalFrame : CGRect!
    
    var editProfileVC : EditProfileDetailsVC!
    var container : DraggableImageContainer!
    ////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    ////////////////////////////////
    override init(image: UIImage!) {
        super.init(image: image)
        self.image = image
        initialize()
    }
    ////////////////////////////////
    func initialize(){
        
        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true

        // Attach Pan Gesture and Selector
        self.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(handlePan))
        self.addGestureRecognizer(panGesture)
        
        //self.editProfileVC = self.superview?.parentViewController as! EditProfileDetailsVC
        self.container = self.superview as! DraggableImageContainer?
    }
    ////////////////////////////////////////////////
    func shrink(){
        var duration : Double = 1.0
        // Shrink Animation Size Depends on Expanded Container or Not
        if self.expandedContainer {
            UIView.animate(withDuration: duration) {
                self.frame.size = CGSize(width: 0.7*self.frame.width, height: 0.7*self.frame.height)
            }
        }
        else{
            UIView.animate(withDuration: duration) {
                self.frame.size = CGSize(width: 0.9*self.frame.width, height: 0.9*self.frame.height)
            }
        }
    }
    ////////////////////////////////////////////////
    // Function that Actually Pans the Image
    func pan(nizer:UIPanGestureRecognizer!){
        // Panning Control - This Controls The Movement Case
        if self.separated{
            
            let locationInView = nizer.location(in: self.superview)
            if self.dragStartPositionRelativeToCenter != nil{
                // Animate Panning of the Center of the Image View
                UIView.animate(withDuration: 0.1) {
                    self.center = CGPoint(x: locationInView.x - self.dragStartPositionRelativeToCenter!.x,
                                          y: locationInView.y - self.dragStartPositionRelativeToCenter!.y)
                }
                
            }
            
        }
    }
    ////////////////////////////////////////////////
    // Handles Pan Control for Image View
    func handlePan(nizer: UIPanGestureRecognizer!) {
        
        //////// Pan About to Begin
        if nizer.state == UIGestureRecognizerState.began {
            
            // Image View Not Yet Separated
            if self.separated == false{
                
                let superView = self.superview as! DraggableImageContainer
                superView.detachImageView()
                
                //self.shrink() // Animate Shrink of Image View
                let locationInView = nizer.location(in: self.superview)
                self.dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
            }
            // Already Separated
            else{
                let locationInView = nizer.location(in: self.superview)
                self.dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
            }
        }
        ///  Pan Ended
        if nizer.state == UIGestureRecognizerState.ended {
            self.dragStartPositionRelativeToCenter = nil
            //let intersection = self.editProfileVC.detectInterSections()
            let intersection = false
            // If No Intersection - Return to Original Position
            if intersection == false {
                print("Intersected")
                // Return Image View to Original Container
                //let superView = self.superview as! DraggableImageContainer
                //superView.attachImageView()

            }
        }
        
        // Look For Intersected Cells
        ///self.editProfileVC.detectInterSections()
        self.pan(nizer: nizer)
    }


}
