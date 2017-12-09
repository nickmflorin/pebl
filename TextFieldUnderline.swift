//
//  TextFieldUnderline.swift
//  Pebl2
//
//  Created by Nick Florin on 11/21/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

@IBDesignable
class TextFieldUnderline: UIView {

    var path : UIBezierPath?
    //////////////////////////////
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()

        let lineWidth: CGFloat = 0.25
        context?.setLineWidth(1.0);
        
        let linePath = UIBezierPath()
        
        linePath.lineWidth = lineWidth
        
        // Horizontal Line - Always Draw
        // Begining of Line Point
        linePath.move(to: CGPoint(
            x:0.0,
            y:bounds.height/2))
        
        // End of Line Point
        linePath.addLine(to: CGPoint(
            x:bounds.width,
            y:bounds.height/2))
        
        linePath.lineWidth = lineWidth
        secondaryColor.setStroke()
        linePath.stroke()
    }
}
