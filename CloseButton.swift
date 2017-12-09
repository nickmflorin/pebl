//
//  CloseButton.swift
//  Pebl2
//
//  Created by Nick Florin on 12/26/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

class CloseButton: UIButton {
    
    var crossInset : CGFloat = 5.0
    var lineWidth : CGFloat = 1.5
    
    var circleDiameter : CGFloat!
    var circleRect : CGRect!
    
    var circleLayer : CAShapeLayer!
    var line1Layer : CAShapeLayer!
    var line2Layer : CAShapeLayer!
    
    var buttonColor : UIColor = UIColor.white
    
    /// Draw the Button
    override func draw(_ rect: CGRect) {
        
        self.tintColor = light_blue
        
        circleDiameter = min(rect.height,rect.width)
        
        // Adjust Frame So Circle Always Aspect Fit
        if rect.height == rect.width{
            circleRect = rect
        }
        else if rect.height < rect.width{
            let diff = 0.5*(rect.width - rect.height)
            circleRect = CGRect(x: diff, y: 0.0, width: rect.height, height: rect.height)
        }
        else {
            let diff = 0.5*(rect.height - rect.width)
            circleRect = CGRect(x: 0.0, y: diff, width: rect.width, height: rect.width)
        }
        
        /// Draw Outline Circle
        circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(ovalIn: circleRect)

        circleLayer.lineWidth = lineWidth
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = buttonColor.cgColor
        circleLayer.fillColor = nil
        
        self.layer.addSublayer(circleLayer)
        
        // Draw First Line
        let linePath1 = UIBezierPath()
        line1Layer = CAShapeLayer()
        line1Layer.lineWidth = lineWidth
        line1Layer.strokeColor = buttonColor.cgColor
        line1Layer.fillColor = nil
        
        // Distance from Corner Point of Circle to Corner Point of Outline Rect
        let radialSquareDistance : CGFloat = (0.5*rect.width)-(0.5*rect.width)/(sqrt(2))
        let point1 = CGPoint(x: rect.minX+radialSquareDistance+crossInset, y: rect.maxY-radialSquareDistance-crossInset)
        let point2 = CGPoint(x: rect.maxX-radialSquareDistance-crossInset, y: rect.minY+radialSquareDistance+crossInset)
        
        linePath1.move(to: point1)
        linePath1.addLine(to: point2)
        
        line1Layer.path = linePath1.cgPath
        self.layer.addSublayer(line1Layer)
        
        // Draw Second Line
        let linePath2 = UIBezierPath()
        line2Layer = CAShapeLayer()
        line2Layer.lineWidth = lineWidth
        line2Layer.strokeColor = buttonColor.cgColor
        line2Layer.fillColor = nil
        
        // Distance from Corner Point of Circle to Corner Point of Outline Rect
        let point3 = CGPoint(x: rect.minX+radialSquareDistance+crossInset, y: rect.minY+radialSquareDistance+crossInset)
        let point4 = CGPoint(x: rect.maxX-radialSquareDistance-crossInset, y: rect.maxY-radialSquareDistance-crossInset)
        
        linePath2.move(to: point3)
        linePath2.addLine(to: point4)
        
        line2Layer.path = linePath2.cgPath
        self.layer.addSublayer(line2Layer)
        
    }
    

}
