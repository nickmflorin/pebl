//
//  SuggestionPeblTable.swift
//  Pebl2
//
//  Created by Nick Florin on 1/4/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

////////////////////////////////////////////////////////////////////////////////
class SuggestionPeblTableVC: UITableViewController {
    
    ///////////////////////////////////////
    //MARK : Properties
    var numSuggestionPebls : Int = 0
    var allSuggestionPebls : [SuggestionPebl] = []
    var suggestionPebls = Dictionary<String, Array<SuggestionPebl>>()
    var peblsByIndex = Dictionary<IndexPath, Array<SuggestionPebl>>()
    
    var numUniqueUsers : Int = 0
    
    var userID : String?
    let cellHeight: CGFloat = 162.0
    
    let expandedCellHeight: CGFloat = 320.0
    var increaseCellRow: Int?
    
    var currentProfileVC : MatchProfileVC?
    
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
    func addPebl(pebl:SuggestionPebl,indexPath:IndexPath){
        
        let userID = pebl.userID!
        print("Adding Suggestion Pebl to Table for User : \(userID)")
        
        // Keep Track of Number of Existing Message Pebls
        numSuggestionPebls = numSuggestionPebls + 1
        allSuggestionPebls.append(pebl)
        
        if self.suggestionPebls[userID]==nil{
            let emptySuggestionPeblList : [SuggestionPebl] = []
            numUniqueUsers = numUniqueUsers + 1
            
            self.suggestionPebls[userID]=emptySuggestionPeblList
            self.peblsByIndex[indexPath]=emptySuggestionPeblList
        }
        
        // Update Dictionaries for Indexes with New Pebls
        if var currentUserPebls = self.suggestionPebls[userID]{
            currentUserPebls.append(pebl)
            self.suggestionPebls[userID]=currentUserPebls
        }
        
        if var currentIndexPebls = self.peblsByIndex[indexPath]{
            currentIndexPebls.append(pebl)
            self.peblsByIndex[indexPath]=currentIndexPebls
        }
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
    
    ///////////////////////////////////////
    // MARK: Table View Data Source
    
    ///////////////////////////////////////
    // Cell Configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Determine Which Cell to Use - Default is Active Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: suggestion_cellIdentifier, for: indexPath) as! SuggestionPeblTableViewCell
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // Get Suggested Pebls from Single User Corresponding to Single Index Path
        if self.peblsByIndex[indexPath] != nil{
            let currentPebls : [SuggestionPebl] = self.peblsByIndex[indexPath]!
            
            // Multiple Suggestion Pebls Stored for Single Cell
            cell.suggestionPebls = currentPebls
            cell.indexPath = indexPath
            cell.setup()
            
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
        return self.suggestionPebls.count
    }
}
