//
//  PhotoButton.swift
//  Pebl2
//
//  Created by Nick Florin on 11/17/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

@IBDesignable
class PhotoButton: UIButton {
    
    var isAddButton : Bool = false
    var isRemoveButton : Bool = true
    //////////////////////////
    override func draw(_ rect: CGRect) {
        
        let plusWidth: CGFloat = 3.0
        let plusHeight: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        // Draw Circle for Button
        var path = UIBezierPath(ovalIn: rect)
        if isAddButton{
            light_blue.setFill()
        }
        else{
            red.setFill()
        }
        path.fill()

        // Draw Plus Sign
        var plusPath = UIBezierPath()
        plusPath.lineWidth = plusWidth
        
        // Horizontal Line - Always Draw
        // Begining of Line Point
        plusPath.move(to: CGPoint(
            x:bounds.width/2 - plusHeight/2,
            y:bounds.height/2))
        
        // End of Line Point
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2 + plusHeight/2,
            y:bounds.height/2))
        
        UIColor.white.setStroke()
        plusPath.stroke()
        
        // Vertical Line - Only Draw for Add
        if isAddButton{
            var plusPathV = UIBezierPath()
            plusPathV.lineWidth = plusWidth
            
            // Begining of Line Point
            plusPathV.move(to: CGPoint(
                x:bounds.width/2,
                y:bounds.height/2-plusHeight/2))
            
            // End of Line Point
            plusPathV.addLine(to: CGPoint(
                x:bounds.width/2,
                y:bounds.height/2+plusHeight/2))
            
            UIColor.white.setStroke()
            plusPathV.stroke()
        }
    }

}
