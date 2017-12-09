//
//  SendMessagePeblView.swift
//  Pebl2
//
//  Created by Nick Florin on 1/8/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit


//////////////////////////////////////////////////////////////////////////////////////
protocol SendMessagePeblViewDelegate: class {
    func closeResponseModal(sender: SendMessagePeblView)
}

//////////////////////////////////////////////////////////////////////////////////////
class SendMessagePeblView: UIView {
    
    // MARK: Properties
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var closeButton : CloseButton!
    @IBOutlet weak var messageTextField : UITextField!
    
    @IBOutlet weak var sendNameField: UILabel!
    @IBOutlet weak var visibleLayer : UIView!
    @IBOutlet weak var numPeblsField: UILabel!
    
    var outlineLineWidth : CGFloat = 1.8
    
    var match : Match!
    var user : User!
    var userInfo : UserInfo!
    var userImages : UserImages!
    var profileImage : UIImage!
    
    weak var delegate: SendMessagePeblViewDelegate?
    /////////////////////////////////////
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
        
        Bundle.main.loadNibNamed("SendMessagePeblView", owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
    }
    //////////////////////////////
    // Init for Drawing Underlying
    override func draw(_ rect: CGRect) {
        
        self.backgroundColor = UIColor.clear
        
        self.closeButton.backgroundColor = UIColor.clear
        self.closeButton.addTarget(self, action: #selector(SendMessagePeblView.closeButtonClicked), for: .touchUpInside)
        
        // Styling
        self.visibleLayer.layer.borderColor = light_blue.cgColor
        self.visibleLayer.layer.borderWidth = outlineLineWidth
        self.visibleLayer.layer.cornerRadius = 5.0
        
        self.visibleLayer.layer.shadowColor = secondaryColor.cgColor
        self.visibleLayer.layer.shadowOpacity = 0.8
        self.visibleLayer.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.visibleLayer.layer.shadowRadius = 5.0
        
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.layer.cornerRadius = 0.5*self.profileImageView.bounds.width
        self.profileImageView.layer.borderColor = UIColor.clear.cgColor
        self.profileImageView.layer.borderWidth = 2.0
        self.profileImageView.layer.masksToBounds = true
        
        self.drawTopSemiCircle()
    }
    /////////////////////////////////////
    // Draws Top Portion of Semi Circle on Profile Image View
    func drawTopSemiCircle(){
        
        let topLayer = CAShapeLayer()
        
        let qtAngle = 0.5 * CGFloat(M_PI) // Pi/2 or 90 degrees
        let arcCenter : CGPoint = CGPoint(x: self.profileImageView.frame.minX+0.5*self.profileImageView.frame.width, y: self.profileImageView.frame.minY+0.5*self.profileImageView.frame.height)
        let arcRadius : CGFloat = 0.5*self.profileImageView.frame.width
        
        // Additional Angle Used to Make Line Cover Gap of Horizontal Line When They Touch
        
        let additionalAngle = atan(outlineLineWidth/arcRadius)
        
        let topPath = UIBezierPath(arcCenter: arcCenter, radius: arcRadius, startAngle: 2.0*qtAngle-additionalAngle, endAngle: 0.0+additionalAngle, clockwise: true)
        
        topLayer.path = topPath.cgPath
        topLayer.fillColor = nil
        topLayer.strokeColor = light_blue.cgColor
        topLayer.lineWidth = outlineLineWidth
        
        self.layer.addSublayer(topLayer)
    }
    /////////////////////////////////////
    // Sets Up the View Based on Data in Message Pebl
    func setup(match:Match){

        // Store Data in View
        self.match = match
        self.user = self.match.user
        self.userInfo = self.match.user?.userInfo
        //self.userImages = self.match.user
        
        self.profileImageView.image = self.userImages.profileImage
        
//        print("Altering Message Pebl View for : \(self.userInfo.first_name!)")
//        self.sendNameField.text = "Send "+self.userInfo.first_name!+" a Message Pebl!"
//        self.numPeblsField.text = "3 Message Pebls Left"
    }
    /////////////////////////////////////
    // Close Button in Top Right Clicked
    func closeButtonClicked(){
        // Call Delegate to Close
        self.delegate?.closeResponseModal(sender:self)
    }
    
    
}
