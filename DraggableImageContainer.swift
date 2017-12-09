//
//  DraggableImageContainer.swift
//  Pebl2
//
//  Created by Nick Florin on 11/20/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

class DraggableImageContainer: UIView {
    
    ////////////////
    // Mark: Properties
    var dragStartPositionRelativeToCenter : CGPoint?
    var whiteRoundedView : UIView!
    let edgeInset : CGFloat = 3.0
    var imageView : DraggableImageView!
    var expandedContainer : Bool = false
    ////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    ////////////////////////////////
    func initialize(){
        
        // Create Styling of View
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.shadowOffset = CGSize(width: -2, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0;
    }
    ////////////////////////////////
    // Creates Draggable Image View from Image and Attaches as Sub View
    func attachImage(image:UIImage){
        
        self.imageView = DraggableImageView(image: image)
        self.imageView.expandedContainer = self.expandedContainer
        
        self.imageView.frame = self.bounds.insetBy(dx: 3.0, dy: 3.0)
        self.imageView.image = image
        self.addSubview(self.imageView)
        
    }
    ////////////////////////////////////////////////
    // Detaches Image View from Super View (White Outline Background) to Allow Free Floating in New Superview
    // Puts Image View in Super Super View
    func detachImageView(){
        
        let preFrame = self.frame
        
//        let parentVC = self.parentViewController as! EditProfileDetailsVC
//        parentVC.floatingActive = true
//        parentVC.floatingView = self.imageView
//        
//        self.imageView.removeFromSuperview()
//        
//        self.frame = self.convert(preFrame, to: parentVC.view)
//        parentVC.view.addSubview(self.imageView)
        
        self.imageView.separated = true
    }
    ////////////////////////////////////////////////
    // Reattaches Image View to Super View (White Outline Background) and Removes From Super Super View
    func attachImageView(){
        
//        let parentVC = self.parentViewController as! EditProfileDetailsVC
//        parentVC.floatingActive = false
//        parentVC.floatingView = nil
//        
//        
//        self.imageView.removeFromSuperview()
//        
//        self.imageView.frame = self.bounds.insetBy(dx: 3.0, dy: 3.0)
//        self.addSubview(self.imageView)
        
        self.imageView.separated = false
    }
    

}
