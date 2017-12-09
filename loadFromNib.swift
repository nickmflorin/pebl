//
//  loadFromNib.swift
//  Pebl2
//
//  Created by Nick Florin on 1/8/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

// Extension to Load View from NIB


//@IBDesignable
class NibLoadingView: UIView {
    
    @IBOutlet weak var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        print(String(describing: type(of: self)))
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
}

extension UIView {
    
    @discardableResult   // 1
    func fromNib<T : UIView>() -> T? {   // 2

        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {    // 3
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }
        
        view.frame = self.bounds
        self.addSubview(view)     // 4
        view.translatesAutoresizingMaskIntoConstraints = false   // 5
        view.layoutAttachAll(to: self)   // 6
        return view   // 7
    }
}

//1. Using a discardable return value since the returned view is mostly of no interest to caller when all outlets are already connected.
//2. This is a generic method that returns an optional object of type UIView. If it fails to load the view, it returns nil.
//3. Attempting to load a XIB file with the same name as the current class instance. If that fails, nil is returned.
//4. Adding the top level view to the view hierarchy.
//5. This line assumes we're using constraints to layout the view.
//6. This method adds top, bottom, leading & trailing constraints - attaching the view to "self" on all sides (code for this method is not included).
//7. Returning the top level view

extension UIView {
    
    func layoutAttachAll(to:UIView){
        
        let leadingConstraint = NSLayoutConstraint(item: to, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: to, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: to, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: to, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        to.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])

        
        
    }
}
