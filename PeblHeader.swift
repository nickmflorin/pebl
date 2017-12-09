//
//  ThumbnailHeader.swift
//  Pebl2
//
//  Created by Nick Florin on 12/30/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

/////////////////////////////////////
class PeblHeader: UIView {
    
    // Mark: Properties
    var label : UILabel!
    var numPeblLabel : UILabel!
    var path : UIBezierPath!
    
    // Mark: Spacing and Distance Properties
    var labelHorMargin : CGFloat = 6.0
    var labelFrame : CGRect!
    var borderLineWidth : CGFloat = 1.5
    
    var labelHorizontalPadding : CGFloat = 3.0
    var numPeblLabelFrame : CGRect!
    
    // Mark: Variable Properties
    var headerText : String!
    var currentCount : Int = 0
    var backgroundC : UIColor = accentColor.withAlphaComponent(0.4)
    var textC : UIColor = secondaryColor
    var numPeblTextC : UIColor = light_blue
    var borderC : UIColor = light_blue

    var textFont = UIFont (name: "SanFranciscoDisplay-Medium", size:15)
    
    /////////////////////////////////////
    override init(frame: CGRect){
        super.init(frame:frame)
        
        // Style
        self.backgroundColor = backgroundC
        self.draw(frame)
    
    }
    /////////////////////////////////////////
    /// Draw the Borders/Underlines
    override func draw(_ rect: CGRect) {
        
        path = UIBezierPath()
        path.lineWidth = borderLineWidth
        
        /// Find Top Left Starting Point Using Insetted Rect
        let leftPointTop = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
        let rightPointTop = CGPoint(x: self.bounds.maxX, y: self.bounds.minY)
        let leftPointBottom = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
        let rightPointBottom = CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)
        
        // First Line
        // Move to Initial Point
        path.move(to: leftPointTop)
        // Draw First Cross Line
        path.addLine(to: rightPointTop)
        
        borderC.setStroke()
        path.stroke()
        
        // Second Line
        // Move to Initial Point
        path.move(to: leftPointBottom)
        // Draw First Cross Line
        path.addLine(to: rightPointBottom)
        
        borderC.setStroke()
        path.stroke()
        
    }
    /////////////////////////////////////////
    func setup(headerText:String){
        self.headerText = headerText
        self.createLabel()
    }
    /////////////////////////////////////////
    func createLabel(){
        
        // Create Label for Message Pebls - Width Will be Sized to Fit
        labelFrame = CGRect(x: self.bounds.minX+labelHorMargin, y: self.bounds.minY, width: 100.0, height: self.bounds.height)
        label = UILabel(frame: labelFrame)
        
        label.text = headerText
        label.font = textFont
        label.textColor = textC
        
        label.sizeToFit()
        
        // Recenter Label
        let labelH = label.frame.height
        let labelW = label.frame.width
        let leftoverSpace = self.bounds.height - labelH
        labelFrame = CGRect(x: self.bounds.minX+labelHorMargin, y: self.bounds.minY+0.5*leftoverSpace, width: labelW, height: labelH)
        label.frame = labelFrame
        self.addSubview(label)
        
        // Create Label for Num Message Pebls - Width Will be Sized to Fit
        numPeblLabelFrame = CGRect(x: label.frame.maxX+labelHorizontalPadding, y: self.bounds.minY, width: 100.0, height: self.bounds.height)
        numPeblLabel = UILabel(frame: labelFrame)
        
        numPeblLabel.text = "(0)"
        numPeblLabel.font = textFont
        numPeblLabel.textColor = numPeblTextC
        
        numPeblLabel.sizeToFit()
        
        // Recenter Label
        let labelH2 = label.frame.height
        let labelW2 = label.frame.width
        let leftoverSpace2 = self.bounds.height - labelH
        numPeblLabelFrame = CGRect(x: label.frame.maxX+labelHorizontalPadding, y: self.bounds.minY+0.5*leftoverSpace2, width: labelW2, height: labelH2)
        numPeblLabel.frame = numPeblLabelFrame
        self.addSubview(numPeblLabel)
    }
    /////////////////////////////////////////
    // Updates Count in Label for Message Pebls
    func updateCount(count:Int){
        currentCount = count
        numPeblLabel.text = "("+String(currentCount)+")"
    }
    /////////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
