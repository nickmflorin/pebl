//
//  BaseViewController.swift
//  Pebl
//
//  Created by Nick Florin on 8/14/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import FirebaseAuth


class BaseViewController: UIViewController {
    
    var current_vc : UIViewController?
    
    var original_menu_frame : CGRect?
    var menuVC : MenuTableViewController?
    var menuView : UIView?
    var menuShowing : Bool = false
    ////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ////////////////////////////////////////////
        // Default View is Home View Controller
        let storyBoard : UIStoryboard = UIStoryboard(name: "Base", bundle:nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "BaseTabBarController") as! BaseTabBarController
        self.view.addSubview(homeViewController.view)
        self.addChildViewController(homeViewController)
        homeViewController.didMove(toParentViewController: self)
        
        ////////////////////////////////////////////
        // Store Current View Controller
        current_vc = homeViewController
        
        ////////////////////////////////////////////
        // Store Original Frame (Frame for Menu That Keeps It Off Screen)
        // Going to Need to Programatically Set These Offsets Later On (See Above Commented Out Code)
        let top_height_offset = CGFloat(64.0)
        let bottom_height_offset = CGFloat(50.0)
        
        self.original_menu_frame = CGRect(x: self.view.frame.origin.x-150.0, y: self.view.frame.origin.y+top_height_offset, width: 150.0, height: self.view.frame.height - top_height_offset - bottom_height_offset)
        
        // Add Menu View Controller to Base View - This Way It Can Be Shown from All Subviews of Base View
        self.addMenu()
        self.styleMenu()
    }
    ////////////////////////////////////////////
    // Setup Menu View Controller
    func addMenu(){
        
        // Initialize Menu View Controller
        let mainStoryboard = UIStoryboard.init(name: "Base", bundle: nil)
        self.menuVC = mainStoryboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController
        
        // Add Menu View as Subview 
        self.menuVC!.view.frame = self.original_menu_frame!
        self.menuView = self.menuVC!.view
        self.view.addSubview(self.menuView!)
        
        menuVC!.willMove(toParentViewController: self)
        // Add Menu View Controller to Parent Base View Controller
        self.addChildViewController(self.menuVC!)
        self.menuVC?.didMove(toParentViewController: self)
        
        // Initialize Paramters for Menu VC
        //Temporary
    }
    ////////////////////////////////////////////
    // Hides Menu When It Is Showing, Shows Menu When It Is Hiding - Animated
    func toggleMenu(){
    
        // Case When Menu Slide Out Already Showing
        if self.menuShowing == true{
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.menuView!.frame = self.original_menu_frame!
                }, completion: { finished in
                    self.menuShowing = false
            })
        }
        // Case When Menu Slide Out Not Already Showing
        else{
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.menuView!.frame = self.original_menu_frame!.offsetBy(dx: 150.0, dy: 0.0)
                }, completion: { finished in
                    self.menuShowing = true
            })
        }

    }
    ////////////////////////////////////////////
    // Menu Item that Logs the User Out - > Presents Alert View to Confirm First
    func logout(){
        print("Logging User Out")
        if self.menuShowing{
            self.toggleMenu()
        }
        ///// User Cancelled Logging Out //////////
        let alertController = UIAlertController(title: "Logging Out", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Logging User Out Cancelled")
        }
        alertController.addAction(cancelAction)
        
        ///// User Confirmed Logging Out //////////
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Logging User Out Confirmed")
            try! FIRAuth.auth()!.signOut()
            
            // Bring User Back to Login View Controller
            let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            self.present(vc, animated: false, completion: nil)
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    ////////////////////////////////////////////
    func gotoHome(){
        
        // Remove Existing View
        current_vc!.view.removeFromSuperview()
        current_vc?.removeFromParentViewController()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Base", bundle:nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "BaseTabBarController") as! BaseTabBarController
        self.view.addSubview(homeViewController.view)
        
        // Bring Menu View to Front So It Can Be Seen When Slid Over
        self.view.bringSubview(toFront: self.menuView!)
        
        self.addChildViewController(homeViewController)
        homeViewController.didMove(toParentViewController: self)
        
        // Store Current View Controller
        current_vc = homeViewController
    }
    ////////////////////////////////////////////
    func gotoSettings(){
        // Remove Existing View
        current_vc!.view.removeFromSuperview()
        current_vc?.removeFromParentViewController()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Settings", bundle:nil)
        let settingsViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsNavController") as! UINavigationController
        self.view.addSubview(settingsViewController.view)
        
        // Bring Menu View to Front So It Can Be Seen When Slid Over
        self.view.bringSubview(toFront: self.menuView!)
        
        self.addChildViewController(settingsViewController)
        settingsViewController.didMove(toParentViewController: self)
        
        // Store Current View Controller
        current_vc = settingsViewController
    }
    ////////////////////////////////////////////
    func gotoEditProfile(){
        
        // Remove Existing View
        current_vc!.view.removeFromSuperview()
        current_vc?.removeFromParentViewController()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "EditProfile", bundle:nil)
        let editprofileViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfile_TabVC") as! UITabBarController
        self.view.addSubview(editprofileViewController.view)
        
        // Bring Menu View to Front So It Can Be Seen When Slid Over
        self.view.bringSubview(toFront: self.menuView!)
        
        self.addChildViewController(editprofileViewController)
        editprofileViewController.didMove(toParentViewController: self)
        
        // Store Current View Controller
        current_vc = editprofileViewController
        
    }
    ////////////////////////////////////////////
    func gotoAbout(){
        
        // Remove Existing View
        current_vc!.view.removeFromSuperview()
        current_vc?.removeFromParentViewController()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Settings", bundle:nil)
        let aboutViewController = storyBoard.instantiateViewController(withIdentifier: "AboutNavController") as! UINavigationController
        self.view.addSubview(aboutViewController.view)
        
        // Bring Menu View to Front So It Can Be Seen When Slid Over
        self.view.bringSubview(toFront: self.menuView!)
        
        self.addChildViewController(aboutViewController)
        aboutViewController.didMove(toParentViewController: self)
        
        // Store Current View Controller
        current_vc = aboutViewController
        
    }
    
}
