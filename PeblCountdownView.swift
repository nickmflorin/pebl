//
//  PeblActivityView.swift
//  Pebl2
//
//  Created by Nick Florin on 12/14/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

////////////////////////////////////////////////////////////////////////////
class PeblCountdownView: UIView {
    
    //Mark : Properties
    var countDownDays : Int = 4
    var totalCountDownDays : Int = 7
    
    // Circle Parameters
    var outerCircleInset : CGFloat = 3.0
    var circleTraceWidth : CGFloat = 8.0
    
    var circleTraceColor : UIColor = green
    var cirlceUnTraceColor : UIColor = accentColor
    
    var circlePctFill : CGFloat!
    var circleCenter : CGPoint!
    
    var circleRadius : CGFloat!
    var circleC : CGFloat!
    
    var circlePath : UIBezierPath!
    var travelAngle : CGFloat!
    var startAngle = CGFloat(3 * M_PI_2)
    
    // Label Parameters
    var defaultLabelText : String = "Days"
    var labelHeight : CGFloat = 15.0
    var labelWidth : CGFloat = 40.0
    var labelSeparation : CGFloat = 2.0
    let labelFont = UIFont (name: "SanFranciscoDisplay-Regular", size:12)
    let labelColor = primaryTextColor
    
    //////////////////////////////
    //// Init from Coder
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.clipsToBounds = false
    }
    //////////////////////////////////
    // Wait for Layout Subviews Before Creating Label
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleRadius = 0.5*(self.bounds.height - 2.0*outerCircleInset) - 0.5 * circleTraceWidth
        circleCenter = CGPoint(x: 0.5*self.bounds.width,y: 0.5 * self.bounds.height)
        circlePctFill = CGFloat(countDownDays)/CGFloat(totalCountDownDays)
        circleC = CGFloat(2 * M_PI) * circleRadius

        travelAngle = circlePctFill * CGFloat(2 * M_PI)
        
        // Draw Labels After Layout of Subviews
        self.drawLabels()
    }
    /////////////////////////////
    override func draw(_ rect: CGRect) {
        self.drawCircle()
    }
    //////////////////////////////////
    func drawCircle(){
        
        // Draw Filled Arc
        let endAngle = travelAngle + startAngle
        circlePath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: travelAngle, endAngle: endAngle, clockwise: true)
        circlePath.lineWidth = circleTraceWidth
        circleTraceColor.setStroke()
        circlePath.stroke()
        
        // Draw Unfilled Arc
        let finalendAngle = startAngle
        circlePath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: endAngle, endAngle: finalendAngle, clockwise: true)
        cirlceUnTraceColor.setStroke()
        circlePath.lineWidth = circleTraceWidth
        circlePath.stroke()
    }
    //////////////////////////////////
    func drawLabels(){
        
        // Default Label for Days Left Literal "Days"
        let upperLabelX = circleCenter.x - 0.5*labelWidth
        let upperLabelY = circleCenter.y - labelHeight - 0.5*labelSeparation
        let upperLabelFrame = CGRect(x: upperLabelX, y: upperLabelY, width: labelWidth, height: labelHeight)
        
        let upperLabel = UILabel(frame: upperLabelFrame)
        
        let stringInt : String = String(countDownDays)
        upperLabel.text = stringInt
        upperLabel.textAlignment = .center
        upperLabel.font = labelFont
        upperLabel.textColor = labelColor
        
        self.addSubview(upperLabel)
        self.bringSubview(toFront: upperLabel)
        
        // Label Formatted Based on Number of Days Left
        let lowerLabelX = circleCenter.x - 0.5*labelWidth
        let lowerLabelY = circleCenter.y + 0.5*labelSeparation
        let lowerLabelFrame = CGRect(x: lowerLabelX, y: lowerLabelY, width: labelWidth, height: labelHeight)
    
        let defaultLabel = UILabel(frame: lowerLabelFrame)
        
        defaultLabel.text = defaultLabelText
        defaultLabel.textAlignment = .center
        defaultLabel.font = labelFont
        defaultLabel.textColor = labelColor
        
        self.addSubview(defaultLabel)
        self.bringSubview(toFront: defaultLabel)
        
    }

}
