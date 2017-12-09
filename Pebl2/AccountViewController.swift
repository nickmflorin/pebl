//
//  AccountViewController.swift
//  Pebl
//
//  Created by Nick Florin on 11/14/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    /////////////////////////////
    // Mark : Properties
    @IBOutlet weak var accountTile: UIView!
    @IBOutlet weak var accountInfoTile: UIView!
    
    @IBOutlet weak var ageField: UILabel!
    @IBOutlet weak var genderInterestField: UILabel!
    @IBOutlet weak var genderField: UILabel!
    @IBOutlet weak var nameField: UILabel!
    
    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var emailField: UILabel!
    
    @IBOutlet weak var changeEmailButton: UILabel!
    @IBOutlet weak var changeUserNameButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
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
    // Populates User Info for Settings View
    func populateInfo(){
        func populateInfo(){
            if self.currentUser != nil{
                self.emailField.text = self.currentUser?.email
            }
        }
    }
    ///////////////////////////
    func styleViews(){
        
        // Prepare Views and Heights to Be Looped Over
        let views = [self.accountTile,self.accountInfoTile]
        
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
