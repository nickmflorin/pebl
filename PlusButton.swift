//
//  PlusButton.swift
//  Pebl2
//
//  Created by Nick Florin on 1/8/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

// Delegate to Allow Cell to Communicate with Main View
protocol PlusButtonDelegate {
    func activated(plusButton: PlusButton)
    func deactivated(plusButton: PlusButton)
}

//////////////////////////////////////////////////////////
class PlusButton: UIButton{
    
    var buttonHorizontalMargin : CGFloat = 3.0
    var buttonVerticalMargin : CGFloat = 3.0
    var plusButtonPlusMargin : CGFloat = 8.0
    
    var plusButtonBackgroundColor : UIColor = light_blue
    var cancelButtonBackgroundColor : UIColor = red
    
    var plusButtonPlusColor : UIColor = UIColor.white
    var plusLineWidth : CGFloat = 3.0
    
    var path : UIBezierPath!
    var plusWidth : CGFloat!
    var plusHeight : CGFloat!
    
    var active : Bool = false // Default to false so toggled on in draw(rect)
    
    var backgroundLayer : CAShapeLayer!
    var horizontalLayer : CAShapeLayer!
    var verticalLayer : CAShapeLayer!
    
    var delegate : PlusButtonDelegate?
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.draw(frame)
        self.addTarget(self, action: #selector(PlusButton.buttonClicked), for: .touchUpInside)
    }
    /////////////////////////////
    // Draws the Plus Button
    override func draw(_ rect: CGRect) {
        
        // Draw Circle for Button
        path = UIBezierPath(ovalIn: rect)
        backgroundLayer = CAShapeLayer()
        
        backgroundLayer.path = path.cgPath
        self.plusMode()
    }
    //////////////////////////
    // Toggles Button and Calls Delegate
    func buttonClicked(){
       
        if self.active == false{
            self.cancelMode()
            self.delegate?.activated(plusButton: self)
            self.active = true
        }
        else{
            self.plusMode()
            self.delegate?.deactivated(plusButton: self)
            self.active = false
        }
    }
    //////////////////////////
    // Draws Horizontal Line Only
    func drawHorizontal(){
        
        horizontalLayer = CAShapeLayer()
        horizontalLayer.lineWidth = plusLineWidth
        plusWidth = bounds.width - 2.0*buttonHorizontalMargin - 2.0*plusButtonPlusMargin
        
        let plusPath = UIBezierPath()
        plusPath.lineWidth = plusLineWidth
        
        plusPath.move(to: CGPoint(x:bounds.width/2 - plusWidth/2, y:bounds.height/2))
        plusPath.addLine(to: CGPoint(x:bounds.width/2 + plusWidth/2,y:bounds.height/2))
        
        horizontalLayer.path = plusPath.cgPath
        horizontalLayer.lineCap = kCALineCapRound
        horizontalLayer.fillColor = nil
        horizontalLayer.strokeColor = plusButtonPlusColor.cgColor
        
        self.layer.addSublayer(horizontalLayer)

    }
    //////////////////////////
    // Draws Vertical Line Only
    func drawVertical(){
        
        verticalLayer = CAShapeLayer()
        verticalLayer.lineWidth = plusLineWidth
        plusHeight = bounds.height - 2.0*buttonVerticalMargin - 2.0*plusButtonPlusMargin
        
        let plusPath = UIBezierPath()
        
        plusPath.move(to: CGPoint(x:bounds.width/2,y:bounds.height/2-plusHeight/2))
        plusPath.addLine(to: CGPoint(x:bounds.width/2,y:bounds.height/2+plusHeight/2))
        
        verticalLayer.path = plusPath.cgPath
        verticalLayer.lineCap = kCALineCapRound
        verticalLayer.fillColor = nil
        verticalLayer.strokeColor = plusButtonPlusColor.cgColor
        
        self.layer.addSublayer(verticalLayer)
    }
    /////////////////////////////
    // Switches the Button to Cancel Mode
    func cancelMode(){
        
        backgroundLayer.removeFromSuperlayer()
        backgroundLayer.fillColor = cancelButtonBackgroundColor.cgColor
        self.layer.addSublayer(backgroundLayer)
        
        if verticalLayer != nil{
            verticalLayer.removeFromSuperlayer()
        }
        if horizontalLayer != nil{
            horizontalLayer.removeFromSuperlayer()
        }
        self.drawHorizontal()
    }
    /////////////////////////////
    // Switches the Button to Plus Mode
    func plusMode(){

        backgroundLayer.removeFromSuperlayer()
        backgroundLayer.fillColor = plusButtonBackgroundColor.cgColor
        self.layer.addSublayer(backgroundLayer)
        
        if verticalLayer != nil{
            verticalLayer.removeFromSuperlayer()
        }
        
        self.drawVertical()
        
        if horizontalLayer != nil{
            horizontalLayer.removeFromSuperlayer()
        }
        
        self.drawHorizontal()
        
    }
    /////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
