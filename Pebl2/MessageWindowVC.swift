//
//  MessageWindowVC.swift
//  Pebl
//
//  Created by Nick Florin on 9/20/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
///////////////////////////////////////////////////////////
// Create and Adds JSQ Messaging VC
//func add_jsq_messageVC(){
//    
//    // Ensure Necessary ID's are Present
//    if user_id != nil {
//        if match_user_id != nil{
//            // Move in Message VC View Controller
//            let messageVC = self.storyboard!.instantiateViewControllerWithIdentifier("JSQMessage") as! JSQMessageVC
//            messageVC.match_user_id = self.match_user_id
//            messageVC.senderId = user_id
//            messageVC.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName
//            
//            // Hardcoded Frame Alterations - Going to Have to Change Eventually - Couldn't Figure Out
//            // Consistent Way to Do It
//            // Set Dimensions and Frame of MessageVC so it Fits Properly
//            messageVC.view.frame = CGRect(x:self.messageView.frame.origin.x,y:self.messageView.frame.origin.y-115.0,width:self.messageView.frame.width-280.0,height:self.messageView.frame.height-28.0)
//            self.messageView.addSubview(messageVC.view)
//            self.addChildViewController(messageVC)
//            messageVC.didMoveToParentViewController(self)
//        }
//    }
//    else{
//        print("No Valid Usernames")
//        no_messages_view.alpha = 1.0
//    }
//}