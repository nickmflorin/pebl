//
//  SwipeModels.swift
//  Pebl
//
//  Created by Nick Florin on 11/6/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


////////////////////////////////////////
class PotentialMatch: NSObject {
    
    var userID: String?
    var viewDate : Date?
    var user : User?
    
    var viewed : Bool?
    
    ///////////////////////////////////////
    init(userID: String) {
        self.userID = userID
    }
    ///////////////////////////////////////
    convenience override init() {
        self.init(userID:  "")
    }
}

