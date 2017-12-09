//
//  HomeEventTableViewController.swift
//  Pebl2
//
//  Created by Nick Florin on 1/25/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase
import FirebaseDatabase

let home_eventCellIdentifier = "HomeEventTableViewCell"

// Delegate to Allow Cell to Communicate with Main View
protocol HomeEventTableViewControllerDelegate {
    func showSpinner(homeEventTableViewController: HomeEventTableViewController)
    func hideSpinner(homeEventTableViewController: HomeEventTableViewController)
}

///////////////////////////////////////////////////////////
class HomeEventTableViewController: UITableViewController, HomeEventTableViewCellDelegate {
    
    ////////////////////////////
    // Mark: Properties
    var ref: FIRDatabaseReference!
    var userID : String?
    
    var numVenues : Int = 0
    var venues : [String : Venue] = [:]
    var venuesByIndex : [IndexPath : Venue] = [:]
    var cells : [IndexPath : HomeEventTableViewCell] = [:]
    
    let cellHeight: CGFloat = 130.0
    
    var delegate : HomeEventTableViewControllerDelegate?
    ////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tableview Setup ///////////////////////////////////////
        tableView?.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        tableView!.dataSource = self
        tableView!.delegate = self
        
        //////////////////////////////////////////////////////////////////////////////
        // Attach Asynchronous Listener for User Matches Endpoint
        let downloadQueue = DispatchQueue(label:"downloadQueue",qos:.default, target:nil)
        let group = DispatchGroup()
        
        // Initial Data Download ///////////////////////////
        self.ref.child("venues").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren(){ // Should always be the case
                
                self.delegate?.showSpinner(homeEventTableViewController: self)
                
                // Loop Over All Children Matches
                for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    
                    ///////// Asynchronous Download for Single Venue Data
                    group.enter()
                    downloadQueue.async(group: group,  execute: {
                        self.handleChildData(child,completion: { (newVenue) -> () in
                            group.leave()
                            DispatchQueue.main.async {
                                self.handleVenue(venue:newVenue)
                            }
                        })
                    })
                    ///////// When Download for All Matches Finishes
                    group.notify(queue: DispatchQueue.main, execute: {
                        DispatchQueue.main.async {
                            //self.tableView!.reloadData()
                            self.delegate?.hideSpinner(homeEventTableViewController: self)
                        }
                    })
                } // End For Loop
                
            }
        })
        
    }
    
    ///////////////////////////////////////////////////////////
    // Takes Snapshot Child Data and Creates New Venue Object From It
    func handleChildData(_ child:FIRDataSnapshot,completion: @escaping (Venue)->()){
//        let newVenue = Venue(venueID: child.key, snapshot: child)
//        
//        guard let imageUrl = newVenue.bestPhotoUrl else{
//            fatalError("Error : Venue Does Not Have Image URL")
//            return
//        }
//        
//        let myUrl = URL(string: imageUrl)
//        let request = NSMutableURLRequest(url:myUrl!);
//        request.httpMethod = "GET"
//        let task = URLSession.shared.dataTask(with: request as URLRequest) {
//            data, response, error in
//            
//            if error != nil {
//                print("Error Downloading Image from URL")
//                print(error!.localizedDescription)
//            }
//            else{
//                let httpURLResponse = response as? HTTPURLResponse
//                print("Response : \(httpURLResponse)")
//                
//                if httpURLResponse?.statusCode == 200{
//                    if let mimeType = response?.mimeType {
//                        if mimeType.hasPrefix("image") {
//                            
//                            newVenue.venueImage = UIImage(data: data!)
//                            completion(newVenue)
//                        }
//                    }
//                }
//            }
//        }
//        task.resume()
    }
    ///////////////////////////////////////
    // Handles Downloaded Venue Data
    func handleVenue(venue:Venue){
        
//        // Keep Track of Number of Existing Message Pebls
//        numVenues = numVenues + 1
//        self.venues[venue.venueID]=venue
//        
//        // Add Messge Pebl to Table VC
//        let indexPath = IndexPath(row: self.venues.count-1, section: 0)
//        self.venuesByIndex[indexPath]=venue
//        
//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: self.venues.count-1, section: 0)], with: .automatic)
//        tableView.endUpdates()
//        
    }

    ////////////////////////////////////////////
    // MARK: - Table View Data Source
    
    ///////////////////////////////////////
    // Creates an Active Table View Cell
    func createCell(indexPath:IndexPath,venue:Venue)->HomeEventTableViewCell{
        
        /// Determine Which Cell to Use - Default is Active Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: home_eventCellIdentifier, for: indexPath) as! HomeEventTableViewCell
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.indexPath = indexPath
        
        // Setup Delegates
        cell.delegate = self
        
        self.cells[indexPath]=cell
        cell.venue = venue
        cell.ratingView.rating = venue.rating
        cell.ratingView.orientation = "left"
        
        cell.setup() // Populate Venue Data for Cell
        return cell
    }
    
    ///////////////////////////////////////
    // Cell Configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let venue = self.venuesByIndex[indexPath] else {
            fatalError("Venue Doesn't Exist")
        }
        let cell = self.createCell(indexPath: indexPath, venue: venue)
        cell.contentView.backgroundColor = UIColor.clear
        return cell
    }
    ////////////////////////////////////////////
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    ////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    ////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venues.count
    }
    
}
