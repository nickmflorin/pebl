//
//  ViewController.swift
//  Pebl
//
//  Created by Nick Florin on 6/23/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

//////////////////////////////////////////////
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var userNameFieldView: StyledInputField!
    @IBOutlet weak var passwordFieldView: StyledInputField!

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var ref:FIRDatabaseReference!
    ////////////////////////////
    override func viewDidLoad() {
        
        //self.ref = FIRDatabase.database().reference()
        //self.completeLogIn()
        
        // Set Background Image
        self.view.applyBackground()
        
        // Activity Indicator
        self.view.bringSubview(toFront: spinner)
        self.spinner.alpha = 0.0
        self.spinner.startAnimating()
        
        // Text Field Setup
        self.setupTextFields()
        
        // Button Setup
        self.styleButtons()
        loginButton.addTarget(self, action: #selector(LoginViewController.logIn), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(LoginViewController.signUp), for: .touchUpInside)
        
        super.viewDidLoad()
    }
    ////////////////////////////
    func setupTextFields(){

        self.userNameFieldView.backgroundColor = UIColor.clear
        self.userNameFieldView.iconImage = UIImage(named:"UserIconBlue")
        self.userNameFieldView.fieldDefaultText = "Username or Email"
        self.userNameFieldView.setup()

        self.userNameFieldView.textField.autocapitalizationType = .none
        
        self.passwordFieldView.backgroundColor = UIColor.clear
        self.passwordFieldView.iconImage = UIImage(named:"PasswordIconBlue")
        self.passwordFieldView.fieldDefaultText = "Password"
        self.passwordFieldView.setup()
        
        self.passwordFieldView.textField.autocapitalizationType = .none
        self.passwordFieldView.textField.isSecureTextEntry = true
        self.passwordFieldView.textField.clearsOnBeginEditing = true
    }
    ///////////////////////////////////////////
    // Check for Authorization When View Appears
    override func viewDidAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser != nil {
            // PreLoad Data and Perform Any Initial Setup
            PreLoad().preload({finished in
                self.autoLogin()
            })
        }
    }
    /////////////////////////////
    // Automatically Moves User to Login State of App if Previous Login Detected
    func autoLogin(){
        
        self.spinner.alpha = 1.0
        self.spinner.startAnimating()
        
        // Load User Info for Current User and Store to App Delegate
        let uid = FIRAuth.auth()?.currentUser?.uid
        guard uid != nil else {
            fatalError("Authentication Error")
        }
        // Preload Data
        if uid != nil{
            self.completeLogIn()
            self.spinner.alpha = 0.0
            self.spinner.stopAnimating()
        }
    }
    ////////////////////////////
    func styleButtons(){
        let font_name = "SanFranciscoDisplay-Regular"
        let buttonFont = UIFont (name: font_name, size:12)
        
        self.loginButton.setTitle("Login",for: UIControlState.normal)
        self.loginButton.setBackgroundColor(light_blue, forState: UIControlState.normal)

        for button in [self.loginButton]{
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
    func logIn() {

        if let email = self.userNameFieldView.textField.text, let password = self.passwordFieldView.textField.text {
            self.spinner.alpha = 1.0
            self.spinner.startAnimating()

            // Sign In with Firebase Authentication
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                
                // Check for Connection Errors
                if let error = error {
                    self.spinner.alpha = 0.0
                    self.spinner.stopAnimating()
                    print("There was an error connecting with the Firebase Authentication system.")
                    print(error.localizedDescription)
                    return
                }
                // Check if Valid Authentication
                else if let user = user {
                    print("Successful Login")
                    self.completeLogIn()
                    self.spinner.alpha = 0.0
                    self.spinner.stopAnimating()

                }
//                else if let user = user {
//                    print("Successful Login")
//                    self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
//                        
//                        if snapshot.exists(){
//                            // Check if Username Field Empty
//                            if self.userNameFieldView.textField.text != nil {
//                                let uid = FIRAuth.auth()?.currentUser!.uid
//                                if let unwrapped_uid = uid {
//                                    let curUser = AuthUser(uid:unwrapped_uid)
//                                    
//                                    // Load Info and Authorization Data for Current User and Store to Object
//                                    curUser.setup({ (finished) -> () in
//                                        if finished{
//                                            // Store Current User Object to App Delegate
//                                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                            appDelegate.currentUser = curUser
//                                            
//                                            print("Current User Info Successfully Loaded and Stored")
//                                            self.completeLogIn()
//                                            self.spinner.alpha = 0.0
//                                            self.spinner.stopAnimating()
//                                        }
//                                    })
//                                }
//                            }
//                            else{
//                                print("Username Field is Empty")
//                                self.spinner.alpha = 0.0
//                                self.spinner.stopAnimating()
//                            }
//                        }
//                        // Invalid Authentication
//                        else {
//                            self.spinner.alpha = 0.0
//                            self.spinner.stopAnimating()
//                            print("Invalid Authentication")
//                        }
//                    }) // End of Observe Single Event
//                }
            }
        } else {
            self.spinner.alpha = 0.0
            self.spinner.stopAnimating()
            print("Invalid Authentication", terminator: "")
        }
    }
    ///////////////////////////////////////////
    func signUp(){
        // Move to Sign in Storyboards
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    ///////////////////////////////////////////
    func completeLogIn(){
        // Move to Main View in Storyboards
        let storyBoard : UIStoryboard = UIStoryboard(name: "Base", bundle:nil)
        //let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MessagePeblsVCViewController") as! MessagePeblsVCViewController
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Base") as! BaseViewController
        self.present(nextViewController, animated:true, completion:nil)
    }

}
