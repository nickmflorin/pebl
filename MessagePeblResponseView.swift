//
//  MessagePeblResponseVC.swift
//  
//
//  Created by Nick Florin on 12/25/16.
//
//

import UIKit
import Foundation


protocol MessagePeblResponseViewDelegate: class {
    func closeResponseModal(sender: MessagePeblResponseView)
}

///////////////////////////////////////////////////
class MessagePeblResponseView: UIView {
    
    weak var delegate: MessagePeblResponseViewDelegate?
    
    var profileImage : UIImage!
    var profileImageView : UIImageView!

    var messagePebl : MessagePebl!
    var user : User!
    var userInfo : UserInfo!
    var userImages : UserImages!
    
    var horizontalMargin : CGFloat = 8.0
    var horizontalPadding : CGFloat = 4.0 // Used Between TextField and Button
    var buttonVerPadding : CGFloat = 10.0
    
    // Header Parameters ////////
    var header : PeblModalHeader!
    var headerHeight : CGFloat = 35.0
    
    // Image View Parameters ////////
    var imageViewFrame : CGRect!
    var imageViewWidth : CGFloat = 60.0
    var imageViewVerInset : CGFloat = 8.0
    
    // Button Parameters ////////
    var acceptButton : AcceptButton!
    var rejectButton : UIButton!
    
    var acceptButtonFrame : CGRect!
    var rejectButtonFrame : CGRect!

    var buttonWidth : CGFloat = 85.0
    var buttonHeight : CGFloat = 25.0
    
    var closeButton : CloseButton!
    // Message Label Parameters ////////
    var messageLabel : UILabel!
    var messageLabelFrame : CGRect!
    var messageLabelHorPadding : CGFloat = 8.0
    var messageLabelVerInset : CGFloat = 12.0
    
    var messageLabelFont = UIFont (name: "SanFranciscoDisplay-Regular", size:12)
    var messageLabelColor : UIColor = secondaryColor
    
    // Text Field Parameters ////////
    var outgoingMessageField : ExpandingTextView!
    var additional_outgoingMessageFieldHorInset : CGFloat = 1.0
    var outgoingMessageFieldFrame : CGRect!
    var outgoingMessageFieldVerMargin : CGFloat = 8.0

    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Styling
        self.backgroundColor = UIColor.white
        
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 3.0
        
        self.layer.shadowColor = accentColor.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        self.layer.shadowRadius = 2
        
    }
    //////////////////////////////
    // Init for Drawing Underlying
    override func draw(_ rect: CGRect) {
        self.createTextField()
        self.createButtons()
    }
    /////////////////////////////////////
    // Sets Up the View Based on Data in Message Pebl
    func setup(messagePebl:MessagePebl){
        
        // Store Data in View
        self.messagePebl = messagePebl
        self.user = self.messagePebl.user
        self.userInfo = self.messagePebl.user?.userInfo
        
        self.createImageView()
        self.createLabels()
        
    }
    /////////////////////////////////////
    // Close Button in Top Right Clicked
    func closeButtonClicked(){
        // Call Delegate to Close
        self.delegate?.closeResponseModal(sender:self)
    }
    /////////////////////////////////////
    // Creates Text Field for Outgoing Message
    func createTextField(){
        
        let totalHorizontalMargin = self.horizontalMargin + additional_outgoingMessageFieldHorInset
        let textFieldWidth : CGFloat = self.bounds.width - 2.0*totalHorizontalMargin
        // Height Irrelevant - Will Change Inside View for ExpandingTextView
        outgoingMessageFieldFrame = CGRect(x: totalHorizontalMargin, y: self.imageViewFrame.maxY+outgoingMessageFieldVerMargin, width: textFieldWidth, height: 10.0)
        outgoingMessageField = ExpandingTextView(frame: outgoingMessageFieldFrame)
        
        self.addSubview(outgoingMessageField)
        self.bringSubview(toFront: outgoingMessageField)
    }

    /////////////////////////////////////
    // Creates the Accept/Reject Buttons
    func createButtons(){
        
        ///////////////////// Create Accept Button ///////////////////
        let acceptButtonX : CGFloat = self.bounds.maxX - buttonWidth
        acceptButtonFrame = CGRect(x: acceptButtonX, y: self.bounds.maxY + buttonVerPadding, width: buttonWidth, height: buttonHeight)
        acceptButton = AcceptButton(frame: acceptButtonFrame)

        self.addSubview(acceptButton)
        self.bringSubview(toFront: acceptButton)
        
        ///////////////////// Create Reject Button ///////////////////
        let rejectButtonX : CGFloat = self.bounds.minX
        rejectButtonFrame = CGRect(x: rejectButtonX, y: self.bounds.maxY + buttonVerPadding, width: buttonWidth, height: buttonHeight)
        rejectButton = RejectButton(frame:rejectButtonFrame)
        
        self.addSubview(rejectButton)
        self.bringSubview(toFront: rejectButton)
        
        // Create Close Button from Custom Graphic //////////////
        let closeButtonHeight : CGFloat = 20.0
        let closeButtonFrame = CGRect(x: self.bounds.maxX - closeButtonHeight, y: self.bounds.minY-closeButtonHeight-4.0, width: closeButtonHeight, height:closeButtonHeight)
        closeButton = CloseButton(frame: closeButtonFrame)
        closeButton.addTarget(self, action: #selector(MessagePeblResponseView.closeButtonClicked), for: .touchUpInside)
        
        self.addSubview(closeButton)
        
    }
    /////////////////////////////////////
    // Creates Image View for Profile Image
    func createImageView(){
        
        imageViewFrame = CGRect(x: horizontalMargin, y: imageViewVerInset, width: imageViewWidth, height: imageViewWidth)
        profileImageView = UIImageView(frame: imageViewFrame)
        profileImageView.image = self.userImages.profileImage
        
        profileImageView.layer.cornerRadius = 2.0
        profileImageView.layer.masksToBounds = true
        self.addSubview(profileImageView)
        
    }
    /////////////////////////////////////
    // Creates Labels
    func createLabels(){
        
        // Label for the Incoming Message Container
        let messageLabelX = self.horizontalMargin + self.imageViewFrame.width + self.messageLabelHorPadding
        let messageLabelWidth = self.bounds.width - 2.0*horizontalMargin - self.imageViewFrame.width - self.messageLabelHorPadding
        messageLabelFrame = CGRect(x: messageLabelX, y: messageLabelVerInset, width: messageLabelWidth, height: self.imageViewFrame.height)
        messageLabel = UILabel(frame: messageLabelFrame)
        
        messageLabel.numberOfLines = 3
        messageLabel.lineBreakMode = .byWordWrapping
        
        messageLabel.text = self.messagePebl.message
        messageLabel.font = self.messageLabelFont
        messageLabel.textColor = self.messageLabelColor
        
        messageLabel.sizeToFit()
        self.addSubview(messageLabel)
    }
    /////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
