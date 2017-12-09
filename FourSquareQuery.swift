//
//  FourSquareQuery.swift
//  Pebl2
//
//  Created by Nick Florin on 2/13/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Foundation
import Alamofire

// Wrapper for API Errors
enum FourSquareQueryError: Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
    case requestError(reason:String)
    case queryError(reason:String)
}

protocol FourSquareQueryDelegate {
    func presentVenue(venue:Venue) // Present Venue to Datasource
    func loading(fourSquareQuery:FourSquareQuery)
    func finishedLoading(fourSquareQuery:FourSquareQuery)
}

// TO DO: Right now, we request details and images for additional venues each time the refresh bar 
// is pulled.  In future, we might want to do all of that in the background so pulling down the bar
// results in no more requesting but just dequeueing.

///// Controls event searchs from FourSquareAPI
class FourSquareQuery : NSObject {

    private static var maxPlacesPerFetch : Int = 8 // Represents maximum number of places to show to the user each time more places are requested/asked for.
    var numberOfVenuesToShow : Int! // Represents Maximum Number of Places to Show in Table Total (This iterates/increases by maxPlacesToShow each time more places are asked for).

    var queue : [Venue]! // Keep track of results not yet shown in table but already requested.
    var venues : [String:Venue]! // Just the venues that are not in the queue
    
    // Parameters of Query - Update after each query.
    var searchText : String = ""
    var longitude : CGFloat!
    var lattitude : CGFloat!

    // Updated After Each Query
    var searchWrapper : FourSquareSearchWrapper! // Store Last Instance
    var error : Error!
    var lastRequestID : String = ""
    var statusCode : Int!
    var totalResults : Int!
    
    // Delegate to Communicate Directly to Data Visuals
    var delegate : FourSquareQueryDelegate?
    
    // Initialization
    override init(){
        self.queue = []
        self.venues = [:]
        self.numberOfVenuesToShow = 0
    }
    
    // Stores Venue by Either Attributing to Queue or Current Venues
    // Returns stored venue if not already in the venue dictionary, returns nil if its already present in dictionary
    // or is put into the queue
    func storeVenue(venue:Venue)->Venue?{
        
        var storedVenue : Venue!
        
        // Store in Current Venues
        if self.venues.count < self.numberOfVenuesToShow {
            
            // Make Sure ID Not Already Present in Queue
            if self.venues[venue.id] == nil {
                storedVenue = venue
                print("Storing Venue : \(storedVenue.name!)")
                self.venues[venue.id]=venue
            }
        }
        // Store in Queue if Current Results at Max Size
        else{
            if !self.queue.contains(venue){
                print("Queueing Venue : \(venue.name!)")
                self.queue.append(venue)
            }
        }
        return storedVenue
    }
    
    // Takes Venue from Queue and Updates Queue and Venue Data
    func dequeueVenue()->Venue? {
        
        let venueToDequeue = self.queue[0]
        var dequeuedVenue : Venue!
        // NOTE : During the search, it was already checked if we have not already 
        // seen the venue, before the details were retrieved.
        
        // Only Add if Not Already Stored
        if self.venues[venueToDequeue.id] == nil {
            self.venues[venueToDequeue.id] = venueToDequeue
            print("Queueing Venue : \(venueToDequeue.name!)")
            dequeuedVenue = venueToDequeue
        }
        // Remove From Queue No Matter What
        self.queue.remove(at: 0)
        
        return dequeuedVenue
    }
    
    // Will either search venues by requesting from the API or pull venues from the queue
    // updating the current count of venues to show
    func getVenues(_ completionHandler: @escaping (Result<[Venue]>) -> Void){
        
        var reachedActiveLimit : Bool = false
        
        // Increment Max Allowable Results to Display
        self.delegate?.loading(fourSquareQuery: self)
        self.numberOfVenuesToShow = self.numberOfVenuesToShow + FourSquareQuery.maxPlacesPerFetch
        
        // To do: number of venues to show needs to adjust if the number of venues we request is less than the 
        // maximum to show
        
        var retrievedVenues : [Venue] = []
        let updateGroup = DispatchGroup()
        let loadingGroup = DispatchGroup() // Only Loading the Venues That We are Going to Show
        
        // If Queue Not Empty - Need to Request, Add Results from Queue Before Possibly Requesting More
        if self.queue.count != 0 {
            // Put Queued Places into Current Place Array and Remove From Queue
            while self.venues.count < self.numberOfVenuesToShow && self.queue.count != 0 {
                
                // Venue should have been validated before putting into queue.
                let dequeuedVenue = self.dequeueVenue()
                if dequeuedVenue != nil {
                    retrievedVenues.append(dequeuedVenue!)
                    self.delegate?.presentVenue(venue: dequeuedVenue!)
                }
            }
        }
        // If we don't need to do anymore requesting, inform the delegate loading is done.
        if self.numberOfVenuesToShow <= self.venues.count {
            self.delegate?.finishedLoading(fourSquareQuery: self)
        }
    
        // Make requests for more venues
        else {

            updateGroup.enter()
            loadingGroup.enter()
            
            self.search({ result in
                
                // Return Immediately if Error
                if result.error != nil {
                    updateGroup.leave()
                    loadingGroup.leave()
                    
                    completionHandler(.failure(result.error!))
                    return
                }
                
                let queue = DispatchQueue(label:"queue",qos:.default, target:nil)
                let venueGroup = DispatchGroup() // Group for each venue

                // For Each Venue, Asychronously Get Details and Tips
                // Remove Venue from Searched Queue 1 at a Time
                let searchedVenues = result.value
                for venue in searchedVenues! {
                    
                    // Always Enter Venue Group, Only Enter Active Venue Group if We Are Going to Display Venue
                    venueGroup.enter()

                    // Get Details for Each Venue ////////////////////
                    let subgroup = DispatchGroup() // Group for Two Separate Endpoints of Single Venue
                    queue.async { // Run Asynchronously on Queue
                        
                        // Get Venue Details at Details Endpoint - Need details data to get 
                        // the image.
                        subgroup.enter()
                        log.info("Retrieving Details for Venue : \(venue.name) - \(venue.id)")
                        self.retrieveDetailsForID(id: venue.id, {detailResult in
                            
                            if detailResult.error != nil {
                                print("Error Finding Details for Venue : \(venue.id)")
                                subgroup.leave() // Immediately Ignore
                            }
                            else {
                                // Attribute details and get image.
                                venue.attribute(fourSquareVenueDetailData: detailResult.value!)
                                venue.loadImage({imageResult in
                                    subgroup.leave()
                                })
                            }
                        })
                        
                        // Get Venue Tips at Tips Endpoint
                        subgroup.enter()
                        log.info("Retrieving Tips for Venue : \(venue.name) - \(venue.id)")
                        self.retrieveTipsForID(id: venue.id, {tipsResult in
                            
                            if tipsResult.error != nil {
                                print("Error Finding Tips for Venue : \(venue.id)")
                                subgroup.leave() // Immediately Ignore
                            }
                            else {
                                venue.attribute(fourSquareTips: tipsResult.value!)
                                subgroup.leave()
                            }
                        })
                        
                        // Wait for Two Subgroups to Finish
                        subgroup.notify(queue: queue, execute: {
                            
                            venue.findDesiredTip() // Find the best tip that satisfies requirements
                            venue.validate()
                            
                            if !venue.valid {
                                log.info("Invalid Venue : \(venue.invalidReason)")
                                venueGroup.leave()
                            }
                            else {
                                // Store Venue in Queue or Active List - Present if Not Queued
                                let storedVenue = self.storeVenue(venue:venue)
                                if storedVenue != nil { // Venue was not queued.
                                    self.delegate?.presentVenue(venue: venue)
                                }
                                else {
                                    // Venue was queued - done loading active venues.  If this is the first time this has been reached,
                                    // stop showing loading indicator.
                                    if !reachedActiveLimit {
                                        reachedActiveLimit = true
                                        self.delegate?.finishedLoading(fourSquareQuery: self)
                                    }
                                    
                                }
                                venueGroup.leave()
                            }
                        })
                    } // End Async Call
                } // End Loop
                
                // All Groups Finished
                venueGroup.notify(queue: DispatchQueue.main, execute: {
                    completionHandler(.success(retrievedVenues))
                })
            })
        }
    }
    
    // To do: Include additional query parameters for the search feature of FourSquare.
    func search(_ completionHandler: @escaping (Result<[Venue]>) -> Void) {
        
        guard self.lattitude != nil && self.longitude != nil else {
            log.error("Invalid Query")
            completionHandler(.failure(FourSquareQueryError.queryError(reason: "Lattitude and Longitude Not Specified")))
            return
        }
        
        var searchedVenues : [Venue] = []
        
        FourSquareQuery.searchWithLL(lattitude : self.lattitude, longitude : self.longitude, completionHandler: { result in
            
            log.info("Searching with Lattitude : \(self.lattitude) Longitude : \(self.longitude)")
            // Store Results in Wrapper to Query
            self.error = result.error
            guard result.error == nil else {
                
                // Immediately Return Error
                completionHandler(.failure(result.error!))
                return
            }
            if let wrapper = result.value {
                
                log.info("Found : \(wrapper.totalResults) Results")
                
                // Store Results to Query Object
                self.lastRequestID = wrapper.requestID
                self.statusCode = wrapper.statusCode
                self.totalResults = wrapper.totalResults
                
                // Get Details for Each Venue ////////////////////
                log.info("Retrieving Details for the : \(wrapper.totalResults) Results")
                
                // Loop Over Results - Get Details and Load Image in Table Separately
                for result in wrapper.searchData {
                    
                    // Store Last Referenced Wrapper
                    self.searchWrapper = wrapper
                    
                    // Immediately Ignore Venues we Already Have so Details Aren't Fetched
                    if result.id != nil && self.venues[result.id] == nil {
                        let newVenue = Venue(id:result.id) // NewVenue
                        newVenue.attribute(fourSquareVenueSearchData: result) // Basic Search Results
                        searchedVenues.append(newVenue)
                    }
                }
                // Return Venues
                completionHandler(.success(searchedVenues)) // Return updated venues that were received from search
            }
        })
    }

    /// Detailed API Connection for Specific Venue ID, Contains Images and All Venue Details
    func retrieveDetailsForID(id:String,_ completionHandler: @escaping (Result<FourSquareVenueDetailData>) -> Void) {
        
        // Include Results in Completion Handler, Store Wrapper Data to Query Object
        // Store Places from Wrapper in Query Object
        FourSquareQuery.searchDetailsForID(id : id, completionHandler: { result in

            // Store Results in Wrapper to Query
            self.error = result.error
            guard result.error == nil else {
                // Immediately Return Error
                completionHandler(.failure(result.error!))
                return
            }
            if let wrapper = result.value {
                
                // Store Results to Query Object
                self.lastRequestID = wrapper.requestID
                self.statusCode = wrapper.statusCode
                // Return Single Result
                completionHandler(.success(wrapper.detailData))
            }
        })
    }
    
    /// Gets Tips from Tips Endpoint for Specific Venue
    func retrieveTipsForID(id:String,_ completionHandler: @escaping (Result<[FourSquareTip]>) -> Void) {
        
        // Include Results in Completion Handler, Store Wrapper Data to Query Object
        // Store Places from Wrapper in Query Object
        FourSquareQuery.searchTipsForID(id : id, completionHandler: { result in
            
            // Store Results in Wrapper to Query
            self.error = result.error
            guard result.error == nil else {
                
                // Immediately Return Error
                completionHandler(.failure(result.error!))
                return
            }
            if let wrapper = result.value {
                
                // Store Results to Query Object
                self.lastRequestID = wrapper.requestID
                self.statusCode = wrapper.statusCode
                
                // Return Single Result
                completionHandler(.success(wrapper.tips))
            }
        })
    }
    
        

    // URL Generation
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    // Requesting
    
    
    // Searches API for Details of Specific Venue ID.
    private class func searchDetailsForID(id:String, completionHandler: @escaping (Result<FourSquareDetailWrapper>) -> Void) {
        
        let path = FourSquareRequest.generateDetailUrl(id: id)
        
        // Requesting Phase - Make Sure it's HTTPS Becuase Sometimes the API Gives Us HTTP URLs
        guard var urlComponents = URLComponents(string: path) else {
            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
            log.error(error.localizedDescription)
            completionHandler(.failure(error))
            return
        }
        
        urlComponents.scheme = "https"
        guard let url = try? urlComponents.asURL() else {
            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
            log.error(error.localizedDescription)
            completionHandler(.failure(error))
            return
        }
        
        // Request
        log.info("Requesting from Four Square at URL : \(path)")
        let _ = Alamofire.request(url).responseJSON { response in
            if let error = response.result.error {
                log.error(error)
                completionHandler(.failure(error))
                return
            }
            
            // Check for Successful Response but Error in Response
            let result = response.result.value as! [String:AnyObject]
            let meta = result["meta"] as! [String:AnyObject]
            if meta["errorDetail"] != nil {
                
                let errorDetail = meta["errorDetail"] as! String!
                let requestError = FourSquareQueryError.requestError(reason: errorDetail!)
                
                log.error(errorDetail)
                completionHandler(.failure(requestError))
                return
            }
            
            log.info("Venue Details - Successfull API Response")
            let wrapper : FourSquareDetailWrapper = FourSquareDetailWrapper()
            let resultWrapper = wrapper.create(response:response)
            completionHandler(resultWrapper)
        }
    }
    
    // Searches API for Tips of Specific Venue ID.
    private class func searchTipsForID(id:String, completionHandler: @escaping (Result<FourSquareTipsWrapper>) -> Void) {
        
        let path = FourSquareRequest.generateTipsUrl(id: id)
        
        // Requesting Phase - Make Sure it's HTTPS Becuase Sometimes the API Gives Us HTTP URLs
        guard var urlComponents = URLComponents(string: path) else {
            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
            log.error(error.localizedDescription)
            completionHandler(.failure(error))
            return
        }
        
        urlComponents.scheme = "https"
        guard let url = try? urlComponents.asURL() else {
            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
            log.error(error.localizedDescription)
            completionHandler(.failure(error))
            return
        }
        
        // Request
        log.info("Requesting from Four Square at URL : \(path)")
        let _ = Alamofire.request(url).responseJSON { response in
            if let error = response.result.error {
                log.error(error)
                completionHandler(.failure(error))
                return
            }
            
            // Check for Successful Response but Error in Response
            let result = response.result.value as! [String:AnyObject]
            let meta = result["meta"] as! [String:AnyObject]
            if meta["errorDetail"] != nil {
                
                let errorDetail = meta["errorDetail"] as! String!
                let requestError = FourSquareQueryError.requestError(reason: errorDetail!)
                
                log.error(errorDetail)
                completionHandler(.failure(requestError))
                return
            }
            
            log.info("Venue Tips - Successfull API Response")
            let wrapper : FourSquareTipsWrapper = FourSquareTipsWrapper()
            let tipsWrapper = wrapper.create(response:response)
            completionHandler(tipsWrapper)
        }
    }
    

    // Searches places around the lattitude and longitude.  Explore requires user authentication but will be more useful.
    private class func searchWithLL(lattitude : CGFloat, longitude : CGFloat, completionHandler: @escaping (Result<FourSquareSearchWrapper>) -> Void) {
        
        let path = FourSquareRequest.generateSearchUrl(lattitude: lattitude, longitude: longitude)
        
        // Requesting Phase - Make Sure it's HTTPS Becuase Sometimes the API Gives Us HTTP URLs
        guard var urlComponents = URLComponents(string: path) else {
            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
            log.error(error.localizedDescription)
            completionHandler(.failure(error))
            return
        }
        
        urlComponents.scheme = "https"
        guard let url = try? urlComponents.asURL() else {
            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
            log.error(error.localizedDescription)
            completionHandler(.failure(error))
            return
        }
        
        // Request
        log.info("Requesting from Four Square at URL : \(path)")
        let _ = Alamofire.request(url).responseJSON { response in
            if let error = response.result.error {
                log.error(error)
                completionHandler(.failure(error))
                return
            }
            
            // Check for Successful Response but Error in Response
            let result = response.result.value as! [String:AnyObject]
            let meta = result["meta"] as! [String:AnyObject]
            if meta["errorDetail"] != nil {
                
                let errorDetail = meta["errorDetail"] as! String!
                let requestError = FourSquareQueryError.requestError(reason: errorDetail!)
                
                log.error(errorDetail)
                completionHandler(.failure(requestError))
                return
            }
            
            log.info("Venues Search - Successfull API Response")
            let wrapper : FourSquareSearchWrapper = FourSquareSearchWrapper()
            let resultWrapper = wrapper.create(response:response)
            completionHandler(resultWrapper)
        }
    }
    
    // Requesting
    ///////////////////////////////////////////////////////////////////////////////////////////////
    

    
//    // Explores places based only on the users lattitude and longitude
//    // To Do: Include other optional parameters to make search more flexible, this search is needed in addition to other Requests to get detailed data
//    // or images.
//    private class func exploreWithLL(lattitude : CGFloat, longitude : CGFloat, completionHandler: @escaping (Result<FourSquareExploreWrapper>) -> Void) {
//        
//        let path = FourSquareQuery.generateExploreUrl(lattitude: lattitude, longitude: longitude)
//    
//        // Requesting Phase - Make Sure it's HTTPS Becuase Sometimes the API Gives Us HTTP URLs
//        guard var urlComponents = URLComponents(string: path) else {
//            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
//            log.error(error.localizedDescription)
//            completionHandler(.failure(error))
//            return
//        }
//        
//        urlComponents.scheme = "https"
//        guard let url = try? urlComponents.asURL() else {
//            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
//            log.error(error.localizedDescription)
//            completionHandler(.failure(error))
//            return
//        }
//        
//        // Request
//        log.info("Requesting from Four Square at URL : \(path)")
//        let _ = Alamofire.request(url).responseJSON { response in
//            if let error = response.result.error {
//                log.error(error)
//                completionHandler(.failure(error))
//                return
//            }
//            
//            // Check for Successful Response but Error in Response
//            let result = response.result.value as! [String:AnyObject]
//            let meta = result["meta"] as! [String:AnyObject]
//            if meta["errorDetail"] != nil {
//                
//                let errorDetail = meta["errorDetail"] as! String!
//                let requestError = FourSquareQueryError.requestError(reason: errorDetail!)
//                
//                log.error(errorDetail)
//                completionHandler(.failure(requestError))
//                return
//            }
//
//            
//            log.info("Successfull API Response")
//            // Create Wrapper of Places from Response - Places Over Max Places Put in Queue
//            // Handle Errors in JSON Response
//            let wrapper : FourSquareExploreWrapper = FourSquareExploreWrapper()
//            
//            // Result Wrapper Formatted as Result<GooglePlaceWrapper>
//            let resultWrapper = wrapper.create(response:response)
//            completionHandler(resultWrapper)
//        }
//    }
//    ////////// Base Query - Explores places around the user, given their lattitude and longitude.
//    // To do: Include additional query parameters for the explore feature of FourSquare.
//    func explore(_ completionHandler: @escaping (Result<[FourSquareExploreResult]>) -> Void) {
//        
//        guard self.lattitude != nil && self.longitude != nil else {
//            log.error("Invalid Query")
//            return
//        }
//        
//        // Include Results in Completion Handler, Store Wrapper Data to Query Object
//        // Store Places from Wrapper in Query Object
//        FourSquareQuery.exploreWithLL(lattitude : self.lattitude, longitude : self.longitude, completionHandler: { result in
//            
//            log.info("Exploring with Lattitude : \(self.lattitude) Longitude : \(self.longitude)")
//            // Store Results in Wrapper to Query
//            self.error = result.error
//            guard result.error == nil else {
//                
//                // Immediately Return Error
//                completionHandler(.failure(result.error!))
//                return
//            }
//            if let wrapper = result.value {
//                
//                // Store Results to Query Object
//                self.lastRequestID = wrapper.requestID
//                self.statusCode = wrapper.statusCode
//                self.totalResults = wrapper.totalResults
//                
//                // Get Places From Wrapper and Store to Query after Updating Max Places to Make Visible
//                //self.updateExploredPlaces(updateSearchResults:wrapper.searchResults)
//                
//                // Return updated places that were updated from queue
//                completionHandler(.success(wrapper.searchResults))
//            }
//        })
//    }



}
