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
import Firebase
import PagingMenuController

let eventCellIdentifierFeed = "EventTableViewCellFeed"

protocol EventTableViewControllerFeedDelegate {
    func showSpinner(sender: UIViewController)
    func hideSpinner(sender: UIViewController)
    func showVenue(venue:Venue)
}

struct MatchPin {
    var matchedUserID : String
    var pinnedVenueID : String
}

///////////////////////////////////////////////////////////
class EventTableViewControllerFeed: UITableViewController, FourSquareQueryDelegate {

    // Mark: Properties

    // To Do: Possibly Include Parent Wrappers in VC
    var searchedVenues : [Venue]! // Most Recent Search Venues
    var venues : [Venue] = []
    var venuesAtIndexPath : [String:IndexPath] = [:] // Stores Venue ID and Index Path
    
    // Stores All Matches Seen During Data, Not Currently Used
    // Might want to use as a queue or cache for performance purposes.
    var allMatches : [User] = []
    
    var matchPins : [MatchPin] = [] // Stores Matches that Pinned Each Venue ID
    
    // Location Data
    var currentLocation : CLLocation!
    var locationManager : CLLocationManager!
    var lattitude : CGFloat!
    var longitude : CGFloat!
    
    var userID : String!
    
    // Cells Indexed by ID of Google Place
    var cells : [String : EventTableViewCellFeed] = [:]
    let cellHeight: CGFloat = 115.0
    
    var delegate : EventTableViewControllerFeedDelegate?
    var query : FourSquareQuery!

    // Determines whether or not the base loading indicator (middle of screen) is shown during load.
    var initialLoad : Bool = true // Default
    
    class func instantiateFromStoryboard() -> EventTableViewControllerFeed {
        let storyboard = UIStoryboard(name: "Base", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! EventTableViewControllerFeed
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
        tableView!.bounces = true
        
        tableView!.showsVerticalScrollIndicator = true
        tableView!.indicatorStyle = .black
        
        // Need to handle situations if the user ever accessed this page if location services not enabled (might not be possible)
        locationManager = CLLocationManager() // Initialize Location Manager
        currentLocation = locationManager!.location
        lattitude = CGFloat(Float(currentLocation.coordinate.latitude))
        longitude = CGFloat(Float(currentLocation.coordinate.longitude))
        
        // Query Object
        self.query = FourSquareQuery()
        self.query.delegate = self
        
        // Refresh Controller
        self.refreshControl?.addTarget(self, action: #selector(EventTableViewControllerFeed.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        // Make Initial API Call for Places to Load
        self.queryVenues(showLoadingIndicator:true,completion: { finished in
            print("Finished Loading All Venues in Background")
        })
        
        // Gets Matches in Background and Then Finds the Pins for Each Match Asynchronously
        let primaryUser = User(userID: self.userID)
        primaryUser.getMatches({matchesModel in
            // Loop Over Each Match - Getting the Pinned Venue IDs for Each
            for match in matchesModel.matches {
                
                // Attach Listener to Match
                // Might need to make sure we already don't have a listener for this.
                self.createListenerForMatch(matchUserID: match.userID)
                
                User(userID: match.userID).getPins({matchedUserPinsModel in
                    
                    // matchedUserPinsModel = nil if Snapshot Doesn't Exist
                    if matchedUserPinsModel != nil {
                        
                        if matchedUserPinsModel!.pins == nil {
                            fatalError(matchedUserPinsModel!.userID)
                        }
                        for pin in matchedUserPinsModel!.pins {

                            let newMatchPin = MatchPin(matchedUserID: match.userID, pinnedVenueID: pin.venueID)
                            // This will only happen if there is a back end error and a given user has multiple pins for the same venue ID.
                            if self.matchPins.contains(where: { $0.matchedUserID == match.userID && $0.pinnedVenueID == pin.venueID}){
                                log.info("Backend Error : Multiple Pins for Venue : \(pin.venueID) and User : \(match.userID)")
                            }
                            else {
                                self.matchPins.append(newMatchPin)
                                self.handleNewPin(matchPin: newMatchPin) // Determine if Pin Needs to be Added to Current Table Cells Showed
                            }
                        }
                    }
                    
                })
            }
        })
    }
    
    // Creates a Listener for All Matches to Update Table View if Matches Pin
    func createListenerForMatch(matchUserID:String){
        // To Do : Might need to include more observation event types (child removed)
        User(userID: matchUserID).ref.child(UserPins.endpoint).observe(.childAdded, with: {snapshot in
            let newUserPin = UserPin(userID: matchUserID, snapshot: snapshot)
            
            // This will only happen if there is a back end error and a given user has multiple pins for the same venue ID.
            if self.matchPins.contains(where: { $0.matchedUserID == newUserPin.userID && $0.pinnedVenueID == newUserPin.venueID}){
                log.info("Backend Error : Multiple Pins for Venue : \(newUserPin.venueID) and User : \(newUserPin.userID)")
                return
            }
            let newMatchPin = MatchPin(matchedUserID: newUserPin.userID, pinnedVenueID: newUserPin.venueID)
            self.matchPins.append(newMatchPin)
            self.handleNewPin(matchPin: newMatchPin) // Determine if Pin Needs to be Added to Current Table Cells Showed
        })
    }
    
    // Either Adds Matched User and Pin to Venue Cell if Present or Queues it for Later
    func handleNewPin(matchPin:MatchPin){
        
        // Check if pinned venue already shown in table
        if self.venuesAtIndexPath[matchPin.pinnedVenueID] != nil {
            // Venue Already Present in Table
            let indexP = self.venuesAtIndexPath[matchPin.pinnedVenueID]
            
            // Update Table
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexP!], with: .none)
            self.tableView.endUpdates()
        }
 
    }
    
    // Clears Places
    func clearPlaces(){
        self.searchedVenues = nil
        self.venues = []
        self.tableView!.reloadData()
    }
}



// Mark: Querying //////////////////////////////////////////////////////////////
extension EventTableViewControllerFeed {
    
    // Refresh Handler - Fetch more objects
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.queryVenues(showLoadingIndicator:false,completion: { finished in
            print("Finished Loading All Venues in Background")
        })
    }
    
    // Retrieves data from an API explore and uses the resulting data to populate the first data in table view.
    // Data in the explore request is based only on lattitude and longitude
    func queryVenues(showLoadingIndicator:Bool,completion: @escaping (Bool) -> Void) {
        
        self.query.lattitude = self.lattitude
        self.query.longitude = self.longitude
        
        // Four Square - First query is exploring things around the lattitude and longitude.
        // Completion handler result is Result<[Venue]> Venues Added in Delegate of Query
        query.getVenues({ result in
            
            if let error = result.error {
                // TODO: Improved Error Handling
                let alert = UIAlertController(title: "Error", message: "Could not load first places : \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: {() -> Void in
                    completion(true)
                })
                return
            }
        })
    }
}



// Mark: FourSquareQueryDelegate //////////////////////////////////////////////////////////////
extension EventTableViewControllerFeed {
    
    internal func presentVenue(venue:Venue){
        DispatchQueue.main.async {
            self.venues.insert(venue, at: 0)
            // Update Table View
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .top)
            self.tableView.endUpdates()
        }
    }
    
    // Loading Indicators Called from Query
    // Only refer to time when venues to show in table are being loaded, extra queued venues 
    // are loaded in background.
    
    internal func loading(fourSquareQuery:FourSquareQuery){
        print("Loading")
        if self.initialLoad {
            DispatchQueue.main.async {
                self.delegate?.showSpinner(sender: self)
            }
        }
    }
    internal func finishedLoading(fourSquareQuery:FourSquareQuery){
        print("Finished Loading")
        DispatchQueue.main.async {
            self.delegate?.hideSpinner(sender: self)
            self.refreshControl?.endRefreshing()
        }
    }
}




// MARK: - Table View Delegate/Data Source //////////////////////////////////////////////////////////////
extension EventTableViewControllerFeed {
    
    // Push Venue Detail VC to Nav Stack when Cell Selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let venue = self.venues[indexPath.row]
        self.delegate?.showVenue(venue: venue)
    }
    
    // Cell Configuration
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> EventTableViewCellFeed {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: eventCellIdentifierFeed, for: indexPath) as! EventTableViewCellFeed
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear

        if self.venues.count >= indexPath.row {
            
            let venue = self.venues[indexPath.row]
            self.venuesAtIndexPath[venue.id] = indexPath
            
            cell.selectionStyle = UITableViewCellSelectionStyle.blue
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            // Attribute Venue to Cell and Setup
            cell.venue = venue
            cell.currentLocation = self.currentLocation
            
            // Pass in Image
            cell.venueImageView.image = venue.image
            cell.venueImageView.contentMode = .scaleAspectFill
            cell.venueImageView.clipsToBounds = true
            
            // Check if Pinned Users Exist for Venue
            
            let matchedPins = matchPins.filter {$0.pinnedVenueID == venue.id}
            let matchedPinUserIDs = matchedPins.map { $0.matchedUserID }

            cell.pinnedUserIDs = matchedPinUserIDs

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
        return self.venues.count
    }

}


