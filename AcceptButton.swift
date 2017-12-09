//
//  AcceptButton.swift
//  Pebl2
//
//  Created by Nick Florin on 12/26/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

/////////////////////////////////////////
class AcceptButton: UIButton {

    var path : UIBezierPath!
    var backgroundC: UIColor = UIColor.clear
    var horizontalPadding : CGFloat = 3.0
    var cornerRadius : CGFloat = 4.0
    
    var plusColor : UIColor = green
    var padding : CGFloat = 8.0
    var plusLineWidth : CGFloat = 1.5
    
    var plusWidth : CGFloat!
    var plusHeight : CGFloat!
    var plusFrame : CGRect!
    var plusLocation : String = "left"
    
    var labelFrame : CGRect!
    var labelText : String = "Accept"
    var labelFont = UIFont (name: "SanFranciscoDisplay-Medium", size:12)
    var labelColor : UIColor = green
    
    /////////////////////////////////////////
    /// Draw the Button Cross
    override func draw(_ rect: CGRect) {
        
        // Determine Plus Size
        plusHeight = rect.height - 2.0*padding
        plusWidth = plusHeight
        
        if plusLocation == "left"{
            plusFrame = CGRect(x: rect.minX + padding, y: rect.minY + padding, width: plusWidth, height: plusHeight)
            labelFrame = CGRect(x: plusFrame.maxX, y: rect.minY, width: rect.width - plusFrame.width - padding, height: rect.height)
        }
        else{
            // Need to do/fix
            plusFrame = CGRect(x: rect.maxX - padding - plusWidth, y: rect.minY + padding, width: plusWidth, height: plusHeight)
            labelFrame = CGRect(x: padding, y: rect.minY, width: rect.maxX - (plusFrame.minX + horizontalPadding), height: rect.height)
        }
        
        path = UIBezierPath()
        path.lineWidth = plusLineWidth
        
        /// Find Top Left Starting Point Using Insetted Rect
        let topPoint = CGPoint(x: plusFrame.midX, y: plusFrame.minY)
        let bottomPoint = CGPoint(x: plusFrame.midX, y: plusFrame.maxY)
        let leftPoint = CGPoint(x: plusFrame.minX, y: plusFrame.midY)
        let rightPoint = CGPoint(x: plusFrame.maxX, y: plusFrame.midY)
        
        // First Line
        // Move to Initial Point
        path.move(to: topPoint)
        // Draw First Cross Line
        path.addLine(to: bottomPoint)
        
        plusColor.setStroke()
        path.stroke()
        
        // Second Line
        // Move to Initial Point
        path.move(to: leftPoint)
        // Draw First Cross Line
        path.addLine(to: rightPoint)
        
        plusColor.setStroke()
        path.stroke()
        
        self.createLabel(rect:rect)
        
        // Draw Layer Styling
        self.layer.backgroundColor = backgroundC.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1.5
        self.layer.borderColor = green.cgColor
    }
    /////////////////////////////////////////
    func createLabel(rect:CGRect){
        
        let label = UILabel(frame: labelFrame)
        label.text = labelText
        label.font = labelFont
        label.textColor = labelColor
        label.textAlignment = .center
        self.addSubview(label)
        
    }

}
