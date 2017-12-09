//
//  DropDownMenu.swift
//  Pebl2
//
//  Created by Nick Florin on 12/5/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

protocol DropDownCellDelegate: class {
    func selectCell(selectedCell: DropDownCell)
}
/////////////////////////////////////
class DropDownCell : UIView {
    
    var xLabelMargin : CGFloat = 8.0
    
    var circleLineWidth : CGFloat = 4.0
    var circleOutlineColor : UIColor = light_blue
    var circleLayer: CAShapeLayer!
    var circleFillColor : UIColor = light_blue
    var circleUnFillColor : UIColor = UIColor.clear
    
    var cellBackgroundColor = UIColor.white.withAlphaComponent(0.7)
    var cellBorderColor = secondaryColor
    var horizontalPadding : CGFloat = 9.0
    var verticalPadding : CGFloat = 9.0
    
    var optionText : String?
    var index : Int?
    let labelFont = UIFont (name: "SanFranciscoDisplay-Light", size:12)
    var label: UILabel!
    
    var selected : Bool = false
    weak var delegate: DropDownCellDelegate?
    //////////////////////////////
    //// Init from Coder
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true

    }
    /////////////////////////////////////
    // Denotes Cell as Selected and Performs Associated Actions
    func setAsSelected(_ sender: UITapGestureRecognizer){

        self.selected = true
        if circleLayer != nil{
            circleLayer.fillColor = circleFillColor.cgColor
        }
        print("Selection at Index : \(self.index)")
        // Tell Dropdown Menu to Select Cell
        delegate?.selectCell(selectedCell: self)
    
    }
    /////////////////////////////////////
    // Denotes Cell as Not Selected and Performs Associated Actions
    func deselect(){
        self.selected = false
        if circleLayer != nil{
            circleLayer.fillColor = circleUnFillColor.cgColor
        }
    }
    /////////////////////////////////////
    func setupView(Viewframe:CGRect) {
        
        self.frame = Viewframe
        
        // Setup View
        self.backgroundColor = cellBackgroundColor.withAlphaComponent(0.2)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = cellBorderColor.cgColor
        self.layer.cornerRadius = 2.0
        self.layer.masksToBounds = true
        
        self.drawSelectionIndicator()
        label = UILabel()
        self.createLabel(Viewframe:Viewframe)
        self.createTapGesture()
    }
    /////////////////////////////////////
    func createLabel(Viewframe:CGRect){
        
        label.frame = CGRect(x:xLabelMargin, y:0, width:Viewframe.size.width, height:Viewframe.size.height)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        label.text = optionText
        label.textColor = secondaryColor
        label.font = labelFont

        self.addSubview(label)
    }
    ////////////////////////////////////
    // Creates Gesture Recognizer to Select Cell
    func createTapGesture(){
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DropDownCell.setAsSelected))
        self.addGestureRecognizer(tapGesture)
    }
    /////////////////////////////////////
    // Draws Circular Selection Indicator
    func drawSelectionIndicator(){
        
        circleLayer = CAShapeLayer()
        
        let circleHeight = self.bounds.size.height - 2.0*(self.verticalPadding)
        let circleRect = CGRect(x:bounds.size.width - circleHeight - self.horizontalPadding, y:self.verticalPadding, width:circleHeight, height:circleHeight)
        let path = UIBezierPath(ovalIn: circleRect)
        
        circleLayer.path = path.cgPath
        circleLayer.strokeColor = circleOutlineColor.cgColor
        circleLayer.fillColor = circleUnFillColor.cgColor
        
        circleLayer.borderColor = circleOutlineColor.cgColor
        circleLayer.borderWidth = circleLineWidth
        self.layer.addSublayer(circleLayer)

      
    }
}


