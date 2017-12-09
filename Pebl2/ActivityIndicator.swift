//
//  ActivityIndicator.swift
//  Pebl
//
//  Created by Nick Florin on 8/10/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//
import Foundation
import UIKit

class loadingIndicator: UIView {
    
    ///////////////////////////////////////////
    // MARK - Variables
    var width = CGFloat(200.0)
    var height = CGFloat(60.0)
    var isAnimating : Bool = false
    var indicator : UIActivityIndicatorView
    
    ///////////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///////////////////////////////////////////
    init(targetView : UIView) {
        
        // X and Y Origin Points for Modal Progress
        let x = targetView.frame.origin.x
        let y = targetView.frame.origin.y
        
        // Set Initialization Frame
        let frame = CGRect(x: x, y: y, width: width, height: height)
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        super.init(frame: frame)
        /////////////////
        
        // Set Initial Center and Styling of Modal View
        self.center = targetView.center
        self.backgroundColor = UIColor.black
        self.alpha = 0.0
        
        // Set Indicator In Center of Subview Modal Window
        self.layer.cornerRadius = 5.0
        indicator.frame.origin.x = x
        indicator.frame.origin.y = y
        indicator.center = CGPoint(x: frame.midX-self.width/3,y: frame.midY)
        self.addSubview(indicator)
    }


    ///////////////////////////////////////////
    func startSpinning (_ message:String) {
        
        // Add Label to View
        let label = UILabel()
        label.text = message
        
        
        // Style Label
        label.textColor = UIColor.white
        label.font = slideup_font_medium
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 3
        
        //Position Label Appropriately
        label.sizeToFit()
        label.frame = CGRect(x: indicator.frame.maxX+5.0, y: indicator.frame.midY-self.height/2, width: self.width/1.6, height: self.height)
        //label.center = CGPoint(x: indicator.frame.midX+self.width/5,y: indicator.frame.midY-self.height/4)
        
        self.addSubview(label)
        
        if isAnimating {
            return
        }
        
        indicator.startAnimating()
        isAnimating = true
        UIView.setAnimationDuration(2.5)
        self.alpha = 0.8
        UIView.commitAnimations()
    }
    ///////////////////////////////////////////
    func stopSpinning () {
        
        if isAnimating == false {
            return
        }
        isAnimating = false
        indicator.stopAnimating()
        isAnimating = true
        self.alpha = 0.0
    }
    
}

