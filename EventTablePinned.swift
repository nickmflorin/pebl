//
//  EventTableViewController.swift
//  Pebl2
//
//  Created by Nick Florin on 1/22/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import FirebaseAuth
import PagingMenuController

let eventCellIdentifierPinned = "EventTableViewCellPinned"

protocol EventTableViewControllerPinnedDelegate {

}
// Stores the associated data that we want to populate our 
// pinned table view cells with.
struct PinnedCellData {
    
    var venueID : String
    var pinnedMatches : [User]
    var venue : Venue
    var userPin : UserPin
}

///////////////////////////////////////////////////////////
class EventTableViewControllerPinned: UITableViewController {
    
    // Mark: Properties
    var indexPathForVenueID : [String:IndexPath] = [:]
    var cellData : [PinnedCellData] = []
    
    // Location Data
    var currentLocation : CLLocation!
    var locationManager : CLLocationManager!
    var lattitude : CGFloat!
    var longitude : CGFloat!
    
    var userID : String!
    
    // Cells Indexed by ID of Google Place
    var cells : [String : EventTableViewCellPinned] = [:]
    let cellHeight: CGFloat = 85.0
    
    var delegate : EventTableViewControllerPinnedDelegate?
    var query : FourSquareQuery!
    
    // Determines whether or not the base loading indicator (middle of screen) is shown during load.
    var initialLoad : Bool = true // Default
    
    class func instantiateFromStoryboard() -> EventTableViewControllerPinned {
        let storyboard = UIStoryboard(name: "Base", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! EventTableViewControllerPinned
    }
    
    ////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase Data Store References
        self.userID = FIRAuth.auth()?.currentUser?.uid
        
        // Tableview Setup
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView.separatorStyle = .singleLine
        tableView!.showsVerticalScrollIndicator = true
        tableView!.indicatorStyle = .black
        
        // Need to handle situations if the user ever accessed this page if location services not enabled (might not be possible)
        locationManager = CLLocationManager() // Initialize Location Manager
        currentLocation = locationManager!.location
        lattitude = CGFloat(Float(currentLocation.coordinate.latitude))
        longitude = CGFloat(Float(currentLocation.coordinate.longitude))
        
        self.query = FourSquareQuery()
        
        // Make Firebase Call for User Pins
        self.retrievePins(completion: { finished in
            print("Finished Loading All Venues in Background")
        })
        
    }

    // Retrieves pins for the primary user.
    func retrievePins(completion: @escaping (Bool) -> Void) {
        
        User(userID: self.userID).getPins({userPinsObject in

            // userPinsObject will be nil if there are no pins for the user.
            if let userPinsObj = userPinsObject {
                guard userPinsObj.pins != nil else {
                    fatalError()
                }
                
                let detailsGroup = DispatchGroup()
                let global = DispatchQueue.global(qos: .userInteractive)
                
                for pin in userPinsObj.pins {
                    
                    detailsGroup.enter()
                    global.async {
                        self.query.retrieveDetailsForID(id:pin.venueID!,{ result in
                            
                            // Get Details for Each Venue Asynchronously
                            if let details = result.value {
                                
                                // Create New Venue from Details
                                let venueID = details.id
                                let newVenue = Venue(id: venueID!)
                                newVenue.attribute(fourSquareVenueDetailData: details)
                                newVenue.loadImage({imageResult in
                                    let pinnedCellData = PinnedCellData(venueID: newVenue.id, pinnedMatches: [], venue: newVenue, userPin:pin)
                                    self.presentPinData(pinnedCellData:pinnedCellData)
                                    detailsGroup.leave()
                                })
                            }
                            else{
                                log.error("Error retrieving details for user pinned venue: \(pin.venueID)")
                                detailsGroup.leave()
                            }
                        })
                    }
                }
                detailsGroup.notify(queue: global, execute: {
                    completion(true)
                })
            }
        })
    }

    // Either Adds Matched User and Pin to Venue Cell if Present or Queues it for Later
    func handleNewPin(pin:UserPin){
        
        // Check if pinned venue already shown in table
        if self.indexPathForVenueID[pin.venueID] != nil {
            // Venue Already Present in Table
            let indexP = self.indexPathForVenueID[pin.venueID]
            
            // Update Table
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexP!], with: .none)
            self.tableView.endUpdates()
        }
        
    }
    // Presebts Pin to the Table
    func presentPinData(pinnedCellData:PinnedCellData){
        DispatchQueue.main.async {
            self.cellData.insert(pinnedCellData, at: 0)
            // Update Table View
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .top)
            self.tableView.endUpdates()
        }
    }

    
    // MARK: - Table View Delegate //////////////////////////////////////////////////////////////
    
    // Push Venue Detail VC to Nav Stack when Cell Selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let venue = self.userPins[indexPath.row]
        //self.delegate?.showVenue(venue: venue)
    }
    
    // MARK: - Table View Data Source //////////////////////////////////////////////////////////////
    
    // Cell Configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> EventTableViewCellPinned {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: eventCellIdentifierPinned, for: indexPath) as! EventTableViewCellPinned
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        if self.cellData.count >= indexPath.row {
            
            let singleCellData = self.cellData[indexPath.row]
            self.indexPathForVenueID[singleCellData.venueID] = indexPath
            
            cell.selectionStyle = UITableViewCellSelectionStyle.blue
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            // Attribute Venue to Cell and Setup
            cell.pinnedCellData = singleCellData
            cell.currentLocation = self.currentLocation
            
            // Pass in Image
            cell.venueImageView.image = singleCellData.venue.image
            cell.venueImageView.contentMode = .scaleAspectFill
            cell.venueImageView.clipsToBounds = true
            
//            // Check if Pinned Users Exist for Venue
//            if self.matchPins[venue.id] != nil {
//                let usersPinned = self.matchPins[venue.id]
//                cell.pinnedUsers = usersPinned as! [User]!
//            }
            
            cell.setup()
            cell.venueImageView.layer.borderColor = UIColor.clear.cgColor
            cell.venueImageView.layer.borderWidth = 0.5
            cell.venueImageView.layer.cornerRadius = 1.5
            cell.layer.borderColor = UIColor.red.cgColor
            
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellData.count
    }
    
}


