//
//  LoadingMoreView.swift
//  Pebl2
//
//  Created by Nick Florin on 2/11/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

class LoadingMoreView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    
    /////////////////////////////////////
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
        
        Bundle.main.loadNibNamed("LoadingMoreView", owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)

    }
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        Bundle.main.loadNibNamed("LoadingMoreView", owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
        
    }

}
