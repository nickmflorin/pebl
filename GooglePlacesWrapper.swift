//
//  GooglePlacesWrapper.swift
//  Pebl2
//
//  Created by Nick Florin on 2/11/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import UIKit

// Wrapper for Google Places
class GooglePlaceWrapper : NSObject {
    
    var htmlAttributions : [String] = []
    var nextPageToken : String = ""
    var statusResponse : String = ""
    var errorMessage : String = ""
    var places : [GooglePlace] = []

    /////////////////////////////////
    override init() {

    }
    
    // Parses Response Data to Create Places in Wrapper
    func create(response: DataResponse<Any>) -> Result<GooglePlaceWrapper> {
        
        guard response.result.error == nil else {
            // Got Error Decoding the Data - Need to Handle It
            NSLog(response.result.error as! String)
            return .failure(response.result.error!)
        }
        
        // Make Sure We Got JSON and It Is Dictionary
        guard let json = response.result.value as? [String: Any] else {
            NSLog(FourSquareQueryError.urlError(reason:"Did not get JSON dictionary in response").localizedDescription)
            return .failure(FourSquareQueryError.objectSerialization(reason:"Did not get JSON dictionary in response"))
        }
        
        // Error Messages Passed on Invalid API Key Issues From Google
        if json["error_message"] != nil {
            self.errorMessage = json["error_message"] as! String
            NSLog(FourSquareQueryError.urlError(reason:self.errorMessage).localizedDescription)
            return .failure(FourSquareQueryError.urlError(reason: self.errorMessage))
        }

        
        // Error Messages Passed on Invalid API Key Issues From Google
        if json["error_message"] != nil {
            self.errorMessage = json["error_message"] as! String
            NSLog(FourSquareQueryError.urlError(reason:self.errorMessage).localizedDescription)
            return .failure(FourSquareQueryError.urlError(reason: self.errorMessage))
        }
        
        // Error Messages Passed on Invalid Request Issues From Google
        if json["status"] != nil {
            self.statusResponse = json["status"] as! String
            if self.statusResponse == "INVALID_REQUEST"{
                NSLog(FourSquareQueryError.urlError(reason:self.statusResponse).localizedDescription)
                return .failure(FourSquareQueryError.urlError(reason: self.statusResponse))
            }
        }
        
        // HTML Attributions [String] Used to Identify Parameters that Must Be Displayed to Users
        if json["html_attributions"] != nil {
            self.htmlAttributions = json["html_attributions"]! as! [String]
        }
        
        // Next Page Token Used to Request More Results
        if json["next_page_token"] != nil {
            self.nextPageToken = json["next_page_token"] as! String
        }
        
        // Attribute Place Array to Wrapper and Return as Success and Number of Returned Places
        if let results = json["results"] as? [[String: Any]] {
            for jsonPlace in results {
                
                let newPlace = GooglePlace(json: jsonPlace)
                self.places.append(newPlace)
            }
        }
        return .success(self)
    }
}
