//
//  StatusCircle.swift
//  Pebl
//
//  Created by Nick Florin on 10/26/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

class StatusCircle: UIView {
    
    var path : UIBezierPath?
    var isNew : Bool = false
    
    //////////////////////////////
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        path = UIBezierPath(ovalIn: rect)
        // Drawing Code
        if isNew{
            indicateNew(context!, boundedBy: rect)
        }
        else{
            indicateOld(context!, boundedBy: rect)
        }
    }
    //////////////////////////////
    func indicateNew(_ context: CGContext, boundedBy rect: CGRect){
        
        let innerRect = rect.insetBy(dx: 2.0, dy: 2.0)
        
        path = UIBezierPath(ovalIn: rect)
        UIColor.white.setFill()
        path?.fill()
        
        let path2 = UIBezierPath(ovalIn: innerRect)
        green.setFill()
        path2.fill()
        
        //context.setFillColor(green.cgColor)
        //context.fillPath()

    }
    //////////////////////////////
    func indicateOld(_ context: CGContext, boundedBy rect: CGRect){
        path = UIBezierPath(ovalIn: rect)
        light_gray.setFill()
        path?.fill()
        
        context.setFillColor(green.cgColor)
        context.fillPath()
    }
}
