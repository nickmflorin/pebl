//
//  ExpandingTextView.swift
//  Pebl2
//
//  Created by Nick Florin on 12/26/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

class ExpandingTextView: UITextView, UITextViewDelegate {
    
    var backgroundC: UIColor = UIColor.white
    var borderWidth : CGFloat = 1.0
    var borderC : UIColor = accentColor
    var cornerRadius : CGFloat = 2.0
    
    var placeHolderText : String = "Accept Pebl"
    var textFont = UIFont (name: "SanFranciscoDisplay-Light", size:12)
    var textC : UIColor = primaryTextColor
    
    var topBottomHeight : CGFloat!
    var firstLineHeight : CGFloat!
    var currentHeight : CGFloat!
    var singleLineHeight : CGFloat!
    var prevRect : CGRect = CGRect.zero
    
    var numLines : Int = 1
    var maxLines : Int = 4
    /////////////////////////////////////
    override init(frame: CGRect, textContainer: NSTextContainer?){
        super.init(frame: frame, textContainer:textContainer)
        
        // Text View Properties
        self.isScrollEnabled = false
        self.textContainer.lineBreakMode = .byWordWrapping
        self.contentInset = UIEdgeInsets.zero
        
        // Set Delegate to self to Detect Changes in This View
        self.delegate = self
        
        // Styling
        self.backgroundColor = backgroundC
        self.textContainerInset = UIEdgeInsetsMake(6, 2, 6, 2)
        
        // Layer Properties
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderC.cgColor

        // Font and Text Color
        self.font = textFont
        self.textColor = textC
  
        topBottomHeight = self.textContainerInset.top + self.textContainerInset.bottom
        singleLineHeight = (textFont?.lineHeight)!
        currentHeight = (textFont?.lineHeight)! + topBottomHeight
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: currentHeight)
    }
    /////////////////////////////////////
    // Handler for When Text Field Text Changes
    func textViewDidChange(_ textView: UITextView){
        
        // Don't Exceed Max Number of Lines
        if numLines == maxLines {
            return
        }
        
        // Determine Position and Frame of Current Char
        let pos = self.endOfDocument
        var currentRect = self.caretRect(for: pos)
        
        // Compare Y Origins of Frames - Avoid Case of Expanding when First Text Entered with prevRect.origin.y != 0.0
        if currentRect.origin.y > prevRect.origin.y{
        
            if prevRect.origin.y == 0.0{
                numLines = 1
            }
            else{
                numLines = numLines + 1
                currentHeight = currentHeight + singleLineHeight
            }
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: currentHeight)
        }
        else if currentRect.origin.y == -1.0{
            let oldRect = currentRect
            currentRect = CGRect(x: oldRect.origin.x, y: singleLineHeight, width: oldRect.width, height: oldRect.height)
            currentHeight = currentHeight + singleLineHeight
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: currentHeight)
        }
//        else if currentRect.origin.y < prevRect.origin.y{
//            // Decreases Size of Text View by Line
//            numLines = numLines - 1
//            currentHeight = CGFloat(numLines) * singleLineHeight
//            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: currentHeight)
//            print("Decreasing Size to Num Lines : \(numLines) and Current Height : \(currentHeight) and Frame : \(frame)")
//        }
        prevRect = currentRect
    }
    /////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
