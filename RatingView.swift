//
//  RatingView.swift
//  Pebl2
//
//  Created by Nick Florin on 1/7/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

////////////////////////////////////////////////////////////////////////
class RatingView: UIView {

    var rating : CGFloat!
    var orientation : String = "left" // Default
    var starColor : UIColor = light_blue
    var starMaskColor : UIColor = UIColor.white
    
    /////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.backgroundColor = UIColor.clear
    }
    override func layoutSubviews() {
        if self.rating != nil {
            self.applyRating(rating: self.rating)
        }
    }
    /////////////////////////////////////
    func applyRating(rating:CGFloat){
        
        self.rating = rating
        let imageWidth : CGFloat = self.bounds.height
        
        var halfStar : Bool = false
        let intRating = Int(floor(self.rating)) // Round down rating to nearest int
        if intRating % 2 != 0 { // Odd Number
            halfStar = true
        }
        
        // Determine X Starting Position
        let numStars = Int(floor(self.rating/2.0))
        for i in 0...numStars{
            
            var startX : CGFloat!
            var useHalfStar : Bool = false
            
            // Right orientation by default, starts drawing star rating from right of frame
            if self.orientation == "right"{
                startX = self.bounds.width - CGFloat(i+1)*imageWidth
                if halfStar && i == 0{ // Last star but first star drawn
                    useHalfStar = true
                }
            }
            // Left orientation starts drawing star rating from left of frame
            else{
                startX = self.bounds.minX + CGFloat(i)*imageWidth
                if halfStar && i == numStars{ // Last star and last star drawn
                    useHalfStar = true
                }
            }
            self.drawStarLayer(startX: startX)
            if useHalfStar == true { // Odd Number
                self.maskStar(startX: startX)
            }
        }
    }
    /////////////////////////////////////
    // Creates a Mask for Star to Make Half Star
    func maskStar(startX:CGFloat){
        
        let frame = CGRect(x:startX + 0.5*self.bounds.height,y:self.bounds.minY,width:self.bounds.height,height:self.bounds.height)
        
        // Create Layers for Horizontal and Vertical Portions
        let layer = CAShapeLayer()
        let path = UIBezierPath(rect: frame)
        layer.path = path.cgPath
        layer.fillColor = starMaskColor.cgColor
        layer.strokeColor = nil
        
        self.layer.addSublayer(layer)
    }
    /////////////////////////////////////
    // Draws the Layer for a Single Star
    func drawStarLayer(startX:CGFloat){
        
        let frame = CGRect(x:startX,y:self.bounds.minY,width:self.bounds.height,height:self.bounds.height)
        
        // Create Layers for Horizontal and Vertical Portions
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        
        let w = frame.width
        let r : CGFloat = 0.5*w
        let theta : CGFloat = 2.0 * CGFloat(M_PI) * (2.0 / 5.0)
        let flip : CGFloat = -1.0
        let xCenter : CGFloat = startX + 0.5*w
        
        path.move(to: CGPoint(x:xCenter,y:r*flip+r))
        for k in 1...5 {
            let x = r*sin(CGFloat(k)*theta)
            let y = r*cos(CGFloat(k)*theta)
            path.addLine(to: CGPoint(x: x+xCenter, y: y*flip+r))
           
        }
        layer.path = path.cgPath
        layer.fillColor = starColor.cgColor
        layer.strokeColor = nil
        self.layer.addSublayer(layer)
    }
}
