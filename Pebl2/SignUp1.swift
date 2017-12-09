//
//  SignUpViewController2.swift
//  Pebl
//
//  Created by Nick Florin on 6/23/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUp1: UIViewController {
    
    
    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var emailFieldView: StyledInputField!
    @IBOutlet weak var userNameFieldView: StyledInputField!
    @IBOutlet weak var confirmPasswordFieldView: StyledInputField!
    @IBOutlet weak var passwordFieldView: StyledInputField!

    @IBOutlet weak var continueButton : UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var pageIndex : Int = 0
    var ref:FIRDatabaseReference!
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()

        // Styling
        self.view.backgroundColor = UIColor.clear
        self.styleButtons()
        self.setupTextFields()
    }
    ////////////////////////////
    func setupTextFields(){
        self.emailFieldView.backgroundColor = UIColor.clear
        self.emailFieldView.iconImage = UIImage(named:"EmailIconBlue")
        self.emailFieldView.fieldDefaultText = "Enter Your Email"
        self.emailFieldView.setup()
        
        self.userNameFieldView.backgroundColor = UIColor.clear
        self.userNameFieldView.iconImage = UIImage(named:"UserIconBlue")
        self.userNameFieldView.fieldDefaultText = "Enter Desired Username"
        self.userNameFieldView.setup()
        
        self.confirmPasswordFieldView.backgroundColor = UIColor.clear
        self.confirmPasswordFieldView.iconImage = UIImage(named:"PasswordIconBlue")
        self.confirmPasswordFieldView.fieldDefaultText = "Confirm Password"
        self.confirmPasswordFieldView.setup()
        
        self.passwordFieldView.backgroundColor = UIColor.clear
        self.passwordFieldView.iconImage = UIImage(named:"PasswordIconBlue")
        self.passwordFieldView.fieldDefaultText = "Enter Password"
        self.passwordFieldView.setup()

    }
    ////////////////////////////
    func styleButtons(){
        self.continueButton.addTarget(self, action: #selector(SignUp1.continueRegistration), for: .touchUpInside)
        let font_name = "SanFranciscoDisplay-Regular"
        let buttonFont = UIFont (name: font_name, size:12)
        
        self.continueButton.setTitle("Continue",for: UIControlState.normal)
        self.continueButton.setBackgroundColor(light_blue, forState: UIControlState.normal)
        
        for button in [self.continueButton]{
            button?.titleLabel?.font = buttonFont
            button?.setTitleColor(UIColor.white, for: UIControlState.normal)
            button?.layer.borderWidth = 2.0
            button?.layer.borderColor = UIColor.clear.cgColor
            button?.layer.cornerRadius = 5.0
            button?.layer.masksToBounds = true
        }
    }
    ///////////////////////////////////////////
    // MARK: Actions
    @IBAction func cancelRegistration(_ sender: AnyObject) {
        // Move Back to Login Storyboard
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        self.present(nextViewController, animated:true, completion:nil)
        return
    }
    /////////////////////
    func continueRegistration() {
        // Move to Next Stage of Sign Up
        let parentVC = self.parent as! RegisterPageViewController
        parentVC.nextPage()
        return
        
//        if let user_name = self.usernameField.text, let email = self.emailField.text, let password = self.passwordField.text, let confirm_password = self.confirm_passwordField.text  {
//            if password == confirm_password {
//                
//                self.spinner.alpha = 1.0
//                self.spinner.startAnimating()
//                // Put Credentials in Firebase Authorization
//                FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
//                    if let error = error {
//                        self.spinner.alpha = 0.0
//                        self.spinner.stopAnimating()
//                        
//                        print(error.localizedDescription)
//                        return
//                    }
//                    // Update System for Current User
//                    let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
//                    changeRequest?.displayName = user_name
//                    
//                    changeRequest?.commitChanges() { (error) in
//                        if let error = error {
//                            print(error.localizedDescription)
//                            return
//                        }
//                        self.spinner.alpha = 0.0
//                        self.spinner.stopAnimating()
//                        self.ref.child("users").child((FIRAuth.auth()?.currentUser!.uid)!).setValue(["user_name": user_name])
//                        self.move_to_signup_stage2()
//                    }
//                }
//            }
//            else{
//                print("Password Fields Do Not Match", terminator: "")
//            }
//        }
//        else{
//            self.spinner.alpha = 0.0
//            self.spinner.stopAnimating()
//            print("Invalid Information", terminator: "")
//        }
        
    }
}



