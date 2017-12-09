//
//  EventMenuOptions.swift
//  Pebl2
//
//  Created by Nick Florin on 3/5/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import PagingMenuController

public extension PagingMenuControllerCustomizable {
    var defaultPage: Int {
        return 1
    }
    var animationDuration: TimeInterval {
        return 0.3
    }
    var isScrollEnabled: Bool {
        return true
    }
    var backgroundColor: UIColor {
        return UIColor.white
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .three
    }
    var menuControllerSet: MenuControllerSet {
        return .multiple
    }
}

struct EventMenuOptions: PagingMenuControllerCustomizable {
        
    // Instantiate Three Versions of Table View Controller from Storyboard
    private let feedViewController = EventTableViewControllerFeed.instantiateFromStoryboard()
    private let findViewController = EventFindViewController.instantiateFromStoryboard()
    private let pinnedViewController = EventTableViewControllerPinned.instantiateFromStoryboard()
    
    ///////////// Feed/Base Menu
    struct MenuItemFeed: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let font = UIFont(name: "SanFranciscoDisplay-Regular", size: 14.0)
            let title = MenuItemText(text: "Feed",
                                     color : UIColor.lightGray,
                                     selectedColor : UIColor.black,
                                     font : font!,
                                     selectedFont : font!)
            return .text(title: title)
        }
    }
    ///////////// Find Menu
    struct MenuItemFind: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let font = UIFont(name: "SanFranciscoDisplay-Regular", size: 14.0)
            let title = MenuItemText(text: "Find",
                                     color : UIColor.lightGray,
                                     selectedColor : UIColor.black,
                                     font : font!,
                                     selectedFont : font!)
            return .text(title: title)
        }
        
    }
    ///////////// Pinned Menu
    struct MenuItemPinned: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let font = UIFont(name: "SanFranciscoDisplay-Regular", size: 14.0)
            let title = MenuItemText(text: "Pinned",
                                     color : UIColor.lightGray,
                                     selectedColor : UIColor.black,
                                     font : font!,
                                     selectedFont : font!)
            
            return .text(title: title)
        }
    }
    ///////////// Components
    internal var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    ///////////// View Controllers
    internal var pagingControllers: [UIViewController] {
        return [feedViewController, findViewController, pinnedViewController]
    }
    ///////////// Options for Menu View
    internal struct MenuOptions: MenuViewCustomizable {
        // Display Mode for Different Menu Options, Other Options:
        //return .standard(widthMode: .flexible, centerItem: true, scrollingMode: .pagingEnabled)
        //return .infinite(widthMode: .flexible, scrollingMode: .pagingEnabled)
        
        // Setting height to larger will add extra space between menu view and the content, while increasing
        // vertical padding of .underline will push underline up toward text.
        
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var backgroundColor : UIColor {
            return UIColor.white
        }
        var focusMode: MenuFocusMode {
            return .underline(height: 1, color: light_blue, horizontalPadding: 15, verticalPadding: 5)
        }
        var height: CGFloat {
            return 40
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemFeed(), MenuItemFind(),MenuItemPinned()]
        }
    }
}
