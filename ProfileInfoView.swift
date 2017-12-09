//
//  ProfileInfoView.swift
//  Pebl2
//
//  Created by Nick Florin on 1/12/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit


//////////////////////////////////////////////////////////////////////////////////////
class ProfileInfoView: UIView {
    
    // MARK: Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var distanceField: UILabel!
    @IBOutlet weak var firstNameField: UILabel!
    
    @IBOutlet weak var dottedLines2: DottedLines!
    @IBOutlet weak var dottedLines1: DottedLines!
    @IBOutlet weak var hobbiesField: UILabel!
    @IBOutlet weak var educationField: UILabel!
    @IBOutlet weak var careerField: UILabel!
    
    var userInfo : UserInfo!
    /////////////////////////////////////
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
        
        Bundle.main.loadNibNamed("ProfileInfoView", owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
    }
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        Bundle.main.loadNibNamed("ProfileInfoView", owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
    }
    //////////////////////////////
    // Init for Drawing Underlying
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
    }
    //////////////////////////////
    // Sets Up Image View
    func setup(){
        
        self.firstNameField.text = self.userInfo.firstName! + ", "+String(describing: self.userInfo.age!)
        self.distanceField.text = "3 mi"
        self.careerField.text = self.userInfo.parseCareer()
        self.educationField.text = self.userInfo.parseEducation()
        self.hobbiesField.text = self.userInfo.parseHobbies()
    }
}
