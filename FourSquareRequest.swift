//
//  FourSquareUrls.swift
//  Pebl2
//
//  Created by Nick Florin on 3/13/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

//////////////////////////////////////////////////////////////////////////////
// Convenience enum to help parse the JSON data
enum FourSquareVenueFields:String {
    
    case VenueID = "id"
    case Name = "name"
    
    case Address = "address"
    case City = "city"
    case State = "state"
    
    case Rating = "rating"
    case BestPhotoUrl = "bestPhotoUrl"
    case ImageUrl = "imageUrl"
    case Url = "url"
    
    case Lattitude = "lat"
    case Longitude = "lng"
    
}

// Class to generate four square urls for desired request end points.
// Contains all of the static data necessary for four square requests.
struct FourSquareRequest {
    
    // Access Codes
    private enum FourSquareAccess : String {
        case clientID = "20EAKXFMT3ZFZCIGYMBD3UFP4S1EFI1RNJWUZADNQEA2Q5C0"
        case clientSecret = "TQF55UVC2C2IM5NM3ZY3YITE33AP54DSXMNR5WQUB4VCH4OL"
    }
    
    // MARK: Endpoints
    private static var exploreEndpoint = "https://api.foursquare.com/v2/venues/expore?"
    private static var searchEndpoint = "https://api.foursquare.com/v2/venues/search?"
    private static var venueEndpoint =  "https://api.foursquare.com/v2/venues/?"
    private static var detailEndpoint =  "https://api.foursquare.com/v2/venues/" // Notice No ?
    
    private static var requestLimit : Int = 50 // Represents Maximum Places to Retrieve Per Request
    private static var tipsSort = "popular" // Other Options: friends, recent
    private static var tipsLimit = 100
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    // URL Generation
    
    // Uses endpoint, lattitude and longitude to generate the full endpoint url for the API request
    static func generateTipsUrl(id : String) ->String {
        
        // Use Parameters and EndPoints to Create URL Path
        var tipsUrl = FourSquareRequest.detailEndpoint
        tipsUrl = tipsUrl + id + "/"
        
        // Tips Endpoint
        tipsUrl = tipsUrl + "tips?"
        
        // Other Parameters
        tipsUrl = tipsUrl + "sort=" + FourSquareRequest.tipsSort
        tipsUrl = tipsUrl + "&limit="+String(describing: FourSquareRequest.tipsLimit)
        
        // Access Codes
        tipsUrl = tipsUrl + "&client_id=" + FourSquareAccess.clientID.rawValue
        tipsUrl = tipsUrl + "&client_secret=" + FourSquareAccess.clientSecret.rawValue
        
        // To do: make date string dynamic and retrieve from current date
        let dateString : String = "20170215"
        tipsUrl = tipsUrl + "&v=" + dateString
        
        return tipsUrl
        
    }
    
    // Uses endpoint, lattitude and longitude to generate the full endpoint url for the API request
    static func generateExploreUrl(lattitude : CGFloat, longitude : CGFloat) ->String {
        
        // Use Parameters and EndPoints to Create URL Path
        var exploreUrl = FourSquareRequest.exploreEndpoint
        exploreUrl = exploreUrl + "&ll="+String(describing: lattitude)+","+String(describing: longitude)
        
        
        exploreUrl = exploreUrl + "&client_id=" + FourSquareAccess.clientID.rawValue
        exploreUrl = exploreUrl + "&client_secret=" + FourSquareAccess.clientSecret.rawValue
        
        // To do: make date string dynamic and retrieve from current date
        let dateString : String = "20170215"
        exploreUrl = exploreUrl + "&v=" + dateString
        
        
        return exploreUrl
    }
    
    // Uses endpoint, lattitude and longitude to generate the full endpoint url for the API request
    static func generateSearchUrl(lattitude : CGFloat, longitude : CGFloat) ->String {
        
        // Default Query for Now - Need to Update This
        let query = "bar"
        let radius = 2500
        // Need to provide category id as well to search for given categories
        
        // Use Parameters and EndPoints to Create URL Path
        var searchUrl = FourSquareRequest.searchEndpoint
        searchUrl = searchUrl + "&ll="+String(describing: lattitude)+","+String(describing: longitude)
        
        // Access Codes
        searchUrl = searchUrl + "&client_id=" + FourSquareAccess.clientID.rawValue
        searchUrl = searchUrl + "&client_secret=" + FourSquareAccess.clientSecret.rawValue
        
        // Limit
        searchUrl = searchUrl + "&limit="+String(describing:FourSquareRequest.requestLimit)
        
        // To do: make date string dynamic and retrieve from current date
        let dateString : String = "20170215"
        searchUrl = searchUrl + "&v=" + dateString
        
        searchUrl = searchUrl + "&radius="+String(describing:radius)
        searchUrl = searchUrl + "&query="+query
        
        return searchUrl
    }
    
    // Uses endpoint, and venue ID to create details url for the API request
    static func generateDetailUrl(id : String) ->String {
        
        // Use Parameters and EndPoints to Create URL Path
        var detailUrl = FourSquareRequest.detailEndpoint
        detailUrl = detailUrl + id + "?"
        
        // Access Codes
        detailUrl = detailUrl + "&client_id=" + FourSquareAccess.clientID.rawValue
        detailUrl = detailUrl + "&client_secret=" + FourSquareAccess.clientSecret.rawValue
        
        // To do: make date string dynamic and retrieve from current date
        let dateString : String = "20170215"
        detailUrl = detailUrl + "&v=" + dateString
        
        return detailUrl
    }

    
}
