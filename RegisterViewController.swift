//
//  RegisterViewController.swift
//  Pebl2
//
//  Created by Nick Florin on 11/26/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

//////////////////////////////////////////////////////////////////
class RegisterViewController: UIViewController {
    
    
    //////////////////////
    //Mark: Properties
    @IBOutlet weak var customProgressView: CustomRegisterProgressView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    var currentIndex : Int = 0
    ///////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Activity Indicator
        self.view.bringSubview(toFront: spinner)
        self.spinner.alpha = 0.0
        self.spinner.startAnimating()
        
        // Set Background Image
        self.view.applyBackground()

        let registerPageVC = self.storyboard!.instantiateViewController(withIdentifier: "RegisterPageViewController") as! RegisterPageViewController
        
        // Add Register Page View Controller View as Container Subview
        registerPageVC.view.frame = self.containerView.bounds
        self.containerView.addSubview(registerPageVC.view)
        
        // Add as Child View Controller
        registerPageVC.willMove(toParentViewController: self)
        self.addChildViewController(registerPageVC)
        registerPageVC.didMove(toParentViewController: self)
    }
}

/////////////////////////////////////////////////////////////////////
class RegisterPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    ///////////////////////
    // MARK: Properties
    var ViewControllers : [UIViewController] = []
    var currentIndex : Int = 0
    
    ///////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        // Setup View Controllers
        self.addViewControllers()
        let initialVC = self.getViewControllerAtCurrentIndex()
        var initialVCList : [UIViewController] = []
        initialVCList.append(initialVC)
        self.setViewControllers(initialVCList, direction: .forward, animated: false, completion: nil)

    }
    ///////////////////////
    func addViewControllers(){
        // Setup View Controllers
        let signup1 = self.storyboard!.instantiateViewController(withIdentifier: "SignUp1") as! SignUp1
        self.ViewControllers.append(signup1)
        
        let signup2 = self.storyboard!.instantiateViewController(withIdentifier: "SignUp2") as! SignUp2
        self.ViewControllers.append(signup2)
        
        let signup3 = self.storyboard!.instantiateViewController(withIdentifier: "SignUp3") as! SignUp3
        self.ViewControllers.append(signup3)
        return
    }
    ///////////////////////
    // Gets the View Controller in [SignUp1, SignUp2, SignUp3] Corresponding to Index
    func getViewControllerAtCurrentIndex()->UIViewController{
        let foundViewController : UIViewController! = self.ViewControllers[self.currentIndex]
        return foundViewController
    }
    ///////////////////////
    // Moves to Next Page of Sign Up Process
    func nextPage(){
        if self.currentIndex == self.ViewControllers.count-1{
            return
        }
        self.currentIndex = self.currentIndex + 1
        // Track Current Index in Parent Too
        let parentVC = self.parent as! RegisterViewController
        parentVC.currentIndex = self.currentIndex
        
        // Increment Animated Custom Progress View
        parentVC.customProgressView.increment(index:self.currentIndex)
        parentVC.customProgressView.setNeedsDisplay()
        
        let nextVC = self.getViewControllerAtCurrentIndex()
        self.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
    }
    ///////////////////////
    func pageViewController(_ pageViewController: UIPageViewController,
                                     viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Immediately Return Nil - Only Want Programmatic Changes on Button Clicks Not Sliding
        return nil
        if currentIndex == 0 {
            return nil
        }
        // Decrement Index
        currentIndex = currentIndex-1
        // Track Current Index in Parent Too
        let parentVC = self.parent as! RegisterViewController
        parentVC.currentIndex = self.currentIndex
        return getViewControllerAtCurrentIndex()
    }
    ///////////////////////
    func pageViewController(_ pageViewController: UIPageViewController,
                                     viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Immediately Return Nil - Only Want Programmatic Changes on Button Clicks Not Sliding
        return nil
        if currentIndex == self.ViewControllers.count-1{
            return nil
        }
        // Decrement Index
        currentIndex = currentIndex+1
        // Track Current Index in Parent Too
        let parentVC = self.parent as! RegisterViewController
        parentVC.currentIndex = self.currentIndex

        return getViewControllerAtCurrentIndex()

    }
}
