//
//  EventCategoryTabView.swift
//  Pebl2
//
//  Created by Nick Florin on 2/21/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

//////////////////////////////
enum EventCategoryImageName : String {
    
    case Restaurant = "RestaurantCategoryIcon"
    case Bar = "BarCategoryIcon"
    case Art = "ArtCategoryIcon"
    case Entertainment = "EntertainmentCategoryIcon"
    case Coffee = "CoffeeCategoryIcon"
    case Outdoor = "OutdoorCategoryIcon"
}

//////////////////////////////
enum EventCategoryType {
    
    case Restaurant
    case Bar
    case Art
    case Entertainment
    case Coffee
    case Outdoor
}

//////////////////////////////
class EventCategory : NSObject {
    
    var imageName : String!
    var image : UIImage!
    var type : EventCategoryType
    
    // Required Initialization
    required init(type:EventCategoryType) {
        self.type = type
        
        // Determine Image Type from Enumeration
        switch self.type {
            case .Restaurant: self.imageName = EventCategoryImageName.Restaurant.rawValue
            case .Bar: self.imageName = EventCategoryImageName.Bar.rawValue
            case .Art: self.imageName = EventCategoryImageName.Art.rawValue
            case .Entertainment: self.imageName = EventCategoryImageName.Entertainment.rawValue
            case .Coffee: self.imageName = EventCategoryImageName.Coffee.rawValue
            case .Outdoor: self.imageName = EventCategoryImageName.Outdoor.rawValue
            
            default: (self.imageName = EventCategoryImageName.Restaurant.rawValue)
        }
        // Generate UIImage
        self.image = UIImage(named:self.imageName)!
    }
}
//////////////////////////////
protocol EventCategoryDelegate {
    func categorySelected(eventCategoryTabButton:EventCategoryTabButton)
}
//////////////////////////////
class EventCategoryTabButton : UIView {
    
    var backgroundC : UIColor!
    var image : UIImage!
    var button : UIButton!
    
    var buttonColor : UIColor = secondaryColor
    var buttonInset : CGFloat = 6.0
    var additionalBottomYPadding : CGFloat = 5.0 // Make Space for Underlying
    
    var underlineColor : UIColor = secondaryColor
    var underlineLayer : CAShapeLayer!
    var underlinePath : UIBezierPath!
    var underlineHorizontalMargin : CGFloat = 3.0
    var underlineLineWidth : CGFloat = 3.0
    
    var delegate : EventCategoryDelegate?
   
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.button = UIButton(type: .custom)
        self.backgroundColor = backgroundC
    }
    /////////////////////////////////////
    // Draw the Tab Button View Item
    func create(image:UIImage){
        
        // Recolor Image ////////////////
        self.image = image.imageWithColor(color:buttonColor)
        
        // Create Frame and Set Button Image
        let buttonFrame : CGRect = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.bounds.width, height: self.bounds.height - self.additionalBottomYPadding)
        
        // Determine Button Frame After Setting Image Aspect Fit
        self.button.imageView?.contentMode = .scaleAspectFit
        self.button.setImage(self.image, for: .normal)
        self.button.contentEdgeInsets = UIEdgeInsets(top: buttonInset, left: buttonInset, bottom: buttonInset, right: buttonInset)
        self.button.frame = buttonFrame
        
        // Add Button Target
        self.button.addTarget(self, action: #selector(self.tellDelegateSelected), for: UIControlEvents.touchDown)
        self.addSubview(self.button)
        
        // Draw Underline ////////////////
        self.underlineLayer = CAShapeLayer()
        self.underlinePath = UIBezierPath()
        
        var centerY = 0.5*(self.bounds.maxY - self.button.frame.maxY) + self.button.frame.maxY // Position halfway between bottom of button and bottom of view
        var currentPoint : CGPoint = CGPoint(x: self.bounds.minX+underlineHorizontalMargin, y: centerY)
        self.underlinePath.move(to: currentPoint)
        
        // Move to Right Side
        currentPoint = CGPoint(x: self.bounds.maxX-underlineHorizontalMargin, y: centerY)
        self.underlinePath.addLine(to: currentPoint)
        
        self.underlineLayer.strokeColor = nil // Default
        self.underlineLayer.fillColor = nil
        self.underlineLayer.lineWidth = underlineLineWidth
        
        self.underlineLayer.path = self.underlinePath.cgPath
        self.layer.addSublayer(self.underlineLayer)
        
    }
    // Communicates to Delegate That Selection Occured when Button is Clicked
    func tellDelegateSelected(){
        self.delegate?.categorySelected(eventCategoryTabButton: self)
    }
    // Functions to Toggle Active vs. Inactive States
    func activate(){
        self.underlineLayer.strokeColor = underlineColor.cgColor
    }
    func deactivate(){
        self.underlineLayer.strokeColor = nil
    }
    /////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//////////////////////////////
class EventCategoryTabView: UIView, EventCategoryDelegate{
    
    var buttonColor : UIColor = secondaryColor
    var backgroundC : UIColor = UIColorFromRGB(0xFBFCFE)
    
    var buttonHorizontalPadding : CGFloat = 6.0
    
    var eventCategories : [EventCategory] = []
    var eventCategoryTypes : [EventCategoryType] = [EventCategoryType.Restaurant, EventCategoryType.Bar, EventCategoryType.Art,
                                                    EventCategoryType.Coffee, EventCategoryType.Entertainment, EventCategoryType.Outdoor]
    // Store Tab Button Items
    var eventCategoryTabButtons : [EventCategoryTabButton] = []
    
    //// Init from Coder
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.backgroundColor = backgroundC
        
        // Create Images and Category Objects for Each Category Type
        for type in self.eventCategoryTypes{
            let newEventCategory = EventCategory(type:type) // Initialize New Category
            self.eventCategories.append(newEventCategory)
            
        }        
    }
    /////////////////////////////
    // Creates Icon for Each Category Type - Wait for subviews to be laid out before calling this.
    func setup() {
        
        // Create Item Frames
        let numItems = self.eventCategories.count + 1 // Account for Home Tab

        let availableSpace = self.bounds.width - (self.buttonHorizontalPadding * CGFloat(numItems+1))
        let singleItemWidth = availableSpace / CGFloat(numItems)
        
        var itemFrames : [CGRect] = []
        var minX : CGFloat = buttonHorizontalPadding
        
        // Create Home Tab at Half Way Point
        for _ in 0...numItems{
            
            let newFrame = CGRect(x: minX, y: self.bounds.minY, width: singleItemWidth, height: self.bounds.height)
            itemFrames.append(newFrame)
            
            // Update Left Starting Point
            minX = minX + singleItemWidth + buttonHorizontalPadding
        }
        
        // Create Tab Items /////////////////////
        var manualCount : Int = 0 // Used to choose frame, doesn't freeze at halfway point
        for i in 0...self.eventCategories.count - 1 {
            
            // Create Home Icon Halfway Through
            let numItemsDouble : Double = Double(numItems)
            if i == Int(floor(numItemsDouble*0.5)) {
                
                let homeImage = UIImage(named:"HomeIcon")
                let homeItem = EventCategoryTabButton(frame:itemFrames[manualCount])
                homeItem.create(image: homeImage!)
                homeItem.delegate = self
                
                // Default is Activate Home Item
                homeItem.activate()
                
                self.eventCategoryTabButtons.append(homeItem)
                self.addSubview(homeItem)
                
                // Manually Increment
                manualCount = manualCount + 1
                
            }
           
            // Set Frame and Add Subview
            let newItem = EventCategoryTabButton(frame:itemFrames[manualCount])
            newItem.delegate = self
            newItem.create(image: self.eventCategories[i].image)
            
            self.eventCategoryTabButtons.append(newItem)
            self.addSubview(newItem)
            
            manualCount = manualCount + 1
            
        }
        
        
    }
    /// MARK: EventCategoryDelegate
    internal func categorySelected(eventCategoryTabButton:EventCategoryTabButton) {
        
        // Decactivate All
        for tabButton in self.eventCategoryTabButtons{
            tabButton.deactivate()
        }
        // Activate Selected
        eventCategoryTabButton.activate()
    }

}
