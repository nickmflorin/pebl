//
//  PeblModalHeader.swift
//  Pebl2
//
//  Created by Nick Florin on 12/25/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit


protocol PeblModalHeaderDelegate: class {
    func close(sender: PeblModalHeader)
}

///////////////////////////////////////////////////////////////////////////////////////////////
class PeblModalHeader: UIView {
    
    // Mark: Properties
    var horizontalMargin : CGFloat = 8.0
    var headerBackgroundColor : UIColor = UIColor.clear
    
    // Label Properties
    var leftLabel : UILabel!
    var leftLabelFrame : CGRect!
    var leftLabelText : String!
    
    var leftLabelColor : UIColor = UIColor.white
    var leftLabelFont = UIFont (name: "SanFranciscoDisplay-Medium", size:16)
    
    // Button Properties
    var closeButton : CloseButton!
    var closeButtonFrame : CGRect!
    var buttonVerticalPadding : CGFloat = 7.0
    
    weak var delegate: PeblModalHeaderDelegate?
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = headerBackgroundColor
    }
    /////////////////////////////////////
    // Close Button in Top Right Clicked
    func closeButtonClicked(){
        // Call Delegate to Close
        self.delegate?.close(sender:self)
    }
    /////////////////////////////////////
    // Creates Labels and Buttons that Go in Header
    func setup(){
        
        if leftLabelText != nil{
            
//            // Create Label - Width Will Be Reset on Size to Fit
//            leftLabelFrame = CGRect(x: self.bounds.minX + horizontalMargin, y: self.bounds.minY, width: self.bounds.width/5.0, height: self.bounds.height)
//            leftLabel = UILabel(frame: leftLabelFrame)
//            
//            leftLabel.text = leftLabelText
//            leftLabel.font = leftLabelFont
//            leftLabel.textColor = leftLabelColor
//            
//            leftLabel.sizeToFit()
//            
//            // Recenter Label Vertically
//            let labelVerticalInset = 0.5*(self.bounds.height - leftLabel.frame.height)
//            leftLabelFrame = CGRect(x: leftLabel.frame.minX, y: labelVerticalInset, width: leftLabel.frame.width, height: leftLabel.frame.height)
//            leftLabel.frame = leftLabelFrame
//            
//            self.addSubview(leftLabel)
            
            // Create Close Button from Custom Graphic
            let buttonWidth = self.bounds.height - 2.0*buttonVerticalPadding
            closeButtonFrame = CGRect(x: self.bounds.maxX - buttonWidth + 3.0, y: self.bounds.minY+buttonVerticalPadding, width: buttonWidth, height:buttonWidth)
            closeButton = CloseButton(frame: closeButtonFrame)

            closeButton.addTarget(self, action: #selector(PeblModalHeader.closeButtonClicked), for: .touchUpInside)
            
            self.addSubview(closeButton)
            
        }
    }
    /////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
