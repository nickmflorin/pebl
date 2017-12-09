//
//  CreateStatusView.swift
//  Pebl2
//
//  Created by Nick Florin on 1/25/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

//////////////////////////////////////////////////////////////////////////////////////
class CreateStatusView: UIView {
    
    // MARK: Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var eventSearchField: EventSearchField!
    @IBOutlet weak var createStatusViewSlider: CreateStatusViewSlider!
    
    @IBOutlet weak var sliderHeader : UILabel!
    @IBOutlet weak var proceedButton : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    
    /////////////////////////////////////
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
        
        Bundle.main.loadNibNamed("CreateStatusView", owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
        
        self.didAddSubview(createStatusViewSlider)
        self.setup()
    }
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        Bundle.main.loadNibNamed("CreateStatusView", owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
        
        self.didAddSubview(createStatusViewSlider)
        self.setup()
    }
    //////////////////////////////
    // Init for Drawing Underlying
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        
    }
    //////////////////////////////
    func setup(){
        self.defaultStates()
    }
    
    //////////////////////////////
    // Default States for Buttons and Labels
    func defaultStates(){
        // Initial State of Buttons and Headers
        
        self.sliderHeader.text = "Your favorites"
        
        self.proceedButton.alpha = 0.0
        self.cancelButton.alpha = 0.0
        
        self.proceedButton.isEnabled = false
        self.cancelButton.isEnabled = false
    }
    
    // Button and label states for the select time view
    func statesView1(){
        
        self.sliderHeader.text = "Pick a time"
        self.proceedButton.setTitle("Next", for: .normal)
        self.cancelButton.setTitle("Cancel",for:.normal)
        
        self.proceedButton.isEnabled = true
        self.cancelButton.isEnabled = true
        
        self.proceedButton.alpha = 1.0
        self.cancelButton.alpha = 1.0
    }
    
    // Button and label states for the select message view
    func statesView2(){
        
        self.sliderHeader.text = "Enter your message"
        self.proceedButton.setTitle("Finish", for: .normal)
        self.cancelButton.setTitle("Cancel",for:.normal)
        
        self.proceedButton.isEnabled = true
        self.cancelButton.isEnabled = true
        
        self.proceedButton.alpha = 1.0
        self.cancelButton.alpha = 1.0
    }
    
    //////////////////////////////
    // Mark: Actions
    @IBAction func proceedButtonClicked(_ sender: AnyObject) {
        
        // Proceed Button Clicked from Time Select Field
        if self.createStatusViewSlider.currentIndex == 1 {
            // Send notification that next button was clicked from time select view
            let dataDict = ["sender":self.createStatusViewSlider.timeSelectField,"selectedTime":self.createStatusViewSlider.timeSelectField.activeSelection] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nextButtonClicked"), object:dataDict)
        }
        // Proceed Button is Finish Button from Message Selection Stage
        else{
            // Send notification that next button was clicked from time select view
            let dataDict = ["sender":self.createStatusViewSlider.messageSelectionView,"selectedMessage":self.createStatusViewSlider.messageSelectionView.textField.text] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "finishButtonClicked"), object:dataDict)
        }
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
        
        // Send notification that cancel button was clicked, sender doesn't matter because actions the same
        let dataDict = ["sender":self]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancelButtonClicked"), object:dataDict)

    }
    
    @IBAction func categoryButtonClicked(_ sender: AnyObject) {
        // Send notification that cancel button was clicked from time select view
        let dataDict = ["sender":self]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "categoryButtonClicked"), object:dataDict)
    }
    
    @IBAction func searchButtonClicked(_ sender: AnyObject) {
        // Send notification that cancel button was clicked from time select view
        let dataDict = ["sender":self]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchButtonClicked"), object:dataDict)
    }
}


