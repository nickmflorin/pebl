//
//  DottedLines.swift
//  Pebl2
//
//  Created by Nick Florin on 1/12/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

class DottedLines : UIView {
    
    var dotRadius : CGFloat = 1.0
    var dotColor : UIColor = UIColor.white
    var dotSpacingPct : CGFloat = 1.0 // Percentage of Dot Diameter that Dots are Spaced By
    var horizontal : Bool = false
    /////////////////////////////////////
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
    }
    /////////////////////////////////////////
    /// Draw the Circles
    override func draw(_ rect: CGRect) {
        
    }
    ////////////////////////////////////////
    func hideDots(){
        for layer in self.layer.sublayers!{
            layer.removeFromSuperlayer()
        }
    }
    ////////////////////////////////////////
    func drawDots(){
        
        // Determine Direction
        var longLength : CGFloat = self.bounds.height // Default
        self.horizontal = false // Default
        if self.bounds.width > self.bounds.height{
            self.horizontal = true
            longLength = self.bounds.width
        }
        
        // Determine Number of Dots and Dot Size
        let dotD : CGFloat = 2.0*dotRadius
        let W : CGFloat = self.dotSpacingPct * dotD
        let numDots = Int(longLength/(dotD + W + 1.0))
        
        let serialQueue = DispatchQueue(label: "queuename")
        let group = DispatchGroup()
        
       
        DispatchQueue.main.async {
            for i in 0...numDots + 1{
                
                
                var dotFrame : CGRect!
                var leftX : CGFloat!
                var topY : CGFloat!
                
                if self.horizontal == false{
                    leftX = 0.5*(self.bounds.width-dotD)
                    topY = W + CGFloat(i)*(W + dotD)
                    dotFrame = CGRect(x: leftX , y: topY, width: dotD, height: dotD)
                }
                else{
                    leftX = W + CGFloat(i)*(W + dotD)
                    topY = 0.5*(self.bounds.height-dotD)
                    dotFrame = CGRect(x: leftX , y: topY, width: dotD, height: dotD)
                }
                
                // Create Layers for Horizontal and Vertical Portions
                let layer = CAShapeLayer()
                layer.path = UIBezierPath(ovalIn: dotFrame).cgPath
                layer.fillColor = self.dotColor.cgColor
                layer.strokeColor = nil
                
                serialQueue.sync {
                    
                    group.enter()
                    UIView.animate(withDuration: 1.0, delay: 0.0, options:.curveLinear, animations: {
                        print("Adding Layer : \(i)")
                        self.layer.addSublayer(layer)
                        }, completion: { finished in
                            if finished {
                                print("Layer : \(i) Complete")
                                group.leave()
                            }
                    })

                }
                print("Leaving Group \(i)")
                
            }
        }
        
    }
}
