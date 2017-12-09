//
//  MatchesTableVC.swift
//  Pebl
//
//  Created by Nick Florin on 10/8/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

let match_cellIdentifier = "MatchTableViewCell"


// Delegate to Allow Cell to Communicate with Main View
protocol MatchesTableVCDelegate {
    func showMatchEvent(matchTableViewCell: MatchTableViewCell)
    func hideMatchEvent(matchTableViewCell: MatchTableViewCell)
    func showMessagePeblView(matchTableViewCell: MatchTableViewCell)
}

////////////////////////////////////////////////////////////////////////////////
class MatchesTableVC: UITableViewController, MatchTableViewCellDelegate{

    ///////////////////////////////////////
    //MARK : Properties
    var matches = NSMutableArray()
    var matchesByIndex : [IndexPath : Match] = [:]
    var cells : [IndexPath : MatchTableViewCell] = [:]
    
    var userID : String?
    let cellHeight: CGFloat = 130.0
    
    let expandedCellHeight: CGFloat = 320.0
    var increaseCellRow: Int?
    
    var currentProfileVC : MatchProfileVC?
    var keepIndexPathCell : IndexPath?
    
    var singleCellState : Bool = false
    var messagePeblState : Bool = false
    // Keep Track of Scroll View Current State
    var originalContentOffset : CGPoint!
    
    var delegate : MatchesTableVCDelegate?
    
    var superViewController : MatchesViewController!
    ///////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        // Tableview Setup ///////////////////////////////////////
        tableView?.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        tableView!.dataSource = self
        tableView!.delegate = self
    }
    ///////////////////////////////////////
    // Need to Reset State of Cells when View Appears
    override func viewDidAppear(_ animated: Bool) {
        
    }
    //////////////////////////////////////
    // Need to Reset State of Cells when View Disapppears
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    //////////////////////////////////////////////////////////////////////////////
    func addMatch(match:Match,indexPath:IndexPath){
        self.matches.add(match)
        self.matchesByIndex[indexPath]=match
        // Reload Tableview Data
        self.tableView!.reloadData()
    }
    // Tableview Content Size ///////////////////////////////////////
    override var preferredContentSize: CGSize {
        get {
            self.tableView.layoutIfNeeded()
            let contentWidth = self.tableView.contentSize.width - 20.0
            let contentHeight = self.tableView.contentSize.height
            let updatedContentSize = CGSize(width: contentWidth, height: contentHeight)
            return updatedContentSize
        }
        set {}
    }
    //////////////////
    // Activates Message Pebl Mode by Applying Alpha to Cell Components
    func activateMessagePeblMode(){
        messagePeblState = true
        self.tableView!.reloadData()
    }
    //////////////////
    // Deactivates Message Pebl Mode by Not Applying Alpha to Cell Components
    func deactivateMessagePeblMode(){
        messagePeblState = false
        self.tableView!.reloadData()
    }
    ///////////////////////////////////////////
    // MARK: Single Cell State Mode Handling
    func enterSingleStateMode(singleStateCellIndexPath:IndexPath,matchTableViewCell:MatchTableViewCell){
        
        self.keepIndexPathCell = singleStateCellIndexPath
        self.singleCellState = true
        self.tableView.isScrollEnabled = false
        self.tableView.reloadData()
        
        // Hide Lines Inbetween Cells
        self.tableView!.separatorStyle = .none

        // Communicate to Main View to Bring in Event View
        self.delegate?.showMatchEvent(matchTableViewCell: matchTableViewCell)
    }
    ///////////////////////////////////////////
    func leaveSingleStateMode(matchTableViewCell: MatchTableViewCell){
        
        self.keepIndexPathCell = nil
        self.singleCellState = false
        self.tableView.isScrollEnabled = true
        self.tableView.reloadData()
        
        // Hide Lines Inbetween Cells
        self.tableView!.separatorStyle = .singleLine
        
        // Scroll to Original Position
        self.tableView!.setContentOffset(originalContentOffset, animated: true)
        originalContentOffset = nil
        
        // Communicate to Main View to Bring in Event View
        self.delegate?.hideMatchEvent(matchTableViewCell: matchTableViewCell)
    }
    
    ///////////////////////////////////////////
    // Scrolls All Visible Cells to Left When Cell Slid Up
    func hideCells(startingIndexPath:IndexPath,completionHandler:@escaping (Bool) -> ()){
        
        // Find Cells Underneath and Scroll Out
        let filteredCells = self.cells.filter { $0.key.row >= startingIndexPath.row }
        for tuple in filteredCells{
            let cell = tuple.value
            cell.scrollOut()
        }
        completionHandler(true)
    }
    
    ///////////////////////////////////////////
    // Scrolls All Visible Cells to Right When Event Hides
    func showCells(completionHandler:@escaping (Bool) -> ()){
        
        for cell in self.tableView.visibleCells as! [MatchTableViewCell]{
            cell.scrollIn()
        }
        completionHandler(true)
    }
    
    ///////////////////////////////////////////
    // MARK: MatchTableViewCellDelegate

    // Brings in Modal to Send Message Pebl
    internal func showMessagePeblView(matchTableViewCell: MatchTableViewCell) {
        self.delegate?.showMessagePeblView(matchTableViewCell: matchTableViewCell)
    }

    // Scrolls to Make Selected Cell Top of Table
    internal func eventButtonClicked(matchTableViewCell: MatchTableViewCell) {
        
        let indexPath = matchTableViewCell.indexPath!
        
        /// Single Cell State True - Show Event Page
        if singleCellState == false {
            
            originalContentOffset = self.tableView.contentOffset
            
            // Scroll Cell to Top
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)

            // Slide Out All Cells Below
            let nextIndexPathRow = indexPath.row + 1
            let nextIndexPath = IndexPath(row: nextIndexPathRow, section: 0)
            self.hideCells(startingIndexPath: nextIndexPath, completionHandler :
                {(finished) in
                    if finished{
                        // Enter Single State Mode
                        self.enterSingleStateMode(singleStateCellIndexPath:indexPath,matchTableViewCell:matchTableViewCell)
                    }
            })
        }
        /// Single Cell State False - Hide Event Page
        else{
            self.showCells(completionHandler :
                {(finished) in
                    if finished{
                        // Enter Single State Mode
                        self.leaveSingleStateMode(matchTableViewCell:matchTableViewCell)
                    }
            })
        }
    }
    
    ///////////////////////////////////////
    // MARK: Table View Data Source
    
    ///////////////////////////////////////
    // Creates an Active Table View Cell
    func createCell(indexPath:IndexPath,match:Match)->MatchTableViewCell{
        
        /// Determine Which Cell to Use - Default is Active Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: match_cellIdentifier, for: indexPath) as! MatchTableViewCell
        
        // If the state is in the Message Pebl state, all cells should have alpha portion
        if self.messagePeblState{
            cell.activateMessagePeblSelectionMode()
        }
        else{
            cell.deactivateMessagePeblSelectionMode()
        }
        
        // If the state is single state mode (i.e. only the top cell is showing) then this will hide all
        // cell contents below the cells that have been slid over, in the case that bottom cells are not visible
        // at the time when the single cell is slid to the top.
        if self.singleCellState {
            if let ignoreIndexPath = self.keepIndexPathCell{
                if ignoreIndexPath != indexPath{
                    cell.contentView.alpha = 0.0
                    return cell
                }
            }
        }
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.contentView.alpha = 1.0
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.indexPath = indexPath
        
        // Setup Delegates
        cell.delegate = self
        
        superViewController = self.parent! as! MatchesViewController
        cell.delegate_MainView = self.superViewController as MatchTableViewCellDelegate_MainView!
        
        self.cells[indexPath]=cell
        cell.match = match
        cell.setup() // Populate User Info from Match
        return cell
    }
    
    ///////////////////////////////////////
    // Cell Configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let match = self.matchesByIndex[indexPath] else {
            fatalError("Match Doesn't Exist")
        }
        match.determineMatchTiming() // Determine Expiration Times
        let cell = self.createCell(indexPath: indexPath, match: match)
        
        cell.contentView.backgroundColor = UIColor.clear
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
        return self.matches.count
    }
}
