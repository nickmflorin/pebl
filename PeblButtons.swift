//
//  FloatingButtons.swift
//  Pebl2
//
//  Created by Nick Florin on 12/23/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit


//////////////////////////////////////////////////////////
class SuggestionPeblButton: UIView{
    
    var buttonBackgroundColor : UIColor = green
    var imageInsets : CGFloat = 6.0
    var imageViewFrame : CGRect!
    
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.addImage()
        
    }
    /////////////////////////////
    // Draws the Plus Button
    override func draw(_ rect: CGRect) {
        
        // Draw Circle for Button
        let path = UIBezierPath(ovalIn: rect)
        buttonBackgroundColor.setFill()
        path.fill()
        
        self.backgroundColor = UIColor.clear
        self.addImage()
        
    }
    /////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.backgroundColor = UIColor.clear
        self.addImage()
    }
    /////////////////////////////
    // Add Image Layer to Button Layer
    func addImage(){
        
        // Method of Adding Image to Layer - Possibly in Future if Better Solution than ImageView
        //let imageSubLayer = CALayer()
        //imageSubLayer.contents = image?.cgImage
        //self.layer.addSublayer(imageSubLayer)
        
        let image = UIImage(named:"SuggestionPeblIcon")
        imageViewFrame = CGRect(x: self.bounds.minX+imageInsets, y: self.bounds.minY+imageInsets, width: self.bounds.width-2.0*imageInsets, height: self.bounds.height-2.0*imageInsets)
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = image
        self.addSubview(imageView)
        
    }
}

//////////////////////////////////////////////////////////
class MessagePeblButton: UIView{
    
    var buttonBackgroundColor : UIColor = red
    var imageInsets : CGFloat = 6.0
    var imageViewFrame : CGRect!
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.draw(frame)
        self.addImage()
    }
    /////////////////////////////
    // Draws the Plus Button
    override func draw(_ rect: CGRect) {
    
        // Draw Circle for Button
        let path = UIBezierPath(ovalIn: rect)
        buttonBackgroundColor.setFill()
        path.fill()
    }
    /////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        self.addImage()
    }
    /////////////////////////////
    // Add Image Layer to Button Layer
    func addImage(){
        
        // Method of Adding Image to Layer - Possibly in Future if Better Solution than ImageView
        //let imageSubLayer = CALayer()
        //imageSubLayer.contents = image?.cgImage
        //self.layer.addSublayer(imageSubLayer)

        let image = UIImage(named:"MessagePeblIconLetterStyleGreen")
        imageViewFrame = CGRect(x: self.bounds.minX+imageInsets, y: self.bounds.minY+imageInsets, width: self.bounds.width-2.0*imageInsets, height: self.bounds.height-2.0*imageInsets)
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = image
        self.addSubview(imageView)
        
    }
    
}
