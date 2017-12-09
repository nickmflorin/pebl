//
//  FourSquarePlacesWrapper.swift
//  Pebl2
//
//  Created by Nick Florin on 2/13/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import UIKit

// Wrappers should contain a list of result objects only if the wrapper
// is associated with multiple venues.  A single venue with multiple objecst 
// (i.e. tips or images) is associated with a single result object, the result object
// will contain the list of models associated with the different tips or images.

//////////////////////////////////////////////////////
// Base Response Wrapper Inherited by Other Response Objects
class ResponseWrapper : NSObject {
    
    var statusCode : Int!
    var requestID : String = ""
    var totalResults : Int = 0
    var responseJson : [String: Any]!
    /////////////////////////////////
    override init() {
        
    }
    // Stores Response Data with Header to All Wrapper Objects
    func storeResponseData(response: DataResponse<Any>)-> Result<ResponseWrapper>{
        
        guard response.result.error == nil else {
            // Got Error Decoding the Data - Need to Handle It
            let error = response.result.error
            log.error(error?.localizedDescription ?? "Error Decoding Response Data")
            return .failure(response.result.error!)
        }
        
        // Make Sure We Got JSON and It Is Dictionary
        guard let json = response.result.value as? [String: Any] else {
            let error = FourSquareQueryError.urlError(reason:"Did not get JSON dictionary in response")
            log.error(error.localizedDescription)
            return .failure(error)
        }
        
        // Main Response Content
        guard (json["response"] as? [String: Any]) != nil else {
            let error = FourSquareQueryError.urlError(reason:"Did not get JSON dictionary in response")
            log.error(error.localizedDescription)
            return .failure(error)
        }
        
        // Meta Data in Response Header ////////////////////////////////
        if let meta = json["meta"] as? [String: Any] {
            if meta["code"] != nil {
                self.statusCode = meta["code"] as! Int
            }
            if meta["requestID"] != nil {
                self.requestID = meta["requestId"] as! String
                log.info("Request ID : \(self.requestID)")
            }
        }
        // Handle Status Error Code Here Before Proceeding
        
        // Main Response JSON
        self.responseJson = json["response"] as! [String: Any]
        return .success(self)
    }
}



// We need to have a wrapper for each endpoint request
//////////////////////////////////////////////////////
// Wrapper for FourSquare Details for Single Venue
class FourSquareTipsWrapper : ResponseWrapper{
    
    // Results of Search Attributed to Wrapper
    var tips : [FourSquareTip] = []
    
    /////////////////////////////////
    override init() {
    }
    
    // Parses Response Data to Create Places in Wrapper
    func create(response: DataResponse<Any>) -> Result<FourSquareTipsWrapper> {
        
        // Handle Response
        let responseResult = self.storeResponseData(response: response)
        if responseResult.error != nil {
            return .failure(responseResult.error!)
        }
        
        // List of Photo Datas ////////////////////////////////
        if self.responseJson["tips"] != nil {
            var itemsJson = self.responseJson["tips"] as! [String:AnyObject]
            
            if itemsJson["count"] != nil {
                self.totalResults = itemsJson["count"] as! Int
            }
            
            // Loop Through Groupings and Parse - Handle Error if Items Not Present
            if itemsJson["items"] != nil {
                let tipsJson = itemsJson["items"] as! [[String:AnyObject]]
                for tipJson in tipsJson {
                    let newTip = FourSquareTip(tipJson: tipJson)
                    self.tips.append(newTip)
                }
            }
            
            // Only Return Success if Items Present
            return .success(self)
        }
        // Return Error if Venues Didn't Exist in Response
        return .failure(FourSquareQueryError.objectSerialization(reason:"Error Decoding Json"))
    }
}


//////////////////////////////////////////////////////
// Wrapper for FourSquare Details for Single Venue
class FourSquareDetailWrapper : ResponseWrapper {
    
    // Single Result Stored in Wrapper
    var detailData : FourSquareVenueDetailData!
    
    /////////////////////////////////
    override init() {
    }
    
    // Parses Response Data to Create Places in Wrapper
    func create(response: DataResponse<Any>) -> Result<FourSquareDetailWrapper> {
        
        // Handle Response
        let responseResult = self.storeResponseData(response: response)
        if responseResult.error != nil {
            return .failure(responseResult.error!)
        }
        
        // List of Photo Datas ////////////////////////////////
        if responseJson["venue"] != nil {
            let venueJson = responseJson["venue"] as! [String:AnyObject]
            // Single Result for Single Venue
            self.detailData = FourSquareVenueDetailData(json:venueJson)
            return .success(self)
        }
        // Return Error if Venues Didn't Exist in Response
        return .failure(FourSquareQueryError.objectSerialization(reason:"Error Decoding Json"))
    }
}


//////////////////////////////////////////////////////
// Wrapper for FourSquare Images for Single Venue
class FourSquareImageWrapper : ResponseWrapper {
    
    // Results of Search Attributed to Wrapper
    var imagesData : [FourSquareVenueImageData] = []
    
    /////////////////////////////////
    override init() {
    }
    
    // Parses Response Data to Create Places in Wrapper
    func create(response: DataResponse<Any>) -> Result<FourSquareImageWrapper> {
        
        // Handle Response
        let responseResult = self.storeResponseData(response: response)
        if responseResult.error != nil {
            return .failure(responseResult.error!)
        }
        
        // List of Photo Datas ////////////////////////////////
        if responseJson["photos"] != nil {
            var photosJson = responseJson["photos"] as! [String:AnyObject]
            
            if responseJson["count"] != nil {
                self.totalResults = responseJson["count"] as! Int
            }
            if photosJson["items"] != nil {
                let itemsJson = photosJson["items"] as! [[String:AnyObject]]
                
                // Create Search Results from Items
                for itemJson in itemsJson{
                    let newResult = FourSquareVenueImageData(json:itemJson)
                    self.imagesData.append(newResult)
                    
                }
                // Only Return Success if Items Present
                return .success(self)
            }
        }
        // Return Error if Venues Didn't Exist in Response
        return .failure(FourSquareQueryError.objectSerialization(reason:"Error Decoding Json"))
    }
}


//////////////////////////////////////////////////////
// Wrapper for FourSquare Places Explore Feature
class FourSquareSearchWrapper : ResponseWrapper {
    
    // Results of Search Attributed to Wrapper
    var searchData : [FourSquareVenueSearchData] = []
    
    /////////////////////////////////
    override init() {
    }
    
    // Parses Response Data to Create Places in Wrapper
    func create(response: DataResponse<Any>) -> Result<FourSquareSearchWrapper> {
        
        // Handle Response
        let responseResult = self.storeResponseData(response: response)
        if responseResult.error != nil {
            return .failure(responseResult.error!)
        }
        
        // List of Venues ////////////////////////////////
        if responseJson["venues"] != nil {
            let venues = responseJson["venues"] as! [[String:AnyObject]]
            
            for venueJson in venues{
                let newResult = FourSquareVenueSearchData(json:venueJson)
                self.searchData.append(newResult)
                totalResults = totalResults+1
            }
            
            return .success(self)
        }
        // Return Error if Venues Didn't Exist in Response
        return .failure(FourSquareQueryError.objectSerialization(reason:"Error Decoding Json"))
    }
}
//////////////////////////////////////////////////////
// Wrapper for FourSquare Places Explore Feature
class FourSquareExploreWrapper : ResponseWrapper {
    
    // Carried in response header
    var suggestedFilters : [String:AnyObject]! // Need to Implement
    var suggestedFiltersHeader : String = ""
    var filters : [String:AnyObject]!
    
    var suggestedRadius : Int!
    var headerLocation : String = ""
    var headerFullLocation : String = ""
    var headerLocationGranularity : String = ""
    
    var groupType : String = ""
    var groupName : String = ""
    var reasons : [String:AnyObject]! // Need to Implement
    
    // Results of Search Attributed to Wrapper
    var exploreData : [FourSquareVenueExploreData] = []
    
    /////////////////////////////////
    override init() {
        
    }
    
    // Parses Response Data to Create Places in Wrapper
    func create(response: DataResponse<Any>) -> Result<FourSquareExploreWrapper> {
        
        // Handle Response
        let responseResult = self.storeResponseData(response: response)
        if responseResult.error != nil {
            return .failure(responseResult.error!)
        }
        
        // Header Details /////////////////////////////////
        if responseJson["suggestedRadius"] != nil {
            self.suggestedRadius = responseJson["suggestedRadius"] as! Int
        }

        if responseJson["headerLocation"] != nil {
            self.headerLocation = responseJson["headerLocation"] as! String
        }

        if responseJson["headerFullLocation"] != nil {
            self.headerFullLocation = responseJson["headerFullLocation"] as! String
        }
        
        if responseJson["headerLocationGranularity"] != nil {
            self.headerLocationGranularity = responseJson["headerLocationGranularity"] as! String
        }
        
        if responseJson["totalResults"] != nil {
            self.totalResults = responseJson["totalResults"] as! Int
        }
        
        // Grouping Response Header ////////////////////////////////
        if responseJson["groups"] != nil {
            var groups = responseJson["groups"] as! [String:AnyObject]
            
            if groups["type"] != nil {
                self.groupType = responseJson["groupType"] as! String
            }
            if groups["name"] != nil {
                self.groupName = responseJson["groupName"] as! String
            }
            if groups["items"] != nil {
                let items = groups["items"] as! [[String:AnyObject]]
                for item in items {
                    let newExploreDataPoint = FourSquareVenueExploreData(json: item)
                    self.exploreData.append(newExploreDataPoint)
                }
                return .success(self)
            }            
        }
        return .failure(FourSquareQueryError.objectSerialization(reason:"Error Decoding Json"))
    }
}
