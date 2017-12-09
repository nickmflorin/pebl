//
//  GooglePlacesSearchController.swift
//  Pebl2
//
//  Created by Nick Florin on 2/11/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


///// Controls event searchs from Google Place API
class GoogleQuery : NSObject {
    
    // Additional Places Queue Hold Queried Results Not Shown Yet
    // As Results Loaded - They will be put into places if it is less than the
    // max allowable at a time, and then they will be stored in the additionalPlacesQueue
    var places: [String:GooglePlace] = [:]
    var additionalPlacesQueue : [GooglePlace] = []
    var wrapper : GooglePlaceWrapper! // Store Last Instance
    
    // MARK: Endpoints
    private static var photoEndpoint = "https://maps.googleapis.com/maps/api/place/photo?"
    private static var textSearchEndpoint = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
    private static var detailEndpoint = "https://api.foursquare.com/v2/venues/?"
    
    var maxPlaces : Int = 8 // Represents Maximum Places to Show Per Request
    var maxPlacesToShow : Int! // Represents Maximum Places to Show Total
    
    // Parameters of Query - Update after each query.
    var searchText : String = ""
    var longitude : CGFloat!
    var lattitude : CGFloat!
    
    // Updated After Each Query
    var error : Error!
    
    var htmlAttributions : [String] = []
    var nextPageToken : String = ""
    var statusResponse : String = ""
    var errorMessage : String = ""
    
    // Initialization
    override init(){
        self.maxPlacesToShow = self.maxPlaces
    }
    // Updates Places in Places and Queue Arrays
    func updatePlaces(updatePlaces:[GooglePlace]){
        
        for place in updatePlaces {
            if self.places.count < self.maxPlacesToShow {
                
                print("CHECKING : \(place.placeID)")
                print(self.places[place.placeID])
                // Store in Current Places if Not Already Stored
                if self.places[place.placeID] == nil {
                    self.places[place.placeID] = place
                }
            }
            else{
                // Put Place in Queue if Not Already There
                let results = self.additionalPlacesQueue.filter { $0.placeID == place.placeID }
                let exists = results.isEmpty == false
                if !exists {
                    self.additionalPlacesQueue.append(place)
                }
            }
        }
    }
    
    // Increments Places to Show and Returns Additional Places from Queue After Wrapper Combined
    func movePlacesFromQueue() -> [GooglePlace] {
        
        var dequeuedPlaces : [GooglePlace] = []
        // Put Queued Places into Current Place Array and Remove From Queue
        while self.places.count < self.maxPlacesToShow && self.additionalPlacesQueue.count != 0 {
            
            let placeToDequeue = self.additionalPlacesQueue[0]
            
            // Only Add if Not Already Stored
            if self.places[placeToDequeue.placeID] == nil {
                self.places[placeToDequeue.placeID] = placeToDequeue
                dequeuedPlaces.append(placeToDequeue)
            }
            // Remove From Queue No Matter What
            self.additionalPlacesQueue.remove(at: 0) // Remove from Current Queue
        }
        return dequeuedPlaces
    }
    
    ////////// Base Query
    func getPlaces(_ completionHandler: @escaping (Result<[GooglePlace]>) -> Void) {
        
        guard self.searchText != "" && self.lattitude != nil && self.longitude != nil else {
            fatalError("Invalid Query")
        }

        // Include Results in Completion Handler, Store Wrapper Data to Query Object
        // Store Places from Wrapper in Query Object
        GoogleQuery.getPlacesWithSearchText(searchText : self.searchText, lattitude : self.lattitude, longitude : self.longitude, completionHandler: { result in
            
            // Store Results in Wrapper to Query
            self.error = result.error
            guard result.error == nil else {
                // Immediately Return Error
                print(result.error)
                completionHandler(.failure(result.error!))
                return
            }
            if let wrapper = result.value {
                
                // Store Results to Query Object
                self.nextPageToken = wrapper.nextPageToken
                self.statusResponse = wrapper.statusResponse
                self.errorMessage = wrapper.errorMessage
                self.htmlAttributions = wrapper.htmlAttributions
                
                // Get Places From Wrapper and Store to Query after Updating Max Places to Make Visible
                self.updatePlaces(updatePlaces:wrapper.places)
                
                // Return updated places that were updated from queue
                self.maxPlacesToShow = self.places.count // Move max places to show back down to count after update
                completionHandler(.success(wrapper.places))
            }
            
        })
    }
    
    // Adds Places From Queue and if not enough will get them from either the nextPageToken or a subsequent
    // request.
    func getMorePlaces(_ completionHandler: @escaping (Result<[GooglePlace]>) -> Void){
        
        // Increment number of places to show
        self.maxPlacesToShow = self.maxPlacesToShow + self.maxPlaces
        let dequeuedPlaces = self.movePlacesFromQueue() // Put Places in Queue if Applicable
        
        // If this is true, all places moved out of queue to current places was sufficient for the 
        // current number of allowable places.all
        if self.places.count == self.maxPlacesToShow {
            
            // Return updated places that were updated from queue
            self.maxPlacesToShow = self.places.count // Move max places to show back down to count after update
            // Return Additional Places from Wrapper
            completionHandler(.success(dequeuedPlaces))
        }
        
        // Still Need to Show More - (1) Request Using Next Page Token (2) Make New Search Request from Previous Parameters
        else if self.places.count < self.maxPlacesToShow {
            
            // Use Next Page Token if Available
            if self.nextPageToken != "" {
                
                GoogleQuery.getPlacesWithToken(nextPageToken : self.nextPageToken,completionHandler: { result in
                    // Store Results in Wrapper to Query
                    self.error = result.error
                    guard result.error != nil else {
                        // Immediately Return Error
                        completionHandler(.failure(result.error!))
                        return
                    }
                    
                    if let wrapper = result.value {
                        
                        // Store Results to Query Object
                        self.nextPageToken = wrapper.nextPageToken
                        self.statusResponse = wrapper.statusResponse
                        self.errorMessage = wrapper.errorMessage
                        self.htmlAttributions = wrapper.htmlAttributions
                        
                        // Get Places From Wrapper and Store to Query after Updating Max Places to Make Visible
                        self.updatePlaces(updatePlaces:wrapper.places)
                        
                        // Return updated places that were updated from queue
                        self.maxPlacesToShow = self.places.count // Move max places to show back down to count after update
                        
                        // Return Additional Places from Wrapper
                        completionHandler(.success(wrapper.places))
                    }
                    
                    
                })
            }
            else {
                // Make another web request for more places
                fatalError()
                self.getPlaces(completionHandler)
            }

            // TO DO : Need to account for situation if using next page token doesn't get all of leftover places.
            
        }
        else {
            fatalError("Places Should Never Have Longer Length Than maxPlacesToShow")
        }
        
    }

    

    


    // Uses endpoint and photo reference to generate url to request image from
    class func generatePhotoURL(photoRef : String, maxWidth : Int, maxHeight : Int) ->String {
        
        var photoUrl = GoogleQuery.photoEndpoint
        
        photoUrl = photoUrl + "key=" + GooglePlaceAccess.api_key.rawValue
        photoUrl = photoUrl + "&photoreference=" + photoRef
        
        photoUrl = photoUrl + "&maxwidth=" + String(describing:maxWidth)
        photoUrl = photoUrl + "&maxwidth=" + String(describing:maxHeight)
        return photoUrl
    }
    // Uses endpoint, and nextPageToken from a Previous Request to Prepare a URL
    class func generateSearchURLFromToken(nextPageToken : String) ->String {
        
        var nextPageSearchUrl = GoogleQuery.textSearchEndpoint
        // Add Search Text and API Key
        nextPageSearchUrl = nextPageSearchUrl + "&pagetoken=" + nextPageToken
        nextPageSearchUrl = nextPageSearchUrl + "&key=" + GooglePlaceAccess.api_key.rawValue
        
        return nextPageSearchUrl
    }
    
    // Uses endpoint, passed in search text, lattitude and longitude to generate the full endpoint url for the API request
    class func generateTextSearchURL(searchText : String, lattitude : CGFloat, longitude : CGFloat) ->String {
        
        // Use Parameters and EndPoints to Create URL Path
        var textSearchURL = GoogleQuery.textSearchEndpoint
        
        // Need to do, include more parameters
        let radius = "1000"
        let location = String(describing: lattitude)+","+String(describing: longitude)
        var params : [String:String] = ["location":location,"radius":radius]
        
        /// Hard Coded Type for Now - Can Only Select One
        var typeOptions = ["amusement_park","bowling_alley","cafe","zoo",
                           "stadium","restaurant","night_blue","bar"]
        let chosenType = typeOptions[typeOptions.count-1] // Default Hardcoded For Now
        params["type"]=chosenType
        
        for (argument,value) in params {
            textSearchURL = textSearchURL + "&" + argument + "=" + value
        }
        
        // Filter Out Spaces in Text Search
        let whitespace = NSCharacterSet.whitespaces
        let testString = NSString(string: searchText)
        let range = testString.rangeOfCharacter(from: whitespace)
        
        var searchTextFormatted = searchText
        if range != nil {
            
            let noSpaceTextArray = searchText.components(separatedBy: " ")

            var searchTextFormatted = ""
            for text in noSpaceTextArray{
                searchTextFormatted = searchTextFormatted + text
//                if noSpaceTextArray.index(of: text) != noSpaceTextArray.count - 1 {
//                    searchTextFormatted = searchTextFormatted + "+"
//                }
            }
            // Add Search Text and API Key
            print("CHECCKKKK \(searchTextFormatted)")
            textSearchURL = textSearchURL + "query=" + searchTextFormatted
            textSearchURL = textSearchURL + "&key=" + GooglePlaceAccess.api_key.rawValue
            return textSearchURL
        }
        
        // Add Search Text and API Key
        textSearchURL = textSearchURL + "query=" + searchText
        textSearchURL = textSearchURL + "&key=" + GooglePlaceAccess.api_key.rawValue
        return textSearchURL
    }

    

    
    // Gets Places from Next Page Token Issued in Previous Response
    private class func getPlacesWithToken(nextPageToken : String, completionHandler: @escaping (Result<GooglePlaceWrapper>) -> Void) {
        
        let path = GoogleQuery.generateSearchURLFromToken(nextPageToken:nextPageToken)
        print("Requesting from Google Places at URL : \(path)")
        
        // Requesting Phase - Make Sure it's HTTPS Becuase Sometimes the API Gives Us HTTP URLs
        guard var urlComponents = URLComponents(string: path) else {
            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
            NSLog(FourSquareQueryError.urlError(reason: "Tried to load an invalid URL").localizedDescription)
            completionHandler(.failure(error))
            return
        }
        
        urlComponents.scheme = "https"
        guard let url = try? urlComponents.asURL() else {
            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
            NSLog(FourSquareQueryError.urlError(reason: "Tried to load an invalid URL").localizedDescription)
            completionHandler(.failure(error))
            return
        }
        
        // Request
        let _ = Alamofire.request(url).responseJSON { response in
            if let error = response.result.error {
                print(response)
                print(error)
                fatalError()
                completionHandler(.failure(error))
                return
            }
            // Create Wrapper of Places from Response - Places Over Max Places Put in Queue
            // Handle Errors in JSON Response
            let wrapper : GooglePlaceWrapper = GooglePlaceWrapper()
            
            // Result Wrapper Formatted as Result<GooglePlaceWrapper>
            let resultWrapper = wrapper.create(response:response)
            completionHandler(resultWrapper)
        }
    }
    
    
    // Get Places with Search Text and Lattitude and Longitude
    // To Do: Include other optional parameters to make search more flexible, this search is needed in addition to other Requests to get detailed data
    // or images.
    private class func getPlacesWithSearchText(searchText : String, lattitude : CGFloat, longitude : CGFloat, completionHandler: @escaping (Result<GooglePlaceWrapper>) -> Void) {
        
        let path = GoogleQuery.generateTextSearchURL(searchText: searchText, lattitude: lattitude, longitude: longitude)
        print("Requesting from Google Places at URL : \(path)")
        
        // Requesting Phase - Make Sure it's HTTPS Becuase Sometimes the API Gives Us HTTP URLs
        guard var urlComponents = URLComponents(string: path) else {
            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
            NSLog(FourSquareQueryError.urlError(reason: "Tried to load an invalid URL").localizedDescription)
            completionHandler(.failure(error))
            return
        }
        
        urlComponents.scheme = "https"
        guard let url = try? urlComponents.asURL() else {
            let error = FourSquareQueryError.urlError(reason: "Tried to load an invalid URL")
            NSLog(FourSquareQueryError.urlError(reason: "Tried to load an invalid URL").localizedDescription)
            completionHandler(.failure(error))
            return
        }
        
        // Request
        let _ = Alamofire.request(url).responseJSON { response in
            if let error = response.result.error {
                completionHandler(.failure(error))
                NSLog(response.result.error as! String )
                return
            }
            // Create Wrapper of Places from Response - Places Over Max Places Put in Queue
            // Handle Errors in JSON Response
            let wrapper : GooglePlaceWrapper = GooglePlaceWrapper()
            
            // Result Wrapper Formatted as Result<GooglePlaceWrapper>
            let resultWrapper = wrapper.create(response:response)
            completionHandler(resultWrapper)
        }
    }

    
}


