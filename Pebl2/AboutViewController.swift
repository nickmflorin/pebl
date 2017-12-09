//
//  AboutViewController.swift
//  Pebl
//
//  Created by Nick Florin on 8/30/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    ///////////////////////////////////////////
    // MARK: Properties

    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Styling

    }
    ///////////////////////////////////////////
    // Performs Segue for Showing Popover Menu
    func menu_buttonToggle() {
        let baseVC = self.parent?.parent as! BaseViewController
        baseVC.toggleMenu()
    }
    ///////////////////////////////////////////
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

}
