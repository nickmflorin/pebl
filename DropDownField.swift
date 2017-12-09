//
//  StyledDropdownField.swift
//  Pebl2
//
//  Created by Nick Florin on 12/5/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

protocol DropDownFieldDelegate: class {
    func toggleMenu(sender: DropDownField)
}

////////////////////////////////////////////////////////////////////////////
class DropDownField: UIView, DropDownMenuDelegate{

    ///////////////////
    // MARK: Properties
    var verticalPadding : CGFloat = 6.0
    var horizontalPadding : CGFloat = 12.0
    
    // Image Properties
    var iconImage : UIImage!
    var imageWidth : CGFloat = 25.0
    var imageHeight : CGFloat = 25.0
    
    // Text Field and Underling
    let textFont = UIFont (name: "SanFranciscoDisplay-Regular", size:14)
    var textFieldHeight : CGFloat = 18.0
    var textColor : UIColor = secondaryColor
    
    // Text Field Underline
    var linePath : UIBezierPath!
    var lineWidth : CGFloat = 1.0
    var lineColor : UIColor = secondaryColor
    
    // Button Properties
    let buttonWidth : CGFloat = 10.0
    let buttonHeight : CGFloat = 8.0
    let dropImage = UIImage(named:"DropDownTriangle_BlueDown")
    let upImage = UIImage(named: "DropDownTriangle_BlueUp")
    
    // Object Properties
    var textField : UITextField!
    var imageView : UIImageView!
    var dropButton : UIButton!

    var lineView : TextFieldUnderline!
    var options : [String]?
    var dropDownMenu : DropDownMenu!
    var menuShowing : Bool = false
    
    weak var delegate: DropDownFieldDelegate?
    //////////////////////////////
    //// Init from Coder
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup(Viewframe:self.frame)
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
        
        self.setup(Viewframe: rect)
    }
    //////////////////////////////
    /// Add Subviews and then Add Programatic Constraints
    func setup(Viewframe:CGRect){
        
        self.backgroundColor = UIColor.clear
        
        // Create Image View for Icon //////////////////
        let imageViewFrame = CGRect(x: Viewframe.minX, y: Viewframe.minY, width: imageWidth, height: imageHeight)
        imageView = UIImageView(frame: imageViewFrame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.iconImage
        self.addSubview(imageView)
        
        // Create Button and Text Field
        self.createTextField(Viewframe: Viewframe)
        self.createButton(Viewframe:Viewframe)
        
        self.bringSubview(toFront: imageView)
        self.bringSubview(toFront: dropButton)
        
        // Add Constraints
        self.addConstraints()
    }
    ////////// Create Text Field //////////////////
    func createTextField(Viewframe:CGRect){
        
        let textFieldFrame = CGRect(x: imageView.frame.maxX+horizontalPadding, y: Viewframe.minY+2.0, width: Viewframe.width, height: 18.0)
        
        textField = UITextField(frame: textFieldFrame)
        
        textField.font = textFont
        textField.textColor = textColor
        textField.backgroundColor = UIColor.clear
        
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.contentVerticalAlignment = .center
        
        // Disable Text Field Manual Editing
        textField.isEnabled = false
        self.addSubview(textField)
        
        // Create Invisible View for Tap Gesture Recognizer of Text Field
        let dummyView = UIView(frame: textField.frame)
        dummyView.backgroundColor = UIColor.clear
        
        // Create a Touch Gesture for Dropping Menu When Touch Field Clicked
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DropDownField.toggleMenu))
        dummyView.addGestureRecognizer(tapGesture)

        self.addSubview(dummyView)
        self.bringSubview(toFront: dummyView)
    }
    ////////// Create Dropdown Button ///////////////////
    func createButton(Viewframe:CGRect){

        let buttonFrame = CGRect(x: Viewframe.maxX-buttonWidth, y: Viewframe.minY, width: buttonWidth, height: buttonHeight)
        
        dropButton = UIButton(type:UIButtonType.custom) as UIButton
        dropButton.frame = buttonFrame
        dropButton.backgroundColor = .clear
        
        dropButton.setImage(dropImage, for: .normal)
        //dropButton.imageEdgeInsets = UIEdgeInsetsMake(25,25,25,25)
        dropButton.addTarget(self, action: #selector(DropDownField.toggleMenu), for: .touchUpInside)
        
        self.addSubview(dropButton)
    }
    /////////////////////////////
    // Delegate Handler for Dropdown Menu
    internal func makeSelection(sender: DropDownMenu) {
        textField.text = ""
        textField.text = sender.currentSelection
    }
    ////////////////////////////
    internal func flipButtonDown(sender: DropDownMenu) {
        dropButton.setImage(dropImage, for: .normal)
    }
    ////////////////////////////
    internal func flipButtonUp(sender: DropDownMenu) {
        dropButton.setImage(upImage, for: .normal)
    }
    ////////////////////////////
    func toggleMenu(){
        self.delegate?.toggleMenu(sender: self)
    }
    /////////////////////////////
    // Adding Positioning Constraints Programatically
    func addConstraints(){
        let yConstraint = NSLayoutConstraint(item: textField, attribute: .centerY, relatedBy: .equal, toItem:imageView, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yConstraint)
    }
    /////////////////////////////
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController!) -> UIModalPresentationStyle {
        return .none
    }

}
