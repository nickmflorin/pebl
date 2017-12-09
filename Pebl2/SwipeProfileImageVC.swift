//
//  MatchViewController.swift
//  Pebl
//
//  Created by Nick Florin on 7/14/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import Dispatch
import Firebase

class SwipeProfileImageVC: UIViewController {
    
    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var profileImage: UIImageView!
    var potentialMatch : PotentialMatch?
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.profileImage.contentMode
        self.setupProfile()
    }
    ///////////////////////////////////////////
    func setupProfile(){
    
        if self.potentialMatch != nil{
            self.profileImage.image = potentialMatch?.user?.userInfo?.profileImage
        }
    }
}

