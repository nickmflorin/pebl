//
//  EventSearchField.swift
//  Pebl2
//
//  Created by Nick Florin on 12/15/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

class EventSearchField: UIView {

    ///////////////////
    // MARK: Properties
    
    // Text Field
    var textField : UITextField!
    var textFieldHeight : CGFloat = 18.0
    var fieldDefaultText : String = "anything"
    
    var placeholderTextColor : UIColor = accentColor
    var textColor : UIColor = primaryTextColor
    
    let textFontName = "SanFranciscoDisplay-Regular"
    let textFieldFontSize : CGFloat = 14.0
    let horizontalLeftTextFieldOffset : CGFloat = 6.0
    
    // Distance Params
    var horizontalMargin : CGFloat = 5.0
    var verticalMargin : CGFloat = 5.0
    
    // Underline
    var linePath : UIBezierPath!
    var lineView : TextFieldUnderline!
    var lineColor : UIColor = secondaryColor
    var lineWidth : CGFloat = 1.0
    
    //////////////////////////////
    //// Init from Coder
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    //////////////////////////////
    // Init for Drawing Underlying
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        let lineWidth: CGFloat = 1.0
        context?.setLineWidth(1.0);
        
        linePath = UIBezierPath()
        linePath.lineWidth = lineWidth
        
        // Horizontal Line - Always Draw
        // Begining of Line Point
        linePath.move(to: CGPoint(
            x:horizontalMargin,
            y:self.bounds.height-verticalMargin))
        
        // End of Line Point
        linePath.addLine(to: CGPoint(
            x:bounds.width-horizontalMargin,
            y:self.bounds.height-verticalMargin))
        
        linePath.lineWidth = lineWidth
        lineColor.setStroke()
        linePath.stroke()
        
        self.setup(rect:rect)
    }
    //////////////////////////////
    // Sets the Text of the Text Field with Formatting Correctly
    func setText(textString:String){
        
        textField.text = textString
        textField.textColor = textColor
    }
    //////////////////////////////
    // Clears the Text Field
    func clear(){
        textField.text = self.fieldDefaultText
        textField.textColor = placeholderTextColor
    }
    //////////////////////////////
    /// Create the Custom Text Field
    func setup(rect:CGRect){
        
        // Create Text Field
        let textFont = UIFont (name: textFontName, size:textFieldFontSize)
        
        // Center Text Field Vertically with Image View
        let textFieldFrame = CGRect(x: rect.minX + horizontalMargin, y: rect.minY, width: rect.width - 2.0*horizontalMargin, height: rect.height)
        
        textField = UITextField(frame: textFieldFrame)
        textField.text = self.fieldDefaultText
        textField.font = textFont
        textField.textColor = placeholderTextColor
        textField.backgroundColor = UIColor.clear
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.contentVerticalAlignment = .center
        textField.clearsOnBeginEditing = true
        
        self.addSubview(textField)
    }

}
