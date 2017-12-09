//
//  MatchTableViewCell.swift
//  Pebl2
//
//  Created by Nick Florin on 1/8/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

// Delegate to Allow Cell to Communicate with Table View
protocol MatchTableViewCellDelegate {
    func eventButtonClicked(matchTableViewCell: MatchTableViewCell)
    func showMessagePeblView(matchTableViewCell: MatchTableViewCell)
}
// Delegate to Allow Cell to Communicate with Main View
protocol MatchTableViewCellDelegate_MainView {
    func showProfile(matchTableViewCell: MatchTableViewCell)
}

////////////////////////////////////////////////////////////////////////////////
class MatchTableViewCell: UITableViewCell, MatchProfileImageTileDelegate, UIScrollViewDelegate{
    
    //////////////////////////////////////////////
    // MARK: Properties
    @IBOutlet weak var matchProfileImageTile: MatchProfileImageTile!

    @IBOutlet weak var ageField: UILabel!
    @IBOutlet weak var firstNameField: UILabel!
    @IBOutlet weak var eventMessageField: UILabel!
    @IBOutlet weak var categoryField: UILabel!
    @IBOutlet weak var categoryIconImageView: UIImageView!
    
    @IBOutlet weak var whenField: UILabel!
    @IBOutlet weak var eventField: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventButton: UpDownButton!
    
    @IBOutlet weak var selectButton: UIButton!
    var whiteRoundedView : UIView!
    
    var alphaFadeDuration : CGFloat = 0.4
    var alphaModeAlpha : CGFloat = 0.4
    
    // Information Parameters
    var user_id : String!
    var indexPath : IndexPath!
    var match : Match!
    
    var delegate : MatchTableViewCellDelegate!
    var delegate_MainView : MatchTableViewCellDelegate_MainView!
    
    var scrollVisible : Bool = true
    
    /////////////////////////
    // Create Back Content View when Subviews Layed Out
    override func layoutSubviews() {
        
        whiteRoundedView = UIView(frame: CGRect(x:5.0, y:0.0, width:self.contentView.bounds.size.width-10.0, height:self.contentView.bounds.height - 5.0))
        
        whiteRoundedView.layer.borderColor = accentColor.cgColor
        whiteRoundedView.layer.borderWidth = 0.6
        whiteRoundedView.layer.cornerRadius = 5.0
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
        
        // Add Shadow
        //whiteRoundedView.layer.shadowColor = accentColor.cgColor
        //whiteRoundedView.layer.shadowOpacity = 0.6
        //whiteRoundedView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        self.contentView.addSubview(whiteRoundedView)
        self.contentView.sendSubview(toBack: whiteRoundedView)
    }
    //////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Styling
        self.selectButton.alpha = 0.0
        
        // Initialization Code
        self.isHighlighted = false
        self.isSelected = false
        self.setupScrollView()
    }
    /////////////////////////////////////////////////////////////
    // Called after match object designated to cell, populates info in cell
    // with match object.
    func setup(){

        // Configure Cell - Default is Already Active Cell - Store Information Only Relevant to Active Cells
        //let daysRemaining = Int((match.daysRemaining)!)
        //cell.expirationLabel.text = String(describing: daysRemaining)+" More Days!"
        //cell.expirationBar.setProgress(messagePebl.progress!, animated: true)
        
        self.user_id = match.userID
        
        // Unwrap User
        guard let user = match.user else {
            fatalError("Fatal Error : Match Has no User Object")
        }
        guard let userInfo = user.userInfo else{
            fatalError("Fatal Error : Match User Has no User Info Object")
        }
        guard let userStatus = user.userStatus else {
            fatalError("Fatal Error : Match User Has no User Status Object")
        }
        guard let userVenue = userStatus.userVenue else {
            fatalError("Fatal Error : Match User Has no User Venue Object")
        }
        
        self.firstNameField.text = userInfo.firstName
        // Unwrap Age Field Data
        if userInfo.age != nil {
            self.ageField.text = String(describing: userInfo.age!)
        }

        self.matchProfileImageTile.profileImage = userInfo.profileImage
        self.matchProfileImageTile.delegate = self
        
        self.eventField.text = userVenue.name
        self.whenField.text = userStatus.eventTime
        self.eventMessageField.text = userStatus.eventComment
        
        //self.categoryField.text = userVenue.subCategoryName
        self.categoryIconImageView.contentMode = .scaleAspectFit
        self.categoryIconImageView.image = UIImage(named: "BarIcon")
    }
    ///////////////////////////////////////////////////////////////
    // Setup Scroll View
    func setupScrollView(){
        
        // Create the scroll view which enables the horizontal swiping.
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.contentSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        scrollView.contentInset = UIEdgeInsetsMake(0, self.bounds.width, 0, 0)
        scrollView.contentOffset = CGPoint(x:0.0,y:0.0)
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = false
        
    }
    //////////////////////////////////////////////////////////////
    // MARK: matchProfileImageTile Delegate
    internal func showProfile(sender: MatchProfileImageTile){
        self.delegate_MainView.showProfile(matchTableViewCell: self)
    }
    
    ///////////////////////////////////////////////////////////////
    // Scrolls Cell Out of View
    func scrollOut(){
        if self.scrollVisible == false{
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.contentOffset = CGPoint(x:self.bounds.width,y:0.0)
        })
        self.scrollVisible = false
    }
    ///////////////////////////////////////////////////////////////
    // Scrolls Cell Out of View
    func scrollIn(){
        if self.scrollVisible{
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.contentOffset = CGPoint(x:0.0,y:0.0)
        })
        self.scrollVisible = true
    }
    ///////////////////////////////////////////////////////////////
    // Message Pebl Selection Modes
    
    // Activate message pebl mode by giving all components alpha except select button
    func activateMessagePeblSelectionMode(){
        
        UIView.animate(withDuration: TimeInterval(alphaFadeDuration), animations: {
            self.ageField.alpha = self.alphaModeAlpha
            self.firstNameField.alpha = self.alphaModeAlpha
            self.matchProfileImageTile.alpha = self.alphaModeAlpha
            self.whenField.alpha = self.alphaModeAlpha
            self.eventField.alpha = self.alphaModeAlpha
            self.eventButton.alpha = 0.0
            self.selectButton.alpha = 1.0
        })
    }
    // Dectivate message pebl mode by giving all components 1.0 alpha and hiding select button
    func deactivateMessagePeblSelectionMode(){
        
        UIView.animate(withDuration: TimeInterval(alphaFadeDuration), animations: {
            self.ageField.alpha = 1.0
            self.firstNameField.alpha = 1.0
            self.matchProfileImageTile.alpha = 1.0
            self.whenField.alpha = 1.0
            self.eventField.alpha = 1.0
            self.eventButton.alpha = 1.0
            self.selectButton.alpha = 0.0
        })
    }
    ///////////////////////////////////////////////////////////////
    // Brings in Modal to Send Message Pebl
    func showMessagePeblView(){
        self.delegate.showMessagePeblView(matchTableViewCell: self)
    }
    ///////////////////////////////////////////////////////////////
    // Selection Button to Open Message Pebl Modal
    @IBAction func selectButtonClicked(_ sender: AnyObject) {
        self.showMessagePeblView()
    }
    ///////////////////////////////////////////////////////////////
    @IBAction func eventButtonClicked(_ sender: AnyObject) {
        self.eventButton.flip()
        self.delegate.eventButtonClicked(matchTableViewCell: self)
    }
}


