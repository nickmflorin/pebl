//
//  SwipeProfileInfoVC.swift
//  Pebl
//
//  Created by Nick Florin on 11/6/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SwipeProfileInfoViewController: UIViewController {
    
    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var hobbiesField1: UILabel!
    @IBOutlet weak var hobbiesField2: UILabel!
    @IBOutlet weak var hobbiesField4: UILabel!
    @IBOutlet weak var hobbiesField3: UILabel!
    
    @IBOutlet weak var educationField: UILabel!
    @IBOutlet weak var careerField: UILabel!
    
    @IBOutlet weak var hobbiesView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var eventView: UIView!
    
    @IBOutlet weak var whenField: UILabel!
    @IBOutlet weak var eventMessageField: UILabel!
    @IBOutlet weak var eventField: UILabel!
    
    @IBOutlet weak var slideButton: UIButton!
    @IBOutlet weak var slideButtonView: UIView!
    
    var potentialMatch : PotentialMatch?
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleViews()
        self.setupProfile()
        self.view.bringSubview(toFront: self.slideButtonView)
    }
    ///////////////////////////////////////////
    func setupProfile(){
        
        if self.potentialMatch != nil{
            //self.educationField.text = self.potentialMatch?.user?.userInfo?.education
            //self.careerField.text = self.potentialMatch?.user?.userInfo?.career
            
            //self.eventField.text = self.potentialMatch?.user?.userInfo?.statusEvent?.event_name
            //self.whenField.text = self.potentialMatch?.user?.userInfo?.statusEvent?.event_time
            //self.eventMessageField.text = self.potentialMatch?.userInfo?.statusEvent?.eventMessage
            //Temporary
            self.eventMessageField.text = "This is where the user can attach a short and general message with their status event."
            
            // Attach Hobbies
            var hobbiesFields = [self.hobbiesField1, self.hobbiesField2, self.hobbiesField3, self.hobbiesField4]
            if let hobbies_list = potentialMatch?.user?.userInfo?.hobbies as [String]?{
                for i in 0...hobbies_list.count-2{
                    hobbiesFields[i]?.text = potentialMatch?.user?.userInfo?.hobbies[i]
                }
            }
            self.backgroundView.bringSubview(toFront: self.educationField)
            self.backgroundView.bringSubview(toFront: self.careerField)
            
            self.view.bringSubview(toFront: self.slideButtonView)
            
        }
    }
    ///////////////////////////////////////////
    func styleViews(){
        
        self.slideButtonView.layer.backgroundColor = UIColor.white.cgColor
        self.slideButtonView.layer.masksToBounds = true
        self.slideButtonView.layer.cornerRadius = 1.0
        self.slideButtonView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.slideButtonView.layer.shadowOpacity = 0.2
        self.slideButtonView.layer.borderColor = UIColor.clear.cgColor
        self.slideButtonView.layer.borderWidth = 1.0;
        
        for view in [self.hobbiesView,self.backgroundView,self.eventView]{
            view?.layer.backgroundColor = UIColor.white.withAlphaComponent(0.90).cgColor
            view?.layer.masksToBounds = true
            view?.layer.cornerRadius = 2.0
            view?.layer.shadowOffset = CGSize(width: -1, height: 1)
            view?.layer.shadowOpacity = 0.2
            view?.layer.borderColor = UIColor.clear.cgColor
            view?.layer.borderWidth = 1.0;
            

        }
    }
    //////////////////////////////////////////
    // Mark: Actions
    @IBAction func infoToggle(_ sender: AnyObject) {
        let parent = self.parent as? SwipeViewController
        parent?.toggleProfileInfo()
    }
}

