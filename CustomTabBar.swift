//
//  CustomTabBar.swift
//  Pebl2
//
//  Created by Nick Florin on 2/11/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

// Delegate for Getting Default Tab Items
protocol CustomTabBarDataSource {
    func tabBarItemsInCustomTabBar(tabBarView: CustomTabBar) -> [UITabBarItem]
}

// Delegate for Switching Between VCs on Tab Button Click
protocol CustomTabBarDelegate {
    func didSelectViewController(tabBarView: CustomTabBar, atIndex index: Int)
}

////////////////////////////////////////////////////////
// This will add the CustomTabBar as a Subview, This Inherits the UITabBarController
class BaseTabBarController: UITabBarController, CustomTabBarDataSource, CustomTabBarDelegate{
    
    /////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Default Tab Bar
        self.tabBar.isHidden = true
        
        // Add Custom Tab Bar View
        let customTabBar = CustomTabBar(frame: self.tabBar.frame)
        
        // Give Datasource to  Tab Bar
        customTabBar.datasource = self
        customTabBar.delegate = self
        
        // Setup Tab Bar
        customTabBar.setup()
        self.view.addSubview(customTabBar)
    }
    
    /////////////////////////////////
    // MARK: - CustomTabBarDataSource
    func tabBarItemsInCustomTabBar(tabBarView: CustomTabBar) -> [UITabBarItem] {
        return tabBar.items!
    }
    // MARK: - CustomTabBarDelegate
    internal func didSelectViewController(tabBarView: CustomTabBar, atIndex index: Int) {
        print("Delegate Changing Index : \(index)")
        self.selectedIndex = index
    }
    
}


////////////////////////////////////////////////////////
// Custom View of Tab Bar - Added as Subview by our BaseTabBarControler
class CustomTabBar: UIView, CustomTabBarItemDelegate {
    
    // MARK: Properties
    var customTabBarItems: [CustomTabBarItem]!
    var tabBarItems: [UITabBarItem]!
    var buttonImageHeight : CGFloat = 24.0
    
    var datasource: CustomTabBarDataSource!
    var delegate: CustomTabBarDelegate!
    
    var topLineLayer : CAShapeLayer!
    var topLinePath : UIBezierPath!
    var lineColor : UIColor = secondaryColor
    var lineWidth : CGFloat = 0.7
    
    // Parameters for Styling Tab Bar
    var tabBarBackgroundColor : UIColor = UIColorFromRGB(0xEDEDED)
    var tabBarImages : [UIImage] = [UIImage(named:"CottageIcon")!,UIImage(named:"CampfireIcon")!,UIImage(named:"PenguinIcon2")!,
                                    UIImage(named:"ChalkBagIcon")!]
    var tabBarTitles : [String] = ["Home","Friends","Match","Pebls"]
    /////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Styling
        self.backgroundColor = UIColor.white.withAlphaComponent(0.92)
    }
    /////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /////////////////////////////////
    // Sets Up Tab Bar Items
    func setup() {
        
        // Draw Line on Top of Tab Bar
        let topLineLayer = CAShapeLayer()
        let topLinePath = UIBezierPath()
        
        let startingPoint = CGPoint(x: self.bounds.minX, y:self.bounds.minY)
        let endingPoint = CGPoint(x: self.bounds.maxX, y:self.bounds.minY)
        
        topLinePath.move(to: startingPoint)
        topLinePath.addLine(to: endingPoint)
        
        topLineLayer.lineWidth = lineWidth
        topLineLayer.path = topLinePath.cgPath
        topLineLayer.strokeColor = lineColor.cgColor
        topLineLayer.fillColor = nil
        
        self.layer.addSublayer(topLineLayer)
        
        // Get Tab Bar Items from Default Tab Bar (Storyboard)
        tabBarItems = datasource.tabBarItemsInCustomTabBar(tabBarView: self)
        customTabBarItems = []
        
        // Create Containers for Tab Bar Items
        let containers = self.createTabBarItemContainers()
        
        self.createTabBarItems(containers: containers)
        // Default Selection
        self.delegate.didSelectViewController(tabBarView: self, atIndex: 0)
        
    }
    /////////////////////////////////
    // Creates Containers for Tab Bar Items
    func createTabBarItemContainers() -> [CGRect] {
        
        var containerArray = [CGRect]()
        
        // Create Container for Each Tab Bar Item
        for index in 0..<tabBarItems.count {
            let tabBarContainer = createTabBarContainer(index: index)
            containerArray.append(tabBarContainer)
        }
        return containerArray
    }
    /////////////////////////////////
    // Creates Tab Bar Item at Specific Index
    func createTabBarContainer(index: Int) -> CGRect {
        
        let tabBarContainerWidth = self.bounds.width / CGFloat(tabBarItems.count)
        let tabBarContainerRect = CGRect(x: tabBarContainerWidth * CGFloat(index), y: 0, width: tabBarContainerWidth, height: self.bounds.height)
        return tabBarContainerRect
    }
    
    // Item Selection Delegate to Change Current Selection
    internal func itemSelected(customTabBarItem: CustomTabBarItem) {
        
        // Tell UITabBarController that Item Clicked at Index
        if let selectedIndex = customTabBarItem.index {
            delegate.didSelectViewController(tabBarView: self, atIndex: selectedIndex)
            
            // Adjust Button Color and Background Color - Selected and Non Selected
            for tabBarItem in self.customTabBarItems{
                if tabBarItem.index != selectedIndex { tabBarItem.inactivate() }
                else { tabBarItem.activate() }
            }
        }
        else{
            fatalError()
        }
    }
    
    /////////////////////////////////
    // Creates the Individual Tab Bar Items
    func createTabBarItems(containers: [CGRect]) {
        
        // Loop Over Tab Bar Items
        var index = 0
        for _ in self.tabBarItems{
        
            let container = containers[index]
            
            // Initialize Item with Container Frame
            let customTabBarItem = CustomTabBarItem(frame: container)
            
            let buttonImage = self.tabBarImages[index]
            let buttonTitle = self.tabBarTitles[index]
            
            customTabBarItem.index = index
            customTabBarItem.delegate = self
            customTabBarItem.setup(image: buttonImage,label:buttonTitle)
            
            // First Tab is Default Active
            if index == 0 {
                customTabBarItem.activate()
            }
        
            self.addSubview(customTabBarItem)
            customTabBarItems.append(customTabBarItem)
            
            index = index + 1
        }
    }
}

