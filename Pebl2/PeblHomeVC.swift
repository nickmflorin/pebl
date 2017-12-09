//
//  HomeVC.swift
//  Pebl
//
//  Created by Nick Florin on 8/9/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

/////////////////////////////////////////////////////////////////////
// Delegate for Page View Controller to Add Pages/Indices to Horizontal Menu
protocol PeblHomeVCDelegate: class {
    func addPage(sender: PeblHomeVC, peblPage:PeblPage)
}
////////////////////////////////////////////////////////////////////
struct PeblPage{
    var viewController : UIViewController!
    var index : Int!
    var title : String!
}

//////////////////////////////////////////////////////////////////
class PeblHomeVC: UIViewController, UIPageViewControllerDataSource, PeblHorizontalMenuDelegate {

    //////////////////////
    //Mark: Properties
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuContainerView: UIView!
    
    var currentIndex : Int = 0
    var Pages : [PeblPage] = []
    
    var pageViewController: PeblHomeVCPageViewController!
    var peblHorizontalMenu : PeblHorizontalMenu!
    var contentViewTitles : [String] = ["Message Pebls","Suggestion Pebls"]
    
    weak var delegate: PeblHomeVCDelegate?
    ///////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Activity Indicator
        self.view.bringSubview(toFront: spinner)
        self.spinner.alpha = 0.0
        self.spinner.startAnimating()
        
        // Styling from Master Style
        self.styleMenu()
        self.navigationController?.styleTitle("Pebls")
        self.view.backgroundColor = UIColor.clear
        
        // Create Page View Controller for Pebls
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PeblHomeVCPageViewController") as? PeblHomeVCPageViewController
        pageViewController.view.frame = self.containerView.bounds
        self.containerView.addSubview(pageViewController.view)
        
        // Add as Child View Controller
        pageViewController.willMove(toParentViewController: self)
        self.addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: self)
        
        // Give Delegate
        pageViewController.dataSource = self
        
        //Scrolling Needs to be Altered for Thumbnail Scrolls to Work as Well
        self.disableScrollView()
        
        self.setupPages()
    }
    ///////////////////////////////////////////////////////////
    override func viewDidLayoutSubviews() {
        // Initializee Pebl Horizontal Menu View
        peblHorizontalMenu = PeblHorizontalMenu(frame: menuContainerView.bounds)
        peblHorizontalMenu.activeIndex = self.currentIndex
        
        // Assign Delegates
        self.delegate = peblHorizontalMenu
        peblHorizontalMenu.delegate = self
        
        // Add Pages to Horizontal Menu Control
        for page in self.Pages{
            peblHorizontalMenu.addPage(sender: self, peblPage: page)
        }
        // Finalize Setup
        peblHorizontalMenu.setup()
        self.menuContainerView.addSubview(peblHorizontalMenu)
    
    }
    ///////////////////////////////////////////////////////////
    // Disable Below for Sliding/Scrolling Between Pages
    // Scrolling Needs to be Altered for Thumbnail Scrolls to Work as Well
    func disableScrollView(){
        // Disable Each Subview of Page VC from Scrolling
        for view in self.pageViewController.view.subviews{
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    ///////////////////////////////////////////////////////////
    // MARK: Delegate for Menu
    // Menu Communicates to Move to Page in Page View Controller
    internal func moveToPageIndex(sender: PeblHorizontalMenu, index:Int,completionHandler: @escaping (Bool)->()) {
        
        if index == self.currentIndex{
            return
        }
        var direction : UIPageViewControllerNavigationDirection!
        // Chose Animation Direction Based on Right or Left Movement
        if index>self.currentIndex{
            direction = UIPageViewControllerNavigationDirection.forward
        }
        else{
            direction = UIPageViewControllerNavigationDirection.reverse
        }
        
        print("Moving to Page at Index : \(index) from Current Index : \(self.currentIndex)")
        // Update Indices
        self.currentIndex = index
        pageViewController.currentIndex = index
        
        let newVC = self.getViewControllerAtCurrentIndex()
        var newVCList : [UIViewController] = []
        newVCList.append(newVC)
        
        // Set VieW Controllers With Completion
        pageViewController.setViewControllers(newVCList, direction: direction, animated: true, completion: {(complete) in
            if complete{
                completionHandler(true)
            }
        })
        
    }
    
    ///////////////////////////////////////////////////////////
    // MARK: Datasource for Page View Controller
    // Sets Up View Controllers for Page View Controller
    func setupPages(){
        
        // Setup View Controllers
        print("Implementing Page View Controllers for Page View Control")
        let messagePeblVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagePeblsViewController") as? MessagePeblsViewController
        let suggestionPeblVC = self.storyboard?.instantiateViewController(withIdentifier: "SuggestionPeblsViewController") as? SuggestionPeblsViewController
        
        // Create Page Objects and Add to Pages/Add to Menu
        let newPage1 = PeblPage(viewController: messagePeblVC!, index: 0, title: "Message Pebls")
        Pages.append(newPage1)
        let newPage2 = PeblPage(viewController: suggestionPeblVC!, index: 1, title: "Suggestion Pebls")
        Pages.append(newPage2)
        
        // Setup Page View Controller
        pageViewController.setup(Pages : Pages)
        
        return
    }
    
    ///////////////////////
    // Gets the View Controller in [ViewController] Corresponding to Index
    func getViewControllerAtCurrentIndex()->UIViewController{
        
        var foundViewController : UIViewController!
        for page in self.Pages{
            if page.index == self.currentIndex{
                foundViewController = page.viewController
            }
        }
        return foundViewController
    }
    ///////////////////////
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentIndex == 0 {
            return nil
        }
        // Decrement Index
        currentIndex = currentIndex-1
        return getViewControllerAtCurrentIndex()
    }
    ///////////////////////
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if currentIndex == self.Pages.count-1{
            return nil
        }
        // Decrement Index
        currentIndex = currentIndex+1
        return getViewControllerAtCurrentIndex()
    }
    //////////////////////
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.Pages.count
    }
    //////////////////////
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    ///////////////////////////////////////////
    // Performs Segue for Showing Popover Menu
    func menu_buttonToggle() {
        let baseVC = self.parent?.parent?.parent as! BaseViewController
        baseVC.toggleMenu()
    }

}

/////////////////////////////////////////////////////////////////////
class PeblHomeVCPageViewController: UIPageViewController {
    
    ///////////////////////
    // MARK: Properties
    var ViewControllers : [UIViewController] = []
    var currentIndex : Int = 0
    var Pages : [PeblPage] = []
    
    ///////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    ///////////////////////
    // Gets the View Controller in [ViewController] Corresponding to Index
    func getViewControllerAtCurrentIndex()->UIViewController{
        let foundViewController : UIViewController! = self.ViewControllers[self.currentIndex]
        return foundViewController
    }
    ///////////////////////
    // Sets Up Page View Controller with Different Pages
    func setup(Pages : [PeblPage]){
        
        self.Pages = Pages
        for page in self.Pages{
            self.ViewControllers.append(page.viewController)
        }
        
        // Default Behavior
        let initialVC = self.getViewControllerAtCurrentIndex()
        var initialVCList : [UIViewController] = []
        initialVCList.append(initialVC)
        self.setViewControllers(initialVCList, direction: .forward, animated: false, completion: nil)
    }
}







