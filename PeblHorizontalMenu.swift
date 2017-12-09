//
//  PeblHorizontalMenu.swift
//  Pebl2
//
//  Created by Nick Florin on 1/2/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

/////////////////////////////////////////////////////////////////////
// Delegate for Menu to Communicate to Page View Controller to Change Pages to New Index
protocol PeblHorizontalMenuDelegate: class {
    func moveToPageIndex(sender: PeblHorizontalMenu, index:Int, completionHandler: @escaping (Bool)->())
}

//////////////////////////////////////////////////////////////////////////
class PeblHorizontalMenu: UIView, PeblHomeVCDelegate {

    // Mark: Properties
    var menuBackgroundColor : UIColor = secondaryColor.withAlphaComponent(0.6)
    var horizontalPadding : CGFloat = 20.0
    var labelVerticalPadding : CGFloat = 9.0 // The Amount by Which Label Will be Vertically Offset from Top
                                            // to Make Room for White Underlying
    
    var menuTitles : [String] = []
    var menuTitleFont = UIFont (name: "SanFranciscoDisplay-Medium", size:12)
    var menuTitleColor = UIColor.white
    
    var menuLabels : [UILabel] = []
    var menuLabelFrames : [CGRect] = []
    var menuLabelDividingFrames : [CGRect] = []
    
    var underlineLayers : [CAShapeLayer] = []
    
    var underlineActiveColor : UIColor = UIColor.white
    var underlineInactiveColor : UIColor = secondaryColor
    
    var underlineHorizontalInset : CGFloat = 0.0
    var underlineLineWidth : CGFloat = 3.0
    var underlineVerticalPadding : CGFloat = 8.0 // Space Between Label Frame and Line Center
    
    // Dictionaries to Keep Track of Index for Label Text
    var indexByText = NSMutableDictionary()
    var delegate : PeblHorizontalMenuDelegate?
    var activeIndex : Int!
    
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = menuBackgroundColor
    }
    /////////////////////////////
    // Adds View Controller Page to Menu Control
    internal func addPage(sender: PeblHomeVC, peblPage: PeblPage) {
        self.menuTitles.append(peblPage.title)
        // Set Index Lookup by Pebl Page Title
        indexByText.setValue(peblPage.index, forKey: peblPage.title)
    }
    /////////////////////////////
    // Handler for Label Click
    func labelClicked(_ sender: UITapGestureRecognizer){
        
        let ptInFrame = sender.location(in: self)
        var correspondingText : String?
        print("Clicked Point in Frame : \(ptInFrame)")
        
        // Find Label That Touch Corresponds To
        for label in self.menuLabels{
            print("Frame Option : \(label.frame)")
            if label.frame.contains(ptInFrame){
                print("Frame Option Contains Point")
                correspondingText = label.text
            }
        }
        // To do: This should never happen but it occasionally does.  Need to figure out why.
        if correspondingText == nil{
            print("Couldn't Associate Point in Frame With Label Frame")
            return
        }
        
        let index = self.indexByText.value(forKey: correspondingText!) as! Int
        self.activeIndex = index
        
        // Communicate to Delegate to Move to New Page at Index
        self.delegate?.moveToPageIndex(sender: self, index: index, completionHandler: {(complete) in
            if complete{
                self.activateUnderline()
                return
            }
        })
    }
    /////////////////////////////////////
    // Removes Highlighting from All Other Labels and Underlines Active
    func activateUnderline(){
        // Remove White Underlyings for All Underlines
        for underline in self.underlineLayers{
            underline.fillColor = self.underlineInactiveColor.cgColor
            underline.strokeColor = self.underlineInactiveColor.cgColor
        }
        // Underline the Corresponding Layer White
        self.underlineLayers[self.activeIndex].fillColor=self.underlineActiveColor.cgColor
        self.underlineLayers[self.activeIndex].strokeColor=self.underlineActiveColor.cgColor
    }
    /////////////////////////////////////
    // Called After All Pages Added to Menu Control
    func setup(){
        
        // BreakUp Horizontal Length Depending on Number of Labels
        let numLabels = self.menuTitles.count
        let widthPerLabel = self.bounds.width/CGFloat(numLabels)
        
        for i in 0...numLabels-1{
            let startingX = self.bounds.minX + CGFloat(i)*widthPerLabel
            let dividedRect = CGRect(x: startingX, y: self.bounds.minY, width: widthPerLabel, height: self.bounds.height)
            self.menuLabelDividingFrames.append(dividedRect)
        }
        
        // Create Labels and Position Correctly, Attach Gestures to Labels
        self.createLabels()
        self.initializeUnderline()
        
        // Add Labels to View
        for label in self.menuLabels{
            self.addSubview(label)
        }
        // Highlight Active
        self.activateUnderline()
    }
    /////////////////////////////////////
    // Creates Labels from Menu Titles
    func createLabels(){
        
        // Create Labels
        for menuTitle in self.menuTitles{
            
            // Create Label for Each Menu - Initialize with CGRect Zero Frame - Will be Updated
            let newLabel = UILabel(frame: CGRect.zero)
            newLabel.font = menuTitleFont
            newLabel.textColor = menuTitleColor
            
            newLabel.textAlignment = .center
            newLabel.text = menuTitle
            
            // Size to Fit and Update Size
            newLabel.sizeToFit()
            self.menuLabels.append(newLabel)
        }
        
        // Loops Over All Labels and Adjusts the Frames to Center Correctly
        // Position Each Label in Center of Divided Rect Regions
        for i in 0...self.menuLabels.count-1{
            
            let labelW = self.menuLabels[i].frame.width
            let labelX = self.menuLabelDividingFrames[i].midX - 0.5*labelW
            let labelY = self.bounds.minY + labelVerticalPadding
            
            self.menuLabels[i].frame = CGRect(x: labelX, y: labelY, width: labelW, height: self.menuLabels[i].frame.height)
            
            // Attach Gesture to Each Label (Note: using the label's sized to fit frame, not the divided frame)
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PeblHorizontalMenu.labelClicked))
            
            // Create a Touch Gesture for Dropping Menu When Touch Field Clicked
            let dummyView = UIView(frame: self.menuLabels[i].frame.insetBy(dx: -3.0, dy: -3.0))
            dummyView.backgroundColor = UIColor.clear
            dummyView.addGestureRecognizer(tapGesture)
            
            self.addSubview(dummyView)
            self.bringSubview(toFront: dummyView)
        }
    }
    /////////////////////////////////////
    // Creates Underlines Based on Frames of Labels and Draws Lines but Keeps Paths Not Visible
    // Until Menu Label is Active
    func initializeUnderline(){
        
        for label in self.menuLabels{
            
            let newLinePath = UIBezierPath()
            let newLine = CAShapeLayer()
         
            // Horizontal Line - Begining of Line Point
            newLinePath.move(to: CGPoint(x:label.frame.minX+underlineHorizontalInset,y:label.frame.maxY+underlineVerticalPadding))
            // End of Line Point
            newLinePath.addLine(to: CGPoint(x:label.frame.maxX-underlineHorizontalInset,y:label.frame.maxY+underlineVerticalPadding))

            // Attribute Line to Layer
            newLine.lineWidth = self.underlineLineWidth
            newLine.path = newLinePath.cgPath
            
            newLine.fillColor = self.underlineInactiveColor.cgColor
            newLine.strokeColor = self.underlineInactiveColor.cgColor
            
            self.layer.addSublayer(newLine)
            self.underlineLayers.append(newLine)
        }
    }
    /////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
