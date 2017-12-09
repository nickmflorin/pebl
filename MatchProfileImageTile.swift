//
//  MatchProfileImageTile.swift
//  Pebl2
//
//  Created by Nick Florin on 12/12/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

protocol MatchProfileImageTileDelegate: class {
    func showProfile(sender: MatchProfileImageTile)
}

////////////////////////////////////////////////////////////////////////////
class MatchProfileImageTile: UIView {
    
    ///////////////////
    // MARK: Properties
    
    // Image View Parameters ///////
    var profileImage : UIImage?
    var profileImageButton : UIButton!
    
    var profileImageButtonFrame : CGRect!
    var imageCornerRadius : CGFloat = 4.0
    var imageOverlapStatusCirclePct : CGFloat = 0.25 // Portion of Status Circle that Image View Overlaps
    var imagePathOffset : CGFloat = 0.4 // Distance Between Path Outline and Edge of Image View
    var bottomRightImagePadding : CGFloat = 2.0 //Padding Between Image and Right/Bottom Portions of View
    
    // Status Circle Parameters ///////
    var circleLayer: CAShapeLayer!
    
    var statusCircleCenter : CGPoint!
    var statusCircleDiameter : CGFloat = 14.0
    var statusCircleRadius : CGFloat!
    var statusCircleColor : UIColor = green
    var statusCirclePath : UIBezierPath?
    var innerStatusCirclePath : UIBezierPath?
    
    // Expiration Bar Parameters ///////
    let expirationLineColor : UIColor = light_blue
    let expirationLineWidth : CGFloat = 4.0
    var pathRadius : CGFloat = 3.5
    
    var expirationBarPath : UIBezierPath!
    var currentPoint : CGPoint! // Current Point in Path
    
    // Active is Default
    var active : Bool = true
    var percentExpired : CGFloat = 0.8
    
    weak var delegate: MatchProfileImageTileDelegate?
    //////////////////////////////
    //// Init from Coder
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = false
    }
    //////////////////////////////////
    // Wait for Layout Subviews Before Creating Label
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Center of Status Circle
        statusCircleRadius = 0.5*self.statusCircleDiameter
        statusCircleCenter = CGPoint(x: self.bounds.minX - 0.25*statusCircleRadius,y : self.bounds.minY - 0.25*statusCircleRadius)
        
        // Set Image Frame
        profileImageButtonFrame = self.bounds.insetBy(dx: 3.0, dy: 3.0)
        if self.profileImage == nil{
            self.profileImage = UIImage(named:"MissingPhotoImage")
            self.createImageButton(image:self.profileImage!)
        }
        else{
            self.createImageButton(image:self.profileImage!)
        }
        
        self.drawStatusCircle()
    }
    /////////////////////////////
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.drawExpirationBorder()
    }
    //////////////////////////////
    func createImageButton(image:UIImage){
        
        profileImageButton = UIButton(frame: profileImageButtonFrame)
        profileImageButton.setImage(profileImage, for: .normal)
        profileImageButton.contentMode = .scaleAspectFill
        
        profileImageButton.layer.cornerRadius = 0.5*profileImageButton.frame.width
        profileImageButton.layer.masksToBounds = true
        profileImageButton.addTarget(self, action: #selector(self.profileImageClicked), for: .touchUpInside)
        
        self.addSubview(profileImageButton)
        self.bringSubview(toFront: profileImageButton)
    }
    // Button Handler for When Profile Image Clicked
    func profileImageClicked(){
        self.delegate?.showProfile(sender: self)
    }
    //////////////////////////////
    // Init for Drawing Underlying
    func drawStatusCircle(){
        // Draw Status Circle
        if self.active {
            
            circleLayer = CAShapeLayer()
            
            let circleX = self.bounds.minX
            let circleY = self.bounds.minY
            let circleRect = CGRect(x:circleX, y:circleY, width:self.statusCircleDiameter, height:self.statusCircleDiameter)
            let path = UIBezierPath(ovalIn: circleRect)
            
            circleLayer.path = path.cgPath
            circleLayer.strokeColor = UIColor.white.cgColor
            circleLayer.fillColor = statusCircleColor.cgColor
            
            circleLayer.borderColor = UIColor.white.cgColor
            circleLayer.borderWidth = 4.0
            self.layer.addSublayer(circleLayer)
        }
    }
    //////////////////////////////
    // Draws Border Around Image
    func drawExpirationBorder(){
        
        // Starting Point Immediately After Arc in Top Left
        let arcCenter : CGPoint = CGPoint(x:self.profileImageButton.frame.midX,y:self.profileImageButton.frame.midY)

        let startingAngle : CGFloat = -0.25 * CGFloat(M_PI)
        let radialAngle : CGFloat = self.percentExpired*2.0*CGFloat(M_PI)
        let endingAngle : CGFloat = startingAngle+radialAngle
        
        // Draw Full Arc
        let trackPath = UIBezierPath(arcCenter: arcCenter, radius: 0.5*self.profileImageButton.frame.width, startAngle: startingAngle, endAngle: endingAngle,clockwise: true)
        trackPath.lineWidth = expirationLineWidth
        expirationLineColor.setStroke()
        trackPath.stroke()

        
    }
}
