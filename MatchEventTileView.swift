//
//  MatchEventTileView.swift
//  Pebl2
//
//  Created by Nick Florin on 1/17/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

//////////////////////////////////////////////////////////////////////////////////////
class MatchEventTileView: UIView {
    
    // MARK: Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventMessageField: UILabel!
    @IBOutlet weak var eventTimeField: UILabel!
    @IBOutlet weak var eventNameField: UILabel!
    
    var outlineLineWidth : CGFloat = 1.8
    
    var event : UserEvent!
    /////////////////////////////////////
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
        
        Bundle.main.loadNibNamed("MatchEventTileView", owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
    }
    //////////////////////////////
    // Init for Drawing Underlying
    override func draw(_ rect: CGRect) {
        
        self.backgroundColor = UIColor.clear
        
        // Style Image View
        self.eventImageView.contentMode = .scaleAspectFill
        self.eventImageView.layer.cornerRadius = 0.5*self.eventImageView.bounds.width
        self.eventImageView.layer.borderColor = UIColor.clear.cgColor
        self.eventImageView.layer.borderWidth = 1.0
        self.eventImageView.layer.masksToBounds = true
        
    }
    //////////////////////////////
    // Sets Up Image View
    func setup(event:UserEvent){
        
        self.event = event
        self.eventNameField.text = "Fiola del Mar Seafood Restaurant"
        self.eventTimeField.text = "Sometime this weekend"
        self.eventMessageField.text = "Have been dying to try this place out... its on Washingtonian's Top 100 and right on the Georgetown Bay"
        self.eventImageView.image = UIImage(named:"PizzaEvent")
    }
    
}
