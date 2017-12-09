//
//  UIElementExtensions.swift
//  Pebl2
//
//  Created by Nick Florin on 12/25/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit


class ExpandableTextField: UITextField {
    
    /// Set Insets
    var insetAmount : CGFloat = 5.0
    
    ////////////////////////////
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + insetAmount, y: bounds.origin.y + insetAmount, width: bounds.width - 2.0*insetAmount, height: bounds.height - 2.0*insetAmount)
    }
    ////////////////////////////
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + insetAmount, y: bounds.origin.y + insetAmount, width: bounds.width - 2.0*insetAmount, height: bounds.height - 2.0*insetAmount)
    }
    ////////////////////////////
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + insetAmount, y: bounds.origin.y + insetAmount, width: bounds.width - 2.0*insetAmount, height: bounds.height - 2.0*insetAmount)
    }
    
}

////////////////////////////////////////////////////////////
extension UIButton {
    
    ////////////////////////////
    func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    /////////////////////////
    func defaultBlueStyle(_ title:String){
        
        let button_font_name = "SanFranciscoDisplay-Light"
        let buttonFont = UIFont (name: button_font_name, size:11)
        
        self.setTitle(title,for: UIControlState.normal)
        self.setBackgroundColor(light_blue, forState: UIControlState.normal)
        
        self.titleLabel?.font = buttonFont
        self.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
}

////////////////////////////////////////////////////////////
extension UILabel {
    
    /////////////////////////
    func style(){
        
        self.textColor = dark_blue
        self.font = label_font
    }
    
}
////////////////////////////////////////////////////////////
extension UITextField {
    
    /////////////////////////
    func style(){
        
        self.textColor = dark_blue
        self.layer.borderWidth = 1.0
        self.layer.borderColor = dark_blue.cgColor
        self.layer.cornerRadius = 2.0
        self.backgroundColor = UIColor.white
    }
    /////////////////////////
    // Insets the Text of a UITextField and Makes it so Text Field Can Expand
    func insetTextLeft(insetAmount:CGFloat){
        
        let paddingView = UIView(frame: CGRect(x:0, y:0, width:insetAmount, height:self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
      
    }
    
}


////////////////////////////////////////////////////////////
extension UITextView {
    
    /////////////////////////
    func style(){
        
        self.textColor = dark_blue
        self.layer.borderWidth = 1.0
        self.layer.borderColor = dark_blue.cgColor
        self.layer.cornerRadius = 2.0
        self.backgroundColor = UIColor.white
    }
    
}

////////////////////////////////////////////////////////////
func create_tab_bar_icon(_ tab_image:UIImage) -> UIImage {
    
    let size = CGSize(width: tab_image.size.width, height: tab_image.size.height)
    
    var scaledImageRect = CGRect.zero;
    scaledImageRect.size.width = size.width;
    scaledImageRect.size.height = size.height+5.0;
    scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
    scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    
    tab_image.draw(in: CGRect(origin: CGPoint.zero, size: size))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    let rendered_scaledImage = scaledImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    UIGraphicsEndImageContext();
    
    return rendered_scaledImage!
}

