//
//  ProfileImagePageViewController.swift
//  Pebl2
//
//  Created by Nick Florin on 1/17/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

/////////////////////////////////////////////////////////////////////
class ProfileImagePage: UIViewController {
    
    var image : UIImage!
    var imageView : UIImageView!
    var index : Int!
    
    var alphaViewAlpha : CGFloat!
    var alphaView : UIView!
    ///////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    ///////////////////////
    // Relayout Image View if Needed
    override func viewDidLayoutSubviews() {
        if self.view.subviews.count != 0{
            imageView.removeFromSuperview()
        }
        
        // Create Image View
        imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFill
        
        //self.image = self.cropImageToFit(image: self.image)
        imageView.image = self.image
        
        imageView.frame = self.view.bounds
        self.view.addSubview(imageView)
        
        //Create Shadow Alpha View for Image View
        alphaView = UIView(frame: self.imageView.frame)
        
        alphaView.backgroundColor = secondaryColor
        alphaView.alpha = self.alphaViewAlpha
        self.view.addSubview(alphaView)
        self.view.bringSubview(toFront: alphaView)
    }
    ///////////////////////
    // Crops Image to Fit Aspect Ratio of View
    func cropImageToFit(image:UIImage)->UIImage{
        
        let cgImage = image.cgImage
        let setWidth = self.imageView.bounds.width
        let setHeight = self.imageView.bounds.height
        let currentWidth = image.size.width
        let currentHeight = image.size.height
        
        // Scaling of Image for Aspect Ratio to Maintain
        let scale = max(setWidth/currentWidth,setHeight/currentHeight)
        var croppedImage : UIImage = image
        var toRect : CGRect?
        
        // Adjust Width of Image
        if scale*currentWidth < setWidth{
            let diff = (setHeight - scale*currentHeight)/scale
            let offset = 0.5*diff
            print("Adjusting Width With Difference : \(diff) by Offseting in X Direction \(offset)")
            toRect = CGRect(x: offset, y: 0.0, width: image.size.width - diff, height: image.size.height)
        }
            // Adjust Height of Image
        else if scale*currentHeight < setHeight{
            let diff = (setHeight - scale*currentHeight)/scale
            let offset = 0.5*diff
            print("Adjusting Height With Difference : \(diff) by Offseting in Y Direction \(offset)")
            toRect = CGRect(x: 0.0, y: offset, width: image.size.width, height: image.size.height - diff)
        }
        // Crop Image if Applicable
        if toRect != nil{
            let croppedCGImage: CGImage = cgImage!.cropping(to: toRect!)!
            croppedImage = UIImage(cgImage: croppedCGImage)
        }
        
        return croppedImage
    }
    ///////////////////////
    // Sets Up Page Item
    func setup(image:UIImage){
        
        self.image = image
        
        // Create Image View
        imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFill
        
        //self.image = self.cropImageToFit(image: self.image)
        imageView.image = self.image
        
        imageView.frame = self.view.bounds
        self.view.addSubview(imageView)
    }
}

/////////////////////////////////////////////////////////////////////
class ProfileImagePageViewController: UIPageViewController {
    
    ///////////////////////
    // MARK: Properties
    var ViewControllers : [ProfileImagePage] = []
    var currentIndex : Int = 0
    var Images : [UIImage] = []
    
    ///////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
