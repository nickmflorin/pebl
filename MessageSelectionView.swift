//
//  MessageSelectionView.swift
//  Pebl2
//
//  Created by Nick Florin on 1/25/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

// Initialized and created programatically
class MessageSelectionView: UIView {
    
    var textField : UITextField!
    var horizontalMargin : CGFloat = 25.0
    var verticalMargin : CGFloat = 5.0
    
    var placeHolderText : String = "Help your friends understand"
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        textField = UITextField(frame: CGRect(x: self.horizontalMargin, y: self.verticalMargin, width: self.frame.width - 2.0*self.horizontalMargin, height: self.frame.height - 2.0*self.verticalMargin))
        
        textField.placeholder = placeHolderText
        textField.textColor = secondaryColor
        textField.font = UIFont(name: "SanFrancisco-Display", size: 14.0)
        
        self.addSubview(textField)
        
    }
    // Coder Init for Storyboard
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //////////////////////////////
    // Init for Drawing Underlying
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
    }
    
    //////////////////////////////
    // Mark: Actions
    @IBAction func finishButtonClicked(_ sender: AnyObject) {
        // Send notification that cancel button was clicked from time select view
        guard let message = self.textField.text else {
            print("Cannot Submit Message - Missing Message String")
            return
        }
        
        let dataDict = ["sender":self,"selectedMessage":message] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "finishButtonClicked"), object:dataDict)
    }
    
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
        // Send notification that cancel button was clicked from time select view
        let dataDict = ["sender":self]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancelButtonClicked"), object:dataDict)
    }
}
