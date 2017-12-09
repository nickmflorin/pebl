//
//  StarButton.swift
//  Pebl2
//
//  Created by Nick Florin on 1/23/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

@IBDesignable
class StarButton: UIButton {

    var path : UIBezierPath!
    var backgroundC: UIColor = UIColor.clear
    
    var buttonOutlineColor : UIColor = light_blue
    var buttonInactiveFillColor : UIColor = UIColor.white
    var buttonActiveFillColor : UIColor = light_blue
    var lineWidth : CGFloat = 2.5
    var padding : CGFloat = 2.0
    var insetPadding : CGFloat = 4.5
    
    
    var active : Bool = false
    /////////////////////////////////////////
    /// Draw the Button
    override func draw(_ rect: CGRect) {
        
        self.backgroundColor = backgroundC
        self.clipsToBounds = false
        
        // Draw Base Star First and Then Draw White Smaller White Star Over Top
        self.drawStar(firstStar:true)
        self.drawStar(firstStar:false)
    }
    /////////////////////////////////////////
    // Draws Single Star - Called Twice
    func drawStar(firstStar:Bool){
        
        // Create Layers for Horizontal and Vertical Portions
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        
        let size = min(self.bounds.height,self.bounds.width)
        layer.lineWidth = self.lineWidth
        layer.strokeColor = nil
        
        var starFrame : CGRect!
        if firstStar {
            layer.fillColor = buttonOutlineColor.cgColor
            starFrame = CGRect(x:padding,y:padding,width:size-2.0*padding,height:size-2.0*padding)
        }
        else{
            layer.fillColor = buttonInactiveFillColor.cgColor
            starFrame = CGRect(x:padding+insetPadding,y:padding+insetPadding,width:size-2.0*(padding+insetPadding),height:size-2.0*(padding+insetPadding))
        }
        // Draw Base Star First and Then Draw White Smaller White Star Over Top
        let w = starFrame.width
        let r : CGFloat = 0.5*w
        let theta : CGFloat = 2.0 * CGFloat(M_PI) * (2.0 / 5.0)
        let flip : CGFloat = -1.0
        
        let xCenter : CGFloat = 0.5*starFrame.width + starFrame.minX
        let yCenter : CGFloat = 0.5*starFrame.height + starFrame.minY
        
        path.move(to: CGPoint(x:xCenter,y:r*flip+r))
        for k in 1...5 {
            let x = r*sin(CGFloat(k)*theta)
            let y = r*cos(CGFloat(k)*theta)
            path.addLine(to: CGPoint(x: x+xCenter, y: y*flip+r+yCenter))
            
        }
        layer.path = path.cgPath
        self.layer.addSublayer(layer)
        
    }
}
