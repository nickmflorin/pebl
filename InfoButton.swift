//
//  InfoButton.swift
//  Pebl2
//
//  Created by Nick Florin on 1/11/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

class InfoButton: UIButton {

    var color : UIColor = light_blue
    var cornerRadius : CGFloat = 1.0
    
    var labelText : String = "Info"
    var labelColor : UIColor = UIColor.white
    var labelFont = UIFont (name: "SanFranciscoDisplay-Medium", size:14)
    var label : UILabel!
    
    var imgView : UIImageView!
    let imagePadding : CGFloat = 12.0
    var labelRightInset : CGFloat = 8.0
    var horizontalPadding : CGFloat = 6.0
    
    var iconImage : UIImage = UIImage(named:"ProfileInfoIconWhite")!
    
    /////////////////////////////////////////
    /// Draw the Button
    override func draw(_ rect: CGRect) {
        
        // Draw Layer Styling
        self.layer.backgroundColor = color.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        
        self.createLabel()
        self.createIcon()
        self.adjustFrames()
    }
    ///////////////////////////
    func adjustFrames(){
        
        let totalWidth = imgView.frame.width + label.frame.width + horizontalPadding
        let leftoverWidthInset = 0.5*(self.bounds.width - totalWidth)
        imgView.frame = CGRect(x: leftoverWidthInset, y:self.imgView.frame.minY , width: self.imgView.frame.width, height: self.imgView.frame.height)
        label.frame = CGRect(x: self.bounds.maxX - label.frame.width - leftoverWidthInset, y:self.label.frame.minY , width: self.label.frame.width, height: self.label.frame.height)
        
    }
    /////////////////////////////////////////
    func createIcon(){
        imgView = UIImageView(frame: CGRect(x: self.bounds.minX + imagePadding, y: self.bounds.minY + imagePadding, width: self.bounds.height - 2.0*imagePadding, height: self.bounds.height - 2.0*imagePadding))
        imgView.image = iconImage
        imgView.contentMode = .scaleAspectFit
        self.addSubview(imgView)
    }
    /////////////////////////////////////////
    func createLabel(){
        
        // Create Frame
        var labelFrame = CGRect.zero
        
        label = UILabel(frame: labelFrame)
        label.text = labelText
        label.font = labelFont
        label.textColor = labelColor
        label.textAlignment = .center
        
        label.sizeToFit()
        
        // Adjust Frame
        labelFrame = CGRect(x: self.bounds.maxX - labelRightInset - label.frame.width, y: self.bounds.minY + 0.5*(self.bounds.height - label.frame.height), width: label.frame.width, height: label.frame.height)
        label.frame = labelFrame
        self.addSubview(label)
        
    }


}
