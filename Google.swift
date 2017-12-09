//
//  Google.swift
//  Pebl2
//
//  Created by Nick Florin on 2/7/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import UIKit


//////////////////////////////////////////////////////////////////////////////
// Convenience enum to help parse the JSON data
enum GooglePlaceFields:String {
    
    case ID = "id"
    case PlaceID = "place_id"
    case FormattedAddress = "formatted_address"
    case Reference = "reference"
    
    case Geometry = "geometry"
    case Icon = "icon"
    case Name = "name"
    
    case Photos = "photos"
    case PriceLevel = "price_level"
    case Rating = "rating"
    case Types = "types"
    
    case PhotoHeight = "height"
    case PhotoWidth = "width"
    case PhotoReference = "photo_reference"
    
    case Location = "location"
    case Lattitude = "lat"
    case Longitude = "lng"
    case Vicinity = "vicinity"
}

//////////////////////////////////////////////////////////////////////////////
// Defines the Access Points for Four Square API
enum GooglePlaceAccess : String {
    case api_key = "AIzaSyAC4Qm7qYKbIuvMhvSiVIkT_1yuiE6LZMY"
}

// Wrapper for Search Result of Image
class ImageSearchResult {
    
    let imageID : String
    let imageURL: String
    let source: String?
    var image: UIImage?
    
    // Flagged on 403 Error Where Quota Exceeded - Prevents Ugly Google Image from Showing
    var http403Error : Bool = false
    var http400Error : Bool = false
    
    required init(anImageID: String, anImageURL: String, aSource: String?) {
        imageID = anImageID
        imageURL = anImageURL
        source = aSource
    }
}



