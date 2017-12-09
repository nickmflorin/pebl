//
//  EditProfileViewController.swift
//  Pebl
//
//  Created by Nick Florin on 11/13/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit

//////////////////////////////////////////////
class EditProfileDetailsVC: UIViewController {
    
    /////////////////////////////
    // Mark: Properties
    @IBOutlet weak var photoButton1: PhotoButton!
    @IBOutlet weak var photoButton2: PhotoButton!
    @IBOutlet weak var photoButton3: PhotoButton!
    @IBOutlet weak var photoButton4: PhotoButton!
    @IBOutlet weak var photoButton5: PhotoButton!
    @IBOutlet weak var photoButton6: PhotoButton!
    
    // Image View Containers
    @IBOutlet weak var upperImageView1: DraggableImageContainer!
    @IBOutlet weak var upperImageView2: DraggableImageContainer!
    @IBOutlet weak var upperImageView3: DraggableImageContainer!
    @IBOutlet weak var upperImageView4: DraggableImageContainer!
    @IBOutlet weak var upperImageView5: DraggableImageContainer!
    @IBOutlet weak var upperImageView6: DraggableImageContainer!
    
    var imageContainers : [DraggableImageContainer]!
    var photoButtons : [PhotoButton]!
    
    var floatingActive : Bool = false
    var floatingView : UIImageView?
    var floatingIdentifier : Int!
    var highlightedView : DraggableImageContainer?
    
    // Percentage of Image View Area that Needs to be Overlapped for Highlighting
    var overlapThreshold : CGFloat = 0.6
    
    @IBOutlet weak var originalAspect1: NSLayoutConstraint!
    @IBOutlet weak var originalWidth1: NSLayoutConstraint!
    
    var panningImageView : UIImageView!
    var panningUpperImageView : UIView!
    
    var currentUser : AuthUser?
    /////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageContainers = [upperImageView1, upperImageView2, upperImageView3,upperImageView4, upperImageView5, upperImageView6]
        self.photoButtons = [self.photoButton1,self.photoButton2,self.photoButton3,self.photoButton4,self.photoButton5,self.photoButton6]
        
        // Styling from Master Style
        self.styleMenu()
        self.navigationController?.styleTitle("Profile")

        // Get Current User from App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.currentUser = appDelegate.currentUser
        //self.loadImages()
    }
    //////////////////////////////////////////////////////////
    override func viewDidLayoutSubviews() {
        if self.floatingActive == false{
            self.loadImages()
        }
    }
    //////////////////////////////////////////////////////////
    // Retrieves User Images
    func loadImages(){
        
        // Test Images Just for Development Purposes
        let testImages : [UIImage] = [UIImage(named:"DummyProf1")!,UIImage(named:"DummyProf2")!,UIImage(named:"DummyProf3")!,UIImage(named:"DummyProf4")!]
        
        for i in 0...imageContainers.count-1{
            
            let imageContainer = self.imageContainers[i] as DraggableImageContainer
            if i == 0{
                // First Image Container is Larger
                imageContainer.expandedContainer = true
            }
            let addRemoveButton = self.photoButtons[i]
            var image = UIImage(named:"MissingPhotoImage")
            
            if i<=testImages.count-1{
                image = testImages[i]
                // These Images Are Available - Mark with Remove Button
                addRemoveButton.isAddButton = false
                addRemoveButton.isRemoveButton = true
            }
            else{
                // These Images Are Available - Mark with Remove Button
                addRemoveButton.isAddButton = true
                addRemoveButton.isRemoveButton = false
            }
            
            // Attach Custom Draggable Image View to Container
            imageContainer.attachImage(image: image!)
        }
        
    }
    //////////////////////////////////////////////////////////
    // Called During Panning - Detects Intersections Between Floating Image View an Other Image Views
    // Determines if Any Intersected Area Higher than Threshold and Highlights Maximum Overlapped Area Image View
    func detectInterSections()->Bool{
        
        var overlapViews : [DraggableImageContainer] = []
        var overlapAreas : [CGFloat] = []
        var intersectDetected : Bool = false
        
        if self.floatingView != nil{
            let floatingRect : CGRect = self.floatingView!.frame
            
            ////////// Loop Over Drag Containers - Add Overlap Area if Over Threshold
            for container in self.imageContainers{
                
                ///////// Only Check Intersections of Containers That Don't Hold Floating View
                if container.imageView != self.floatingView{
                    let imageView = container.imageView as DraggableImageView
                    let containerView = imageView.superview as! DraggableImageContainer
                    let localRect = self.view.convert(containerView.frame, to: self.view)
                    
                    if floatingRect.intersects(localRect) {
                        let overArea : CGFloat = overlapArea(rect1: floatingRect,rect2: localRect)
                        if overArea >= self.overlapThreshold {
                            
                            overlapViews.append(containerView)
                            overlapAreas.append(overArea)
                        }
                    }
                }
                // Note Return Value of True for Interscetion
                if overlapViews.count != 0 {
                    intersectDetected = true
                }
            }
            self.determineOverlappedView(overlapAreas: overlapAreas,overlapViews: overlapViews)
        }
        return intersectDetected
    }
    ///////////////////////////////////////////////////
    ///  Find Biggest Overlap Area View
    func determineOverlappedView(overlapAreas:[CGFloat],overlapViews:[DraggableImageContainer]){
        if overlapAreas.count != 0 {
            
            var maxAreaView : DraggableImageContainer!
            var maxArea : CGFloat = 0.0
            for i in 0...overlapAreas.count-1{
                
                let area : CGFloat = overlapAreas[i] 
                let view : DraggableImageContainer = overlapViews[i] 
                if area >= maxArea{
                    maxArea = area
                    maxAreaView = view
                }
            }
            self.highlightFocusView(view: maxAreaView)
        }
        else{
            self.removeHighlightFocusView()
        }
    }
    ///////////////////////////////////////////////////
    // Removes Highlighting for Previously Highlighted Container View and Adds Highlighting to Current Overlapped View
    func highlightFocusView(view:DraggableImageContainer){
        self.removeHighlightFocusView()
        self.highlightedView = view
        view.layer.borderColor = UIColor.red.cgColor
    }
    ///////////////////////////////////////////////////
    // Removes Highlighting for Previously Highlighted Container
    func removeHighlightFocusView(){
        // Highlight Max Area Overlap
        if self.highlightedView != nil{
            // Remove Previous Highlighting
            self.highlightedView?.layer.borderColor = UIColor.clear.cgColor
        }
    }
    ///////////////////////////////////////////
    // Performs Segue for Showing Popover Menu
    func menu_buttonToggle() {
        let baseVC = self.parent?.parent?.parent as! BaseViewController
        baseVC.toggleMenu()
    }
    ///////////////////////////////////////////
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }


}
