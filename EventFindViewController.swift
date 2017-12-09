//
//  EventFindViewController.swift
//  Pebl2
//
//  Created by Nick Florin on 3/5/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

class EventFindViewController: UIViewController {
    
    //Mark : Properties

    
    class func instantiateFromStoryboard() -> EventFindViewController {
        let storyboard = UIStoryboard(name: "Base", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! EventFindViewController
    }
    
    //////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
    }

//    ///////////////////////////////////////////
//    // Mark : Actions
//    @IBAction func filterButtonClicked(_ sender: AnyObject) {
//        if self.filterShowing{
//            UIView.animate(withDuration: 0.5, animations: {
//                self.containerView.frame = self.originalTableFrame
//            })
//            self.filterShowing = false
//        }
//        else{
//            UIView.animate(withDuration: 0.5, animations: {
//                self.containerView.frame = self.offsetTableFrame
//            })
//            self.filterShowing = true
//        }
//        
//    }
}
