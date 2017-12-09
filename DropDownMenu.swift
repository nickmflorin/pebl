//
//  DropDownMenu.swift
//  Pebl2
//
//  Created by Nick Florin on 12/11/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

protocol DropDownMenuDelegate: class {
    func makeSelection(sender: DropDownMenu)
    func flipButtonDown(sender:DropDownMenu)
    func flipButtonUp(sender:DropDownMenu)
}

///////////////////////////////////////////////////////////////
class DropDownMenu: UIView, DropDownCellDelegate, DropDownFieldDelegate{
    
    //////////////////////////////////////////////
    // MARK: Properties
    var verticalSpacing : CGFloat = 5.0
    var cellLeftOffset : CGFloat!
    
    // Selection Tracking
    var cells : [DropDownCell] = []
    var currentSelectedIndex : Int?
    var currentSelectedCell : DropDownCell?
    var currentSelection : String?
    
    var options : [String] = []
    var menuShowing : Bool = false
    weak var delegate: DropDownMenuDelegate?
    
    //////////////////////////////
    //// Init from Coder
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    /////////////////////////////
    // Toggles Show or Hide State of Menu
    internal func toggleMenu(sender: DropDownField){
        if menuShowing == false{
            self.showMenu()
            self.menuShowing = true
        }
        else{
            self.hideMenu()
            self.menuShowing = false
        }
    }
    /////////////////////////////
    // Shows Dropdown Menu Selections
    func showMenu(){
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveEaseOut], animations: {
            self.alpha = 1.0
            // Change Dropdown Button Arrow to Up
            self.delegate?.flipButtonUp(sender:self)
            }, completion: nil)
    }
    /////////////////////////////
    // Hides Dropdown Menu Selections
    func hideMenu(){
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveEaseOut], animations: {
            self.alpha = 0.0
            // Change Dropdown Button Arrow to Up
            self.delegate?.flipButtonDown(sender:self)
        }, completion: nil)
    }
    //////////////////////////////
    /// Add Subviews and then Add Programatic Constraints
    func setup(){
        self.alpha = 0.0
        self.backgroundColor = UIColor.clear
    }
    //////////////////////////////////
    // Wait for Layout Subviews Before Creating Label
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addOptions(options: self.options)
    }
    /////////////////////////////////////
    func addOptions(options:[String]){
        self.options = options
        if self.options.count == 0 {
            return
        }
        
        let cellHeight = self.calculateCellHeight(options:options)
        let minY = self.bounds.minY
   
        // Create Option Cells
        for i in 0...options.count-1{
            
            let optionString = options[i] as String
            // Add Cell Height to Minimum y Point in Frame, Add Padding In Between
            let yFrame = minY + (cellHeight + self.verticalSpacing) * CGFloat(i)
            let newFrame = CGRect(x: self.bounds.minX+self.cellLeftOffset, y: yFrame, width: self.bounds.width-self.cellLeftOffset, height: cellHeight)
            
            // Create New Cell for Menu
            let newCell = DropDownCell(frame: newFrame)
            // Give New Cell Index
            newCell.index = i
            newCell.optionText = optionString
            newCell.delegate = self
            
            newCell.setupView(Viewframe:newFrame)
            self.cells.append(newCell)
            self.addSubview(newCell)
            self.bringSubview(toFront: newCell)
            
        }
        // Default Selection
        //self.selectAtIndex(index: 0)
    }
    /////////////////////////////////////
    func calculateCellHeight(options:[String])->CGFloat{
        let numCells = CGFloat(options.count)
        let availableHeight = self.frame.height - (numCells+1.0)*self.verticalSpacing
        let ratio = availableHeight/numCells
        return CGFloat(ratio)
    }
    /////////////////////////////
    // Delegate Handler for Dropdown Cell Selection
    internal func selectCell(selectedCell: DropDownCell) {
        
        print("Selection : \(selectedCell)")
        self.currentSelectedCell = selectedCell
        self.currentSelectedIndex = selectedCell.index
        self.currentSelection = selectedCell.optionText
        
        // Unselect All Cells Before Selecting Active Cell
        for cell in self.cells{
            if cell.index != self.currentSelectedIndex{
                cell.deselect()
            }
        }
        // Communicate to Super View to Make Selection
        delegate?.makeSelection(sender: self)
        // Hide Menu Automatically When Cell Clicked
        self.hideMenu()
    }
    /////////////////////////////////////
    func selectAtIndex(index:Int){
        if self.cells.count != 0{
            let selectedCell = self.cells[index]
            self.selectCell(selectedCell:selectedCell)
        }
    }
}
