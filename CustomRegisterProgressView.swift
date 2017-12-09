//
//  CustomRegisterProgressView.swift
//  Pebl2
//
//  Created by Nick Florin on 12/4/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

@IBDesignable
class CustomRegisterProgressView: UIView {
    
    var circleRadius : CGFloat = 14.0
    var path : UIBezierPath?
    var activeIndex : Int = 0
    
    let lineWidth: CGFloat = 1.5
    var yConstant : CGFloat = 0.0
    var widthConstant : CGFloat = 0.0
    var heightConstant : CGFloat = 0.0
    var xList : [CGFloat] = []

    let textStrings : [String] = ["1","2","3"]
    let labelFont = UIFont (name: "SanFranciscoDisplay", size:10)
    let innerCircleColor : UIColor = secondaryColor
    let baseColor : UIColor = UIColor.white
    let secondColor : UIColor = light_blue
    //////////////////////////////
    override func draw(_ rect: CGRect) {
        
        yConstant = bounds.height/2-circleRadius
        widthConstant = 2.0*circleRadius
        heightConstant = 2.0*circleRadius
        xList = [0.0,bounds.width/2-circleRadius,bounds.width-2.0*circleRadius]

        let context = UIGraphicsGetCurrentContext()
        self.drawLine(context: context!)
        self.drawCircles()
    }
    //////////////////////////////
    // Animates/Draws Increment
    func increment(index:Int){
        // Max Index
        if index == textStrings.count-1{
            return
        }
        self.activeIndex = self.activeIndex + 1
        
        // Draw New Circle
        let xPoint = xList[self.activeIndex] as CGFloat
        let rect = CGRect(x: xPoint, y: yConstant, width: widthConstant, height: heightConstant)
        let circleRect = rect.insetBy(dx: 2.0, dy: 2.0)
        self.drawCircleAtIndex(index:self.activeIndex,circleRect:circleRect)
        
        // Redraw Older Circle
        let xPoint2 = xList[self.activeIndex-1] as CGFloat
        let rect2 = CGRect(x: xPoint2, y: yConstant, width: widthConstant, height: heightConstant)
        let circleRect2 = rect2.insetBy(dx: 2.0, dy: 2.0)
        self.drawCircleAtIndex(index:self.activeIndex-1,circleRect:circleRect2)
        
    }
    //////////////////////////////
    // Draw Horizontal Line
    func drawLine(context:CGContext){
        
        context.setLineWidth(lineWidth)
        
        let linePath = UIBezierPath()
        linePath.lineWidth = lineWidth
        
        // Horizontal Line - Always Draw
        linePath.move(to: CGPoint(x:circleRadius,y:bounds.height/2))
        
        // End of Line Point
        linePath.addLine(to: CGPoint(x:bounds.width-circleRadius,y:bounds.height/2))
        
        linePath.lineWidth = lineWidth
        UIColor.white.setStroke()
        linePath.stroke()

    }
    //////////////////////////////
    func createLabelAtIndex(index:Int,textRect:CGRect)->UILabel{
        
        let string = textStrings[index] as String
        let label = UILabel(frame: textRect)
        label.text  = string
        label.textAlignment = .center
        label.font = labelFont
        
        // Default Text Color
        label.textColor = light_blue
        
        return label
    }
    //////////////////////////////
    func drawCircleAtIndex(index:Int,circleRect:CGRect){
        
        path = UIBezierPath(ovalIn: circleRect)
        baseColor.setFill()
        path?.fill()
        
        let textRect = circleRect.insetBy(dx: 5.0, dy: 5.0)
        let label = self.createLabelAtIndex(index:index,textRect:textRect)
        
        if index == self.activeIndex {
            
            // Add SubCircle
            let subcircleRect = circleRect.insetBy(dx: 2.0, dy: 2.0)
            path = UIBezierPath(ovalIn: subcircleRect)
            innerCircleColor.setFill()
            path?.fill()

            label.textColor = baseColor
        }
        label.drawText(in: circleRect)
    }
    //////////////////////////////
    // Draw Circles at Each Point
    func drawCircles(){
    
        // Loop Over 3 Cirlces
        for i in 0...xList.count-1{
            
            let xPoint = xList[i] as CGFloat
            let rect = CGRect(x: xPoint, y: yConstant, width: widthConstant, height: heightConstant)
            let circleRect = rect.insetBy(dx: 2.0, dy: 2.0)
            self.drawCircleAtIndex(index:i,circleRect:circleRect)
        }
    }
    
}
