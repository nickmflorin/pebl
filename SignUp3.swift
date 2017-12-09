//
//  SignUp3.swift
//  Pebl2
//
//  Created by Nick Florin on 11/24/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class SignUp3: UIViewController {
    
    ///////////////////////////////////////////
    // MARK: Properties

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var pageIndex : Int = 2
    var ref:FIRDatabaseReference!
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        
        // Styling
        self.view.backgroundColor = UIColor.clear
        self.styleButtons()
        self.styleTextFields()
        
    }
    ////////////////////////////
    func styleButtons(){
    }
    ////////////////////////////
    func styleTextFields(){

    }
    ///////////////////////////////////////////
    func completeLogin(){
        // Move to Main View in Storyboards
        let storyBoard : UIStoryboard = UIStoryboard(name: "Base", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Base") as! BaseViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    ///////////////////////////////////////////
    // MARK: Actions
    func finishSetup() {
        
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
}
