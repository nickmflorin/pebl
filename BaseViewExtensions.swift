//
//  Constants.swift
//  Pebl2
//
//  Created by Nick Florin on 12/25/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit


class CustomButtonClass: NSObject {
    
    class acceptButton : UIButton {
        override var isHighlighted: Bool {
            didSet {
                if (isHighlighted) {
                    self.backgroundColor = UIColor.blue
                } else {
                    self.backgroundColor = UIColor.white
                }
            }
        }
    }
    
}

////////////////////////////////////////////////////////////
// Styling of View Controller Views and Subviews

extension UIView {
    // Applying Background
    func applyBackground(){
        
        // Set Background Image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "BackgroundBWOriginal")
        self.insertSubview(backgroundImage, at: 0)
        
        // Add Blur Effect to Background Image
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.5
        self.insertSubview(blurEffectView, at: 1)
        
    }
    // Applying Secondary Background
    func applySubBackground(){
        
        // Set Background Image
        let backgroundImage = UIImageView(frame: self.bounds)
        backgroundImage.image = UIImage(named: "MenuSlideContentBackground")
        self.insertSubview(backgroundImage, at: 0)
    }
    // Styling of White Content View Background for Table Cells and General Views
    func tileStyle(){
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        self.layer.borderColor = secondaryColor.cgColor
        self.layer.borderWidth = 1.3
        self.layer.cornerRadius = 4.0
        
        self.layer.shadowColor = accentColor.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        self.layer.shadowRadius = 2
    }
    // Styling of White Content View Background for Event Tile
    func eventTileStyle(){
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        self.layer.borderColor = accentColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 2.0
        
        self.layer.shadowColor = accentColor.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        self.layer.shadowRadius = 2
    }
}

////////////////////////////////////////////////////////////
// Navbar Font and Styling
extension UINavigationController {
    
    func styleTitle(_ title:String){
        
        let nav_font_name = "SanFranciscoDisplay-Medium"
        let navFont = UIFont (name: nav_font_name, size:18)
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        self.navigationBar.barTintColor = light_blue
        self.navigationBar.topItem?.title = title
        self.navigationBar.titleTextAttributes = [ NSFontAttributeName: navFont!,  NSForegroundColorAttributeName: UIColor.white]
    }
    
}


////////////////////////////////////////////////////////////
// Menu Bar Button Styling
extension UIViewController {
    
    func styleMenu() {
        // Style Menu Icon //////////////
        let menu_image = UIImage(named: "MenuButtonRed")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let resized_image = menu_image.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0))
        
        let buttonFrame = CGRect(x: 0, y: 0, width: resized_image.size.width, height: resized_image.size.height)
        let button = UIButton(frame: buttonFrame);
        button.setTitle("", for: UIControlState());
        button.setBackgroundImage(resized_image, for: UIControlState());
        
        // Add Target to Button
        //button.addTarget(self, action: #selector(PeblHomeVC.menu_buttonToggle), for: .touchUpInside)
        
        // Create Left Bar Button Item and Spacer to Offset
        let menuButton = UIBarButtonItem(customView: button)
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = -7.0
        menuButton.target = self
        
        // Set Left Bar Button Item
        self.navigationItem.setLeftBarButtonItems([spacer,menuButton], animated: false)
    }
    
}
