//
//  MessagePeblTableVC.swift
//  Pebl
//
//  Created by Nick Florin on 9/25/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

let messagePeblCellIdentifier = "MessagePeblTableViewCell"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Delegate Commands to Respond to Message Pebl
protocol MessagePeblTableViewCellDelegate: class {
    func messagePeblRespond(sender: MessagePeblTableViewCell)
}

class MessagePeblTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var profilePhoto: UIButton!
    @IBOutlet weak var firstNameField: UILabel!
    @IBOutlet weak var expirationBar: UIProgressView!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var messageField: UILabel!

    // Status Circle Parameters
    var statusCircleColor : UIColor = yellow
    var statusCircleHorizontalInset : CGFloat = 8.0
    var statusCircleVerticalInset : CGFloat = 2.0
    var statusCircleRadius : CGFloat = 4.0
    var path : UIBezierPath?

    // Information Parameters
    var user_id : String!
    var indexPath : IndexPath!
    var messagePebl : MessagePebl!

    //////////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()

        // Styling
        self.backgroundColor = UIColor.clear
        self.profilePhoto.layer.borderWidth = 1.0
        self.profilePhoto.layer.cornerRadius = 3.0
        self.profilePhoto.layer.borderColor = secondaryColor.cgColor
        self.profilePhoto.layer.masksToBounds = true

        // Initialization Code
        self.isHighlighted = false
        self.isSelected = false
        self.clipsToBounds = true

        // Draw Status Circle in Top Right
        let circleRect = CGRect(x: self.bounds.maxX - statusCircleHorizontalInset - 2.0 * statusCircleRadius, y: self.bounds.minY + statusCircleVerticalInset + 2.0 * statusCircleRadius, width: 2.0 * statusCircleRadius, height: 2.0 * statusCircleRadius)
        path = UIBezierPath(ovalIn: circleRect)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path?.cgPath
        shapeLayer.fillColor = statusCircleColor.cgColor
        shapeLayer.strokeColor = statusCircleColor.cgColor

        self.layer.addSublayer(shapeLayer)
    }
    //////////////////////////////
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //////////////////////////////
    // MARK: Actions
    @IBAction func settingsButtonClicked(_ sender: AnyObject) {

        // Create Animation for Shadow Disappearing
        let fadeAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        fadeAnimation.fromValue = 0.0
        fadeAnimation.toValue = 0.7
        fadeAnimation.duration = 0.4
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class MessagePeblTableVC: UITableViewController  {
    
    ///////////////////////////////////////
    //MARK : Properties
    var messagePebls = NSMutableArray()
    var messagePeblsByIndex : [IndexPath : MessagePebl] = [:]
    var userID : String?
    let cellHeight: CGFloat = 80.0
    ///////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        // Tableview Setup ///////////////////////////////////////
        tableView?.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView!.dataSource = self
        tableView!.delegate = self
    }
    //////////////////////////////////////////////////////////////////////////////
    func addMessagePebl(messagePebl:MessagePebl,indexPath:IndexPath){
        self.messagePebls.add(messagePebl)
        self.messagePeblsByIndex[indexPath]=messagePebl
    }
    //////////////////////////////////////////////////////////////////////////////
    // Tableview Content Size ////
    override var preferredContentSize: CGSize {
        get {
            self.tableView.layoutIfNeeded()
            let contentWidth = self.tableView.contentSize.width - 5.0
            let contentHeight = self.tableView.contentSize.height
            let updatedContentSize = CGSize(width: contentWidth, height: contentHeight)
            return updatedContentSize
        }
        set {}
    }

    ///////////////////////////////////////
    // MARK: Table View Data Source
    
    ///////////////////////////////////////
    // Creates an Active Table View Cell
    func createCell(indexPath:IndexPath,messagePebl:MessagePebl)->MessagePeblTableViewCell{
        
        /// Determine Which Cell to Use - Default is Active Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: messagePeblCellIdentifier, for: indexPath) as! MessagePeblTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // Configure Cell - Default is Already Active Cell - Store Information Only Relevant to Active Cells
        let daysRemaining = Int((messagePebl.daysRemaining)!)
        cell.expirationLabel.text = String(describing: daysRemaining)+" More Days!"
        cell.expirationBar.setProgress(messagePebl.progress!, animated: true)

        cell.user_id = messagePebl.userID
        cell.indexPath = indexPath
        cell.messagePebl = messagePebl
        cell.profilePhoto.setImage(messagePebl.user?.userInfo.profileImage, for: UIControlState())
        //cell.firstNameField.text = messagePebl.user?.userInfo?.first_name
        cell.backgroundColor = UIColor.white
        
        // Temporary
        cell.messageField.text = "This is an example of a message that would be shown in the tile.  The user can access the message conversation window by clicking on the tile."
        
        return cell
    }
    ///////////////////////////////////////
    // Cell Configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let messagePebl = self.messagePeblsByIndex[indexPath]
        let cell : UITableViewCell = UITableViewCell(frame: CGRect.zero)
        
        if messagePebl != nil{
            messagePebl?.determinePeblTiming() // Determine Expiration Times
            // Already Viewed - Cell is Active Not New
            let cell = self.createCell(indexPath: indexPath, messagePebl: messagePebl!)
            return cell
        }
        return cell
    }
    ////////////////////////////////////////////
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    ////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    ////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagePebls.count
    }

}
