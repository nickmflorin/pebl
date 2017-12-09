//
//  StyledInputField.swift
//  Pebl2
//
//  Created by Nick Florin on 11/24/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

class StyledInputField: UIView {

    ///////////////////
    // MARK: Properties
    var linePath : UIBezierPath!
    var iconImage : UIImage!
    var fieldDefaultText : String!
    var lineColor : UIColor = secondaryColor
    var textColor : UIColor = secondaryColor
    let textFontName = "SanFranciscoDisplay-Regular"
    let textFieldFontSize : CGFloat = 14.0
    
    var textField : UITextField!
    var imageView : UIImageView!
    
    var verticalPadding : CGFloat = 6.0
    var horizontalPadding : CGFloat = 12.0
    
    var imageWidth : CGFloat = 25.0
    var imageHeight : CGFloat = 25.0
    var lineWidth : CGFloat = 1.0
    var textFieldHeight : CGFloat = 18.0
    
    var lineView : TextFieldUnderline!

    //////////////////////////////
    //// Init from Coder
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
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
            x:0.0,
            y:imageView.frame.height+verticalPadding))
        
        // End of Line Point
        linePath.addLine(to: CGPoint(
            x:bounds.width,
            y:imageView.frame.height+verticalPadding))
        
        linePath.lineWidth = lineWidth
        lineColor.setStroke()
        linePath.stroke()
    }
    //////////////////////////////
    /// Add Subviews and then Add Programatic Constraints
    func setup(){

        // Create Image View for Icon
        let imageViewFrame = CGRect(x: self.frame.minX, y: self.frame.minY, width: imageWidth, height: imageHeight)
        imageView = UIImageView(frame: imageViewFrame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.iconImage
        self.addSubview(imageView)
        
        // Create Text Field
        let textFont = UIFont (name: textFontName, size:textFieldFontSize)
        
        let textFieldFrame = CGRect(x: imageViewFrame.maxX+horizontalPadding, y: self.frame.minY+2.0, width: self.frame.width, height: 18.0)
        
        textField = UITextField(frame: textFieldFrame)
        textField.text = self.fieldDefaultText
        textField.font = textFont
        textField.textColor = textColor
        textField.backgroundColor = UIColor.clear
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.contentVerticalAlignment = .center
        textField.clearsOnBeginEditing = true
    
        self.addSubview(textField)
        
        // Add Constraints
        self.addConstraints()
    }
    /////////////////////////////
    // Adding Positioning Constraints Programatically
    func addConstraints(){
        let yConstraint = NSLayoutConstraint(item: textField, attribute: .centerY, relatedBy: .equal, toItem:imageView, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yConstraint)
        
    }
}
