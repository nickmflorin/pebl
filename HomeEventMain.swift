//
//  HomeEventMain.swift
//  Pebl2
//
//  Created by Nick Florin on 1/25/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//


import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

// Delegate to Allow Main View to Communicate with Table View
protocol HomeEventViewControllerDelegate {
}


///////////////////////////////////////////
class HomeEventViewController: UIViewController, HomeEventTableViewControllerDelegate{
    
    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var tableView : UITableView!
    var tableVC : HomeEventTableViewController!
    
    var ref: FIRDatabaseReference!
    var userID : String!
    
    var filterShowing : Bool = false
    var originalTableFrame : CGRect!
    var offsetTableFrame : CGRect!
    var filterHeightOffset : CGFloat = 120.0
    
    var delegate : HomeEventViewControllerDelegate?
    
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spinner.alpha = 0.0
        self.view.backgroundColor = UIColor.clear
        self.setupTableView()
    }
    ///////////////////////////////////////////
    override func viewDidLayoutSubviews() {
        self.originalTableFrame = self.containerView.frame
        self.offsetTableFrame = CGRect(x: self.originalTableFrame.minX, y: self.originalTableFrame.minY + self.filterHeightOffset, width: self.originalTableFrame.width, height: self.originalTableFrame.height - self.filterHeightOffset)
    }
    ///////////////////////////////////////////
    // Sets up the Table View for the events
    func setupTableView(){
        
        self.tableVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeEventTableViewController") as? HomeEventTableViewController
        self.tableVC.ref = self.ref
        self.tableVC.userID = self.userID
        
        self.tableVC.delegate = self
        self.tableVC.view.frame = self.containerView.bounds
        self.containerView.addSubview(self.tableVC.tableView!)
    }
    
    ///////////////////////////////////////////
    //MARK: HomeEventTableViewControllerDelegate
    
    internal func showSpinner(homeEventTableViewController: HomeEventTableViewController){
        self.spinner.alpha = 1.0
        self.spinner.startAnimating()
    }
    internal func hideSpinner(homeEventTableViewController: HomeEventTableViewController){
        self.spinner.alpha = 0.0
        self.spinner.stopAnimating()
    }
    
    ///////////////////////////////////////////
    // MARK: Actions

    @IBAction func filterButtonClicked(_ sender: AnyObject) {
        if self.filterShowing{
            UIView.animate(withDuration: 0.5, animations: {
                self.containerView.frame = self.originalTableFrame
            })
            self.filterShowing = false
        }
        else{
            UIView.animate(withDuration: 0.5, animations: {
                self.containerView.frame = self.offsetTableFrame
            })
            self.filterShowing = true
        }
        
    }

    @IBAction func menu_buttonToggle() {
        let baseVC = self.parent?.parent?.parent as! BaseViewController
        baseVC.toggleMenu()
    }
    
}
