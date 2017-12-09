//
//  CustomTabBarItem.swift
//  Pebl2
//
//  Created by Nick Florin on 2/11/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

// Delegate for Item to Communicate With Bar
protocol CustomTabBarItemDelegate: class {
    func itemSelected(customTabBarItem: CustomTabBarItem)
}

/////////////////////////////////////////////
// Custom Tab Bar Item for Tab Bar View
class CustomTabBarItem: UIView {
    
    //Mark: Properties
    var iconView: UIImageView!
    var image : UIImage!
    var button : UIButton!
    
    var label : UILabel!
    var labelText : String!
    var labelFont : UIFont = UIFont(name: "Roboto-Regular", size: 9.0)!
    
    // Don't know why frame position requires this to be subtracted to look right - but it does.
    var verticalPadding : CGFloat = 1.0
    
    var active : Bool = false
    var index : Int?
    
    var activeimageColor : UIColor = UIColorFromRGB(0x007AFF)
    var activelabelColor : UIColor = UIColorFromRGB(0x007AFF)
    
    var imageColor : UIColor = secondaryColor
    var labelColor : UIColor = secondaryColor

    var delegate : CustomTabBarItemDelegate!
    
    ////////////////////////////
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    ////////////////////////////
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    ////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Inactivate Tab Bar Selection
    func inactivate(){
        
        guard self.active == true else{
            return
        }
        // Set label and image colors to inactive
        let buttonImage = self.image.imageWithColor(color:imageColor)
        self.button.setImage(buttonImage, for: .normal)
        self.label.textColor = labelColor
        self.active = false
    }
    //////////////
    // Activate Tab Bar Selection
    func activate(){
        
        guard self.active == false else{
            return
        }
        // Set label and image colors to active
        let buttonImage = self.image.imageWithColor(color:activeimageColor)
        self.button.setImage(buttonImage, for: .normal)

        self.label.textColor = activelabelColor

        self.active = true
    }
    // Communicates Active State Selected to Controller via. Delegate
    func communicateToController(){
        // Tell Delegate This Item Was Selected
        self.delegate.itemSelected(customTabBarItem: self)
    }
    ////////////////////////////
    // Sets Up the UI Tab Bar Item
    func setup(image : UIImage,label:String) {
        
        // Add Button to Tab Bar Item
        self.image = image
        self.button = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.button.addTarget(self, action:#selector(CustomTabBarItem.communicateToController), for: .touchUpInside)
        
        // Set Default Button Image - Inactive Color by Default
        let buttonImage = self.image.imageWithColor(color:labelColor)
        self.button.setImage(buttonImage, for: .normal)
        
        self.button.imageView?.contentMode = .scaleAspectFit
        self.button.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: -2.0, right: 0.0)
        
        // Add Label to Item
        self.labelText = label
        self.label = UILabel(frame: CGRect.zero) // Initialize, readjust frame after
        self.label.text = self.labelText
        
        self.label.textColor = labelColor
        self.label.font = labelFont
        self.label.sizeToFit()
        self.label.textAlignment = .center
        
        let newButtonFrame = CGRect(x: self.button.frame.minX, y: self.button.frame.minY, width: self.button.frame.width, height: self.button.frame.height - 2.0*self.verticalPadding - self.label.frame.height)
        self.button.frame = newButtonFrame
        
        let labelFrame = CGRect(x: self.button.frame.minX, y: self.button.frame.maxY - self.verticalPadding, width: self.button.frame.width, height: self.label.frame.height)
        self.label.frame = labelFrame
        
        self.backgroundColor = UIColor.clear
        self.addSubview(self.label)
        self.addSubview(self.button)
        
    }
    
}
