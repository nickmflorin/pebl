//
//  PagingMenuControllerCustomizable.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 5/23/16.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation

public protocol PagingMenuControllerCustomizable {
    var defaultPage: Int { get }
    var animationDuration: TimeInterval { get }
    var isScrollEnabled: Bool { get }
    var backgroundColor: UIColor { get }
    var lazyLoadingPage: LazyLoadingPage { get }
    var menuControllerSet: MenuControllerSet { get }
    var componentType: ComponentType { get }
}

public enum LazyLoadingPage {
    case one
    case three
    case all
}

public enum MenuControllerSet {
    case single
    case multiple
}

public enum ComponentType {
    case menuView(menuOptions: MenuViewCustomizable)
    case pagingController(pagingControllers: [UIViewController])
    case all(menuOptions: MenuViewCustomizable, pagingControllers: [UIViewController])
}
