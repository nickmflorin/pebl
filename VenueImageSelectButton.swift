//
//  VenueImageSelectButton.swift
//  Pebl2
//
//  Created by Nick Florin on 1/28/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

class VenueImageSelectButton: UIButton {

    var circleDiameter : CGFloat!
    var circleRect : CGRect!
    
    var circleLayer : CAShapeLayer!
    var checkLayer : CAShapeLayer!
    
    var circleColorUnselected : UIColor = UIColor.lightGray
    var circleColorSelected : UIColor = UIColor.white
    var circleLineWidth : CGFloat = 2.0
    
    var checkColorUnselected : UIColor = UIColor.clear
    var checkColorSelected : UIColor = UIColor.white
    var checkLineWidth : CGFloat = 2.0
    
    /////////////////////////////////////////
    /// Draw the Button Cross
    override func draw(_ rect: CGRect) {
        
        self.addTarget(self, action: #selector(VenueImageSelectButton.selectButton), for: .touchDown)
        
        // Add Background Layer Clear to Detect Touch
        /// Draw Outline Circle
        let backgroundLayer = CAShapeLayer()
        let backgroundPath = UIBezierPath(rect: rect)
        
        backgroundLayer.lineWidth = circleLineWidth
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.strokeColor = UIColor.clear.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(backgroundLayer)
        
        let drawSquareSideLength = min(rect.height,rect.width)
        let drawRect = CGRect(x: rect.minX, y: rect.minY, width: drawSquareSideLength, height: drawSquareSideLength)
        circleLayer = self.createCircleLayer(rect:drawRect)
        checkLayer = self.createCheckLayer(rect: drawRect)
        self.layer.addSublayer(circleLayer)
        self.layer.addSublayer(checkLayer)
    }
    // Create outline circle layer
    func createCircleLayer(rect:CGRect) -> CAShapeLayer {
        
        // Draw Outline Circle
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
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(ovalIn: circleRect)
        
        circleLayer.lineWidth = circleLineWidth
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = circleColorUnselected.cgColor
        circleLayer.fillColor = nil
        
        return circleLayer
    }
    // Create check graphic layer
    func createCheckLayer(rect:CGRect) -> CAShapeLayer {
        
        // Create Layers for Horizontal and Vertical Portions
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        
        layer.lineWidth = self.circleLineWidth
        layer.strokeColor = checkColorUnselected.cgColor
        
        let startY = 0.6 * rect.height
        let startX = 0.3 * rect.width
        path.move(to: CGPoint(x: startX, y: startY))
        
        var nextPoint = CGPoint(x: 0.45 * rect.width, y: 0.7 * rect.height)
        path.addLine(to: nextPoint)
        path.move(to: nextPoint)
        
        nextPoint = CGPoint(x: 0.7 * rect.width, y: 0.2 * rect.height)
        path.addLine(to: nextPoint)
        path.move(to: nextPoint)
        
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        layer.path = path.cgPath
        return layer
        
    }
    // Used for initializing the button in another View
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
        
    }
    // Removes selected layer visuals from graphic
    func deselectButton(){
        
        circleLayer.strokeColor = circleColorUnselected.cgColor
        checkLayer.strokeColor = checkColorUnselected.cgColor
        
    }
    // Draws check mark inside the circular layer
    func selectButton(){
        
        circleLayer.strokeColor = circleColorSelected.cgColor
        checkLayer.strokeColor = checkColorSelected.cgColor
        
    }

}
