//
//  UpDownButton.swift
//  Pebl2
//
//  Created by Nick Florin on 1/7/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

class UpDownButton: UIButton {

    var path : UIBezierPath!
    var backgroundC: UIColor = UIColor.clear
    var cornerRadius : CGFloat = 4.0
    
    var buttonColor : UIColor = light_blue
    var lineWidth : CGFloat = 2.5
    
    var orientationUp : Bool = false
    var upImage = UIImage(named:"UpArrow")
    var downImage = UIImage(named:"DownArrow")
    
    /////////////////////////////////////////
    /// Draw the Button
    override func draw(_ rect: CGRect) {
    
        self.clipsToBounds = false
        self.imageView?.contentMode = .scaleAspectFit
        self.applyImage()
    }
    /////////////////////////////////////////
    func applyImage(){
        if self.orientationUp{
            self.setImage(upImage, for: .normal)
        }
        else{
            self.setImage(downImage, for: .normal)
        }

    }
    /////////////////////////
    func flip(){
        if self.orientationUp{
            self.orientationUp = false
        }
        else{
            self.orientationUp = true
        }
        self.applyImage()
    }
}
