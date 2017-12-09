//
//  SaveVC.swift
//  Pebl
//
//  Created by Nick Florin on 8/18/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//
import Foundation
import UIKit

class messageIndicator: UIView {
    
    let width = CGFloat(100.0)
    let height = CGFloat(100.0)

    let targetView : UIView!
    ///////////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///////////////////////////////////////////
    init(targetView : UIView) {
        
        self.targetView = targetView
        // X and Y Origin Points for Modal Progress
        let x = targetView.frame.origin.x
        let y = targetView.frame.origin.y
        
        // Set Initialization Frame - Positions Modal Below Screen (Not Visible)
        let xoffset = x+targetView.frame.width/2-self.width/2
        let yoffset = y+targetView.frame.height
        
        let frame = CGRect(x: xoffset, y: yoffset, width: self.width, height: self.height)
        
        super.init(frame: frame)
        /////////////////
        
        self.center = CGPoint(x: self.targetView.center.x, y: self.targetView.center.y+500.0)
        // Set Initial Center and Styling of Modal View
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Set Indicator In Center of Subview Modal Window
        self.layer.cornerRadius = 5.0
    }

    ///////////////////////////////////////////
    func animate_message(_ uiimage:UIImage,message:String){
        
        /////////////////
        // Set Msg Image for Indicator
        let image_view = UIImageView(image:uiimage)
        image_view.frame = CGRect(x: self.bounds.origin.x,y: self.bounds.origin.y,width:CGFloat(50),height:CGFloat(50))
        image_view.center = CGPoint(x: self.bounds.midX,y: self.bounds.midY-height/6)
        self.addSubview(image_view)

        /////////////////
        // Add Label to View
        let label = UILabel()
        label.text = message
        
        // Style Label
        label.textColor = UIColor.white
        label.font = slideup_font_medium
        label.textAlignment = NSTextAlignment.center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 3
        
        //Position Label Appropriately
        label.sizeToFit()
        label.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.width*0.8, height: self.height)
        label.center = CGPoint(x: self.bounds.midX,y: self.bounds.midY+height/4)

        self.addSubview(label)

        //Pop In
        UIView.animate(withDuration: Double(0.25), delay: Double(0.0), options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.center = self.targetView.center
            }, completion: {
                (finished: Bool) -> Void in
                // Pop Out
                UIView.animate(withDuration: Double(0.25), delay: Double(1.0), options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.center = CGPoint(x: self.center.x, y: self.center.y-500.0)
                    }, completion: {
                        (finished: Bool) -> Void in
                        
                        self.center = CGPoint(x: self.targetView.center.x, y: self.targetView.center.y+500.0)
                })
        })
    }
    ///////////////////////////////////////////
}
