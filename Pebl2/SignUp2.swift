//
//  SignUp_Finish.swift
//  Pebl
//
//  Created by Nick Florin on 8/12/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class SignUp2: UIViewController, UIPopoverPresentationControllerDelegate {

    
    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var firstNameFieldView: StyledInputField!
    @IBOutlet weak var lastNameFieldView: StyledInputField!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var dropDownField: DropDownField!
    @IBOutlet weak var dropDownMenu: DropDownMenu!
    
    @IBOutlet weak var dropDownField2: DropDownField!
    @IBOutlet weak var dropDownMenu2: DropDownMenu!
    
    var pageIndex : Int = 1
    var ref:FIRDatabaseReference!
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()

        // Styling
        self.view.backgroundColor = UIColor.clear
        self.styleButtons()
        self.styleTextFields()
        
        // Setup Dropdown Field for Gender ////////////
        let genderImage = UIImage(named:"GenderIconBlue")
        dropDownField.iconImage = genderImage
        dropDownField.textColor = secondaryColor
        
        // Set Delegate of Dropdown Menu to Dropdown Field
        dropDownMenu.delegate = dropDownField
        dropDownField.delegate = dropDownMenu
        dropDownMenu.options = ["Male","Female","Don't Identify"]
        dropDownMenu.cellLeftOffset = dropDownField.imageWidth+5.0
            
        // Setup Dropdown Field for Gender Interest or Seeking ////////////
        dropDownField2.iconImage = genderImage
        dropDownField2.textColor = secondaryColor
        
        // Set Delegate of Dropdown Menu to Dropdown Field
        dropDownMenu2.delegate = dropDownField2
        dropDownField2.delegate = dropDownMenu2
        dropDownMenu2.options = ["Male","Female","Both"]
        dropDownMenu2.cellLeftOffset = dropDownField2.imageWidth+5.0
    }
    ////////////////////////////
    func styleButtons(){
        self.finishButton.addTarget(self, action: #selector(SignUp2.continueRegistration), for: .touchUpInside)
        let font_name = "SanFranciscoDisplay-Regular"
        let buttonFont = UIFont (name: font_name, size:12)
        
        self.finishButton.setTitle("Continue",for: UIControlState.normal)
        self.finishButton.setBackgroundColor(light_blue, forState: UIControlState.normal)
        
        for button in [self.finishButton]{
            button?.titleLabel?.font = buttonFont
            button?.setTitleColor(UIColor.white, for: UIControlState.normal)
            button?.layer.borderWidth = 2.0
            button?.layer.borderColor = UIColor.clear.cgColor
            button?.layer.cornerRadius = 5.0
            button?.layer.masksToBounds = true
        }
    }
    ////////////////////////////
    func styleTextFields(){
        self.firstNameFieldView.backgroundColor = UIColor.clear
        self.firstNameFieldView.iconImage = UIImage(named:"FirstNameIconBlue")
        self.firstNameFieldView.fieldDefaultText = "First Name"
        self.firstNameFieldView.setup()
        
        self.lastNameFieldView.backgroundColor = UIColor.clear
        self.lastNameFieldView.iconImage = UIImage(named:"LastNameIconBlue")
        self.lastNameFieldView.fieldDefaultText = "Last Name"
        self.lastNameFieldView.setup()
    }
    ///////////////////////////////////////////
    func moveToStage3(){
        // Move to Main View in Storyboards
        let storyBoard : UIStoryboard = UIStoryboard(name: "Base", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Base") as! BaseViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    ///////////////////////////////////////////
    // MARK: Actions
    func continueRegistration() {
        
//        if let first_name = self.first_nameField.text, let last_name = self.last_nameField.text, let age = self.ageField.text  {
//
//            self.spinner.alpha = 1.0
//            self.spinner.startAnimating()
//
//            // Put Credentials in Firebase Authorization
//            
//            // Get Current User UID from Firebase Auth
//            let userID = FIRAuth.auth()?.currentUser?.uid
//            // Allow User to Add Data
//            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//                    if (snapshot.exists()) {
//                        let post = ["first_name": first_name,"last_name": last_name,"age": age]
//                        self.ref.child("users").child(userID!).updateChildValues(post)
//                        
//                        self.spinner.alpha = 0.0
//                        self.spinner.stopAnimating()
//                        self.move_to_main_menu()
//                    }
//            })
//        }
//        else{
//            print("Invalid Information", terminator: "")
//        }
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

