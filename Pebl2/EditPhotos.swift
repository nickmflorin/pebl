//
//  PhotoEditProfileVC.swift
//  Pebl
//
//  Created by Nick Florin on 8/14/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage

class PhotoEditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var photoCount: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    @IBOutlet weak var setProfilePicView: UIView!
    @IBOutlet weak var deletePhotoView: UIView!
    
    @IBOutlet weak var setProfilePicButton: UIButton!
    @IBOutlet weak var deletePhotoButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var contentImages : [UIImage] = []
    @IBOutlet weak var photoSlideContainer: UIView!
    
    let image_names :[String] = ["profile_image","image1","image2","image3","image4"]

    // Photo Tracking
    let max_photos = 5
    var photo_counts : [String] = ["1/1"]
    var num_photos : Int = 0
    var current_index = 0
    
    var spinner : loadingIndicator!
    var ref: FIRDatabaseReference!
    var storageRef:FIRStorageReference!
    ///////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        self.storageRef = FIRStorage.storage().reference()
        imagePicker.delegate = self
        
        // Activity Indicator
        spinner = loadingIndicator(targetView: self.view)
        self.view.addSubview(spinner)
        self.view.bringSubview(toFront: spinner)
        
        // Getting Info
        self.load_user_photos()
        
        // Styling
        self.style()
    
    }
    /////////////////////////////////////
    lazy var user_images:NSMutableDictionary = {
        var user_image_dic : NSMutableDictionary = NSMutableDictionary()
        return user_image_dic
    }()
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Styling
    func style(){
        
        let menu_image = UIImage(named: "MenuButton")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        // Remove Menu Button Title
        menuButton.title = ""
        let new_image = menu_image.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0))
        // Remove Bar Button Item Image
        menuButton.setBackgroundImage(new_image, for: UIControlState(), barMetrics: UIBarMetrics.default)
        
        photoSlideContainer.layer.borderWidth = 1
        photoSlideContainer.layer.borderColor = dark_blue.cgColor
        photoSlideContainer.backgroundColor = text_background_color
        photoSlideContainer.layer.cornerRadius = 5.0
        photoSlideContainer.layer.masksToBounds = true
        
        // Styling Buttons for Deleting Image and Setting Profile Picture
        let buttons = [setProfilePicButton,deletePhotoButton]
        for button in buttons{
            self.setProfilePicView.sendSubview(toBack: button!)
            button?.setBackgroundColor(green, forState: UIControlState())
            button?.setBackgroundColor(light_gray, forState: UIControlState.focused)
            button?.layer.cornerRadius = 1.0
            button?.layer.borderColor = dark_blue.cgColor
            button?.layer.borderWidth = 1.0
            button?.setTitleColor(UIColor.white, for: UIControlState.focused)
            button?.setTitleColor(UIColor.white, for: UIControlState())
        }
    }
    ///////////////////////////////////////////////////////////
    func create_add_button()->UIButton{
        // Create Add Photo Button
        let button = UIButton(type: UIButtonType.custom)
        
        button.backgroundColor = UIColorFromRGB(0x9CBA7F)
        button.setBackgroundColor(UIColor.white, forState: UIControlState.highlighted)
        
        button.setTitleColor(UIColor.black, for: UIControlState.highlighted)
        button.layer.cornerRadius = 3.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        
        button.setTitle("Add Photo", for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.titleLabel?.font = UIFont(name: font_name, size:10)
        
        let button_width = CGFloat(100)
        let button_height = CGFloat(20)
        
        let button_xp = (self.photoSlideContainer!.frame.size.width-button_width)/2
        let button_yp = (self.photoSlideContainer!.frame.size.height-button_height)/2
        
        button.frame = CGRect(x: button_xp, y: button_yp, width: button_width, height: button_height);
        return button
    }
    ///////////////////////////////////////////////////////////
    func create_photo_count_list(){
        // Regenerate Photo Count List
        var photo_count : [String] = []
        let den = String(self.num_photos+1)
        
        // Allow Count to go 1 More Than Number of Photos - Last Page is for Add Photo Button
        for i in 1...self.num_photos+1{
            let num = String(i)
            photo_count.append(num+"/"+den)
        }
        self.photo_counts = photo_count
    }
    ///////////////////////////////////////////////////////////
    // Checks to See if Profile Photo ID Exists and Calls Download if It Does
    func load_user_photos(){
        
        // Initially Start with 0 Photos
        self.num_photos = 0
        
        // Get Current User UID from Firebase Auth
        let userID = FIRAuth.auth()?.currentUser?.uid
        if userID != nil{
            // Try Fetching All Core Data Photos and Checking 1 by 1
            
            // Get Photo IDS from Firebase Data
            self.ref.child("user_images").child(userID!).observe(FIRDataEventType.value, with: { (snapshot) in
                
                /////////////////////////
                // Case When Photos Exist
                if snapshot.exists(){
                    
                    /////////////////////////
                    // Error Case When User Has Photo IDS but No Profile Image
                    if snapshot.hasChild("profile_image"){

                        // Iterate Through Photo IDS and Retrieve Each
                        for i in 0...self.image_names.count-1 {
                            
                            let name = self.image_names[i]
                            
                            if snapshot.hasChild(name){
                                print("Asynchronously Retrieving Photo : \(name)")
                                
                                // Retrieve Photo Asynchronously
                                DispatchQueue.main.async(execute: {
                                    if let dataDict = snapshot.value as? NSDictionary{
                                        retrieve_photo(userID!,photo_id:dataDict[name] as! String, photoHandler: {(image) -> Void in
                                            //if let unwrapped_image = image{
                                                
                                                self.user_images[name] = image
                                                // Increment Photo Count
                                                self.num_photos = self.num_photos + 1
                                                self.create_photo_count_list()
                                                self.photoCount.text = self.photo_counts[self.current_index]
                                                
                                                // If Name = ProfileImage - Put In Container Immediately
                                                if name == "profile_image"{
                                                    print("Fix This")
                                                    //self.add_photo_to_container(uiimage: image!)
                                                }
                                            //}
                                        }) // End Retrieve Photo Function
                                    }
                                }) // End Dispatch Async
                            }
                        } // End Loop
                    }
                    else{
                        print("Error : User Has Photo ID's but No Designated Profile Image")
                        // Set Photo Slide Container to Add Button
                        self.add_button_to_container()
                    }

                }
                /////////////////////////
                // Case When No Photos Exist
                else{
                    print("User : \(userID) Does Not Have Any Photo IDs Stored in Firebase")
                    // Set Photo Slide Container to Add Button
                    self.add_button_to_container()
                    self.create_photo_count_list()
                    self.photoCount.text = self.photo_counts[self.current_index]
                    
                }
            })
        }
        else{
            print("User ID is Nil")
        }
    }
    ///////////////////////////////////////////////////////////
    func add_button_to_container(){
        // Remove Photo or Button If Present
        if self.photoSlideContainer.subviews.count != 0{
            self.photoSlideContainer.subviews[0].removeFromSuperview()
        }
        let add_button = self.create_add_button()
        //add_button.addTarget(self, action: #selector(PhotoEditProfileVC.add_photo(_:)), for:.TouchUpInside)
        self.photoSlideContainer.addSubview(add_button)
    }
    ///////////////////////////////////////////////////////////
    // Populates Container View With UIImage
    func add_photo_to_container(_ uiimage:UIImage){
        
        // Remove Photo or Button If Present
        if self.photoSlideContainer.subviews.count != 0{
            self.photoSlideContainer.subviews[0].removeFromSuperview()
        }
        // Create Image View and Put UIImage in Image View
        let imageView = UIImageView(image: uiimage)
        imageView.frame = self.photoSlideContainer.bounds
        self.photoSlideContainer.addSubview(imageView)
        
    }

    ///////////////////////////////////////////////////////////
    // MARK: Actions
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Adding/Deleting Photos
    // Function called when Add Photo button clicked
    @IBAction func add_photo(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        //present(imagePicker, animated: true, completion: nil)
    }
    /////////////////////////////////////////////////////////
    //Function called when user selects a photo from the camera roll
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let uiimage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //Resize UIImage for More Compact Storage
            let new_uiimage = resizeImage(uiimage, newWidth: 350)
            
//            // Save UIImage to Local Directory for Upload After
//            let pngImageData = UIImagePNGRepresentation(new_uiimage)
//            
//            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//            let documentsDirectory = paths[0]
//            let photoPath = documentsDirectory+"/"+"temp"
//            let imageURLNSURL.init(fileURLWithPath: photoPath)
//            let result = (try? pngImageData!.write(to: URL(fileURLWithPath: photoPath), options: [.atomic])) != nil
//            
//            //self.dismiss(animated: true, completion: nil)
//            
//            ///////////////////////////////////////////////////////////
//            // Uploading Image and Photo ID to Firebase
//            self.spinner.startSpinning("Uploading Image")
//            let userID = FIRAuth.auth()?.currentUser?.uid
//            print("Adding Image for : \(userID)")
//            
//            self.ref.child("user_images").child(userID!).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
//                
//                let photo_id = randomStringWithLength(5) as String
//                let filePath = photo_id
//                //let filePath = user_id + "_" + photo_id
//                
//                // Check to Make Sure User Doesn't Exceed Max Number of Photos
//                let fb_num_photos = Int(snapshot.childrenCount)
//                if fb_num_photos > 4 {
//                    print("Error Uploading : User Already Has Max Number of Allowed Photos")
//                    return
//                }
//                else{
//                    ///////////////////// Uploading Image File //////////////////////////////
//                    self.storageRef.child(filePath)
//                        .putFile(imageURL, metadata: nil) { (metadata, error) in
//                            
//                            //////////////// Error Uploading ////////////////////////
//                            if let error = error {
//                                print("Error Uploading Image: \(error)")
//                                return
//                            }
//                            ////////// Successful Uploading - Upload Photo ID ////////
//                            else{
//                                
//                                print("Successfully Uploaded Image")
//                                
//                                // Increment Photo Count and Index
//                                self.num_photos = self.num_photos + 1
//                                //self.current_index = self.current_index + 1
//                                
//                                // Recreate Photo Count List
//                                self.create_photo_count_list()
//                                
//                                // Add Image from Array
//                                let name = self.image_names[fb_num_photos]
//                                self.user_images[name] = new_uiimage
//                                
//                                // Set Photo Count Label
//                                self.photoCount.text = self.photo_counts[self.current_index]
//                                
//                                // Add Photo to Container
//                                self.add_photo_to_container(new_uiimage)
//                                
//                                // Save Photo ID to Firebase
//                                let post = [name: photo_id]
//                                self.ref.child("user_images").child(userID!).updateChildValues(post)
//                                self.spinner.stopSpinning()
//                            }
//                    }
//                } // End of Else Case for When Max Photos Not Exceeded
//            }) // End of observeSingleEventofType
        }
    }

    ///////////////////////////////////////////
    // Removes Current Photo in Slider from Storage
    @IBAction func deletePhoto(_ sender: AnyObject) {

        let name = self.image_names[self.current_index]
        let image = self.user_images[name] as! UIImage
        
        // Get Current User UID from Firebase Auth
        let userID = FIRAuth.auth()?.currentUser?.uid
        print("Removing Image for : \(userID)")
        
        ////////////////////////////////////////////////////////////
        if userID != nil{
            self.ref.child("user_images").child(userID!).observe(FIRDataEventType.value, with: { (snapshot) in
                
                ////////////////////////////////////////////////////////////
                if snapshot.hasChild(name){

                    self.ref.child("user_images").child(userID!).child(name).removeValue()
                    
                    // Decrease Number of Photos in Count and Regenerate Photo Count Tracking List
                    // If Profile Image Deleted - Don't Decrease Current Index (It Would Be -1)
                    if name == "profile_image" {
                        self.current_index = 0
                    }
                    else{
                        self.current_index = self.current_index - 1
                    }
                    // Decrement Number of Photos
                    self.num_photos = self.num_photos - 1
                    // Recreate Photo Count List
                    self.create_photo_count_list()
                    // Remove Image from Array
                    //self.user_images.removeObject(forKey: name)
                    
                    // Set Photo Count Label
                    self.photoCount.text = self.photo_counts[self.current_index]
                    
                    // Add Photo to Container
                    let new_name = self.image_names[self.current_index]
                    let new_uiimage = self.user_images[new_name] as! UIImage
                    self.add_photo_to_container(new_uiimage)
                    
                }
                else{
                    print("User Does Not Have a Photo ID With Designation \(name)")
                }
                
            })
            { (error) in
                print("Error Removing Image")
                print(error.localizedDescription)
            }
        }
        else{
            print("User ID is Nil")
        }
        
        // Need to Add Step Where Actual Image (Not Just Photo ID) Is Delete from Firebase Storage
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Viewing Photos and Setting Profile Pic
    
    
    ///////////////////////////////////////////
    // Sets Current Photo in Slider to Profile Pic
    @IBAction func setProfilePic(_ sender: AnyObject) {
        print("Setting Current Image as Profile Image", terminator: "")
    }
    ///////////////////////////////////////////////////////////
    // User Presses Next Image Button - Buttons Will Later Be Replaced With Swipes
    @IBAction func nextButton(_ sender: AnyObject) {
        
        // Can't Go Further Right - Rightmost View is View to Add Photo
        if self.current_index == self.num_photos {
            return
        }
        // Can't Go Further Right - Max Images but Can Add Button to Add Photo
        else if self.current_index == self.num_photos-1{
            
            // Increment Index Count
            self.current_index = self.current_index + 1
            // Set Photo Count Label
            self.photoCount.text = self.photo_counts[self.current_index]
            
            // Make Next View the Add Button View
            self.add_button_to_container()
        
            return
        }
        // Else, Additional Photos to Right
        else{
            // Increment Index Count
            self.current_index = self.current_index + 1
            // Set Photo Count Label
            self.photoCount.text = self.photo_counts[self.current_index]
            
            // Set Image
            let name = self.image_names[self.current_index]
            let image = self.user_images[name] as! UIImage
            
            // Put Photo in Container
            self.add_photo_to_container(image)
            return
        }
    }
    ///////////////////////////////////////////////////////////
    // User Presses Previous Image Button - Buttons Will Later Be Replaced With Swipes
    @IBAction func previousButton(_ sender: AnyObject) {
        
        if self.current_index == 0{
            // Can't Go Further Left
            return
        }

        // Decrement Index Count
        self.current_index = self.current_index - 1
        // Set Photo Count Label
        self.photoCount.text = self.photo_counts[self.current_index]
        
        // Set Image
        let name = self.image_names[self.current_index]
        let image = self.user_images[name] as! UIImage
        
        // Put Photo in Container
        self.add_photo_to_container(image)
    }
    
    
    
    ///////////////////////////////////////////
    // Performs Segue for Showing Popover Menu
    @IBAction func menu_buttonToggle(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "menu_popoverSegue", sender: self)
    }
    ///////////////////////////////////////////
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "menu_popoverSegue" {
//            let popoverViewController = segue.destination as! MenuTableVC
//            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
//            popoverViewController.popoverPresentationController!.delegate = self
//        }
    }
    ///////////////////////////////////////////////////////////
    ///// Tab Bar Styling
    required init?(coder aDecoder: NSCoder) {


        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Photo
        let tab_image =  UIImage(named: "PhotoIcon")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let size = CGSize(width: tab_image.size.width / 5, height: tab_image.size.height / 5)
        
        ///// Setting Image of Tab Item - Resizing Image to Fit
        var scaledImageRect = CGRect.zero;
        
        let aspectWidth:CGFloat = size.width / size.width;
        let aspectHeight:CGFloat = size.height / size.height;
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight);
        
        scaledImageRect.size.width = size.width * aspectRatio;
        scaledImageRect.size.height = size.height * aspectRatio;
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        
        tab_image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        // Rendering and Scaling Image
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        let rendered_scaledImage = scaledImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        tabBarItem = UITabBarItem(title: "Photos", image: rendered_scaledImage, tag: 2)
    }
    ///////////////////////////////////////////
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    ///////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
