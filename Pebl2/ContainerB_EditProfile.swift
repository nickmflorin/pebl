//
//  ContainerB.swift
//  Pebl
//
//  Created by Nick Florin on 8/7/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

///////////////////////////////////////////
// Container for Profile View for Editing Profile Attributes
///////////////////////////////////////////
class ContainerB_EditProfile: UIViewController {
    
    ///////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var ageField: UILabel!
    @IBOutlet weak var first_nameField: UILabel!
    
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var educationField: UILabel!
    
    @IBOutlet weak var careerField: UILabel!
    @IBOutlet weak var careerLabel: UILabel!
    
    @IBOutlet weak var hobbiesField: UILabel!
    @IBOutlet weak var hobbiesLabel: UILabel!
    
    @IBOutlet weak var about_meField: UILabel!
    @IBOutlet weak var about_meLabel: UILabel!
    
    @IBOutlet weak var editCareer: UIButton!
    @IBOutlet weak var editEducation: UIButton!
    @IBOutlet weak var editHobbies: UIButton!
    @IBOutlet weak var editAboutMe: UIButton!
    
    var edit_modalView : EditModalVC?
    var user_info_item : UserInfo?
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Listeners for Listen for Edit Modal Close
        //NotificationCenter.default.addObserver(self, selector: #selector(ContainerB_EditProfile.closeEditTab(_:)),name:NSNotification.Name(rawValue: "close_edit_tab"), object: nil)
        
        self.style()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.load_user_info()
    }
    /////////////////////////////////////////////////////////
    func style(){
        self.ageField.textColor = red
        self.first_nameField.textColor = red
        
        self.about_meField.textColor = UIColor.white
        self.careerField.textColor = UIColor.white
        self.hobbiesField.textColor = UIColor.white
        self.educationField.textColor = UIColor.white

        self.hobbiesLabel.textColor = UIColor.white
        self.about_meLabel.textColor = UIColor.white
        self.careerLabel.textColor = UIColor.white
        self.educationLabel.textColor = UIColor.white
        
        self.editCareer.tintColor = UIColor.white
        self.editEducation.tintColor = UIColor.white
        self.editHobbies.tintColor = UIColor.white
        self.editAboutMe.tintColor = UIColor.white
    }
    ///////////////////////////////////////////////////////////
    // Gets User Info from Firebase and Populates Fields
    func load_user_info(){

        // Make Sure Individual Items Aren't Nil Before Setting Text Fields
        if user_info_item != nil {
//            if user_info_item!.aboutMe != nil{
//                about_meField.text = user_info_item!.aboutMe
//            }
////            if user_info_item!.hobbies != nil{
////                hobbiesField.text = user_info_item!.hobbies
////            }
//            if user_info_item!.age != nil{
//                ageField.text = String(describing: user_info_item!.age)
//            }
//            if user_info_item!.first_name != nil{
//                first_nameField.text = user_info_item!.first_name
//            }
//            if user_info_item!.career != nil{
//                careerField.text = user_info_item!.career
//            }
//            if user_info_item!.education != nil{
//                educationField.text = user_info_item!.education
//            }
        }
    }
    ///////////////////////////////////////////
    // Mark: Actions
    ///////////////////////////////////////////
    // Close Edit Modal Window - Called from EditModalVC Button (Separate File/View Controller)
    func closeEditTab(_ notification: Notification){
        self.edit_modalView?.view.removeFromSuperview()
    }
    ///////////////////////////////////////////
    // Present Modal for Editing Career Section
    @IBAction func editCareer(_ sender: AnyObject) {
        // Show Modal to Edit Property
        let storyBoard = UIStoryboard(name: "EditModal", bundle:nil) as UIStoryboard
        self.edit_modalView = storyBoard.instantiateViewController(withIdentifier: "EditModal") as? EditModalVC
        self.edit_modalView!.edit_type = "Career"
        
        // Set Modal Presentation
        self.edit_modalView!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        // Setting Frame
        self.edit_modalView!.view.frame.origin.x = self.view.frame.origin.x + self.view.frame.width/2 - self.edit_modalView!.view.frame.width/2
        self.edit_modalView!.view.frame.origin.y = self.view.frame.origin.y + self.view.frame.height/2 - self.edit_modalView!.view.frame.height/2
        
        // Setting Popover Delegate
        self.edit_modalView!.popoverPresentationController?.sourceView = view
        self.edit_modalView!.popoverPresentationController?.sourceRect = sender.frame
        
        self.view.addSubview(self.edit_modalView!.view)
    }
    ///////////////////////////////////////////
    // Present Modal for Editing Education Section
    @IBAction func editEducation(_ sender: AnyObject) {
        
        // Show Modal to Edit Property
        let storyBoard = UIStoryboard(name: "EditModal", bundle:nil) as UIStoryboard
        self.edit_modalView = storyBoard.instantiateViewController(withIdentifier: "EditModal") as? EditModalVC
        self.edit_modalView!.edit_type = "Education"
        
        // Set Modal Presentation
        self.edit_modalView!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        // Setting Frame
        self.edit_modalView!.view.frame.origin.x = self.view.frame.origin.x + self.view.frame.width/2 - self.edit_modalView!.view.frame.width/2
        self.edit_modalView!.view.frame.origin.y = self.view.frame.origin.y + self.view.frame.height/2 - self.edit_modalView!.view.frame.height/2
        
        // Setting Popover Delegate
        self.edit_modalView!.popoverPresentationController?.sourceView = view
        self.edit_modalView!.popoverPresentationController?.sourceRect = sender.frame
        
        self.view.addSubview(self.edit_modalView!.view)
    }
    ///////////////////////////////////////////
    // Present Modal for Editing Hobbies Section
    @IBAction func editHobbies(_ sender: AnyObject) {
        // Show Modal to Edit Property
        let storyBoard = UIStoryboard(name: "EditModal", bundle:nil) as UIStoryboard
        self.edit_modalView = storyBoard.instantiateViewController(withIdentifier: "EditModal") as? EditModalVC
        self.edit_modalView!.edit_type = "Hobbies"
        
        // Set Modal Presentation
        self.edit_modalView!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        // Setting Frame
        self.edit_modalView!.view.frame.origin.x = self.view.frame.origin.x + self.view.frame.width/2 - self.edit_modalView!.view.frame.width/2
        self.edit_modalView!.view.frame.origin.y = self.view.frame.origin.y + self.view.frame.height/2 - self.edit_modalView!.view.frame.height/2
        
        // Setting Popover Delegate
        self.edit_modalView!.popoverPresentationController?.sourceView = view
        self.edit_modalView!.popoverPresentationController?.sourceRect = sender.frame
        
        self.view.addSubview(self.edit_modalView!.view)
    }
    ///////////////////////////////////////////
    // Present Modal for Editing About Me Section
    @IBAction func editAboutMe(_ sender: AnyObject) {
        
        // Show Modal to Edit Property
        let storyBoard = UIStoryboard(name: "EditModal", bundle:nil) as UIStoryboard
        self.edit_modalView = storyBoard.instantiateViewController(withIdentifier: "EditModal") as? EditModalVC
        self.edit_modalView!.edit_type = "About Me"
        
        // Set Modal Presentation
        self.edit_modalView!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        // Setting Frame
        self.edit_modalView!.view.frame.origin.x = self.view.frame.origin.x + self.view.frame.width/2 - self.edit_modalView!.view.frame.width/2
        self.edit_modalView!.view.frame.origin.y = self.view.frame.origin.y + self.view.frame.height/2 - self.edit_modalView!.view.frame.height/2
        
        // Setting Popover Delegate
        self.edit_modalView!.popoverPresentationController?.sourceView = view
        self.edit_modalView!.popoverPresentationController?.sourceRect = sender.frame
        
        self.view.addSubview(self.edit_modalView!.view)
        
    }
}
