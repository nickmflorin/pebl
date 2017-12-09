//
//  EditProfile_GeneralVC.swift
//  Pebl
//
//  Created by Nick Florin on 11/13/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

class EditProfileGeneralVC: UIViewController, SSRadioButtonControllerDelegate {
    
    //////////////////////////
    //MARK: Properties
    @IBOutlet weak var hobbiesView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var editBackgroundButton: UIButton!
    
    // Hobbies Fields
    @IBOutlet weak var hobbiesField1: UILabel!
    @IBOutlet weak var hobbiesField2: UILabel!
    @IBOutlet weak var hobbiesField3: UILabel!
    @IBOutlet weak var hobbiesField4: UILabel!
    @IBOutlet weak var hobbiesField5: UILabel!
    @IBOutlet weak var hobbiesField6: UILabel!
    
    @IBOutlet weak var aboutMeField: UILabel!
    @IBOutlet weak var careerField: UILabel!
    @IBOutlet weak var educationField2: UILabel!
    @IBOutlet weak var educationField1: UILabel!
    @IBOutlet weak var cityField: UILabel!

    var genderRadioController : SSRadioButtonsController?
    var genderInterestRadioController : SSRadioButtonsController?
    
    var currentUser : AuthUser?

    /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Styling from Master Style
        self.styleMenu()
        self.navigationController?.styleTitle("Profile")
        self.styleViews()
        
        // Get Current User from App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.currentUser = appDelegate.currentUser
        self.populateInfo()
    }
    ///////////////////////////////////////////////////////////
    // This is When Subview Frames and Coordinates are Determined
    /////////////////////////////
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    ///////////////////////////////////////////////////////////
    // Populates User Info for Settings View
    func populateInfo(){
        if self.currentUser != nil{

            if self.currentUser?.userInfo != nil{
                
                // Temporary Fils
                self.educationField1.text = "Johns Hopkins University"
                self.educationField2.text = "Rensselaer Polytechnic Institute"
                //self.educationField1.text = self.currentUser?.userInfo?.education
                
                self.careerField.text = self.currentUser?.userInfo?.career
                
                self.cityField.text = "Washington D.C."
                self.aboutMeField.text = "Hey!  I just joined Pebl, and sarcastically helped to make it.  I love going out and trying new things around the city, feel free to invite me to something!"

            }
        }
    }
    ///////////////////////////////////////////////////////////
    // Implements Custom Radio Buttons for Gender Selection
    func initRadios(){
//        self.genderRadioController = SSRadioButtonsController(buttons: self.maleGenderButton, self.femaleGenderButton, self.otherGenderButton)
//        self.genderInterestRadioController = SSRadioButtonsController(buttons: self.femaleGenderIntButton, self.femaleGenderIntButton, self.otherGenderIntButton)
//
//        self.genderInterestRadioController!.delegate = self
//        self.genderInterestRadioController!.shouldLetDeSelect = true
//        self.genderRadioController!.delegate = self
//        self.genderRadioController!.shouldLetDeSelect = true
//        
//        self.maleGenderButton.circleColor = light_blue
//        self.femaleGenderButton.circleColor = light_blue
//        self.otherGenderButton.circleColor = light_blue
//        self.maleGenderIntButton.circleColor = light_blue
//        self.femaleGenderIntButton.circleColor = light_blue
//        self.otherGenderIntButton.circleColor = light_blue
    }
    ///////////////////////////
    func styleViews(){
        
        // Prepare Views and Heights to Be Looped Over
        let views = [self.hobbiesView, self.backgroundView]
        
        // Loop Over Views and Add Perforated Back View for Each
        for i in 0...views.count-1{
            let view = views[i] as UIView!

            if let unwrappedView = view {
                
                unwrappedView.layer.backgroundColor = UIColor.white.cgColor
                unwrappedView.layer.shadowOffset = CGSize(width: -2, height: 2)
                unwrappedView.layer.shadowOpacity = 0.5
                unwrappedView.layer.borderWidth = 1.5;
                unwrappedView.layer.borderColor = UIColor.clear.cgColor
                unwrappedView.layer.cornerRadius = 5.0
                unwrappedView.layer.masksToBounds = true
            }
        }
        
    }
    ///////////////////////////////////////////
    // Performs Segue for Showing Popover Menu
    func menu_buttonToggle() {
        let baseVC = self.parent?.parent?.parent as! BaseViewController
        baseVC.toggleMenu()
    }
    ///////////////////////////////////////////
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

}
