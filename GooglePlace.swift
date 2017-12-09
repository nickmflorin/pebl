//
//  GooglePlace.swift
//  Pebl2
//
//  Created by Nick Florin on 2/11/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import UIKit


//////////////////////////////////////////////////////////////////////////////
// To Do: HTML Attributes that need to be stored and displayed to the user.  Tokens
// that can be used to generate the next 20 requests.

class GooglePlace : NSObject{
    
    //////////////////
    // MARK: Properties
    var ID: String = ""
    var placeID : String = ""
    var name : String = ""
    
    // Formatted Address Includes Full Mailing Address, Address
    // Split to Mirror 123 Apple Street (Example)
    var formattedAddress : String = ""
    var vicinity : String = "" // Vicinity or Formatted Address Dependign on Search Type
    
    var address : String = ""
    
    var city : String = "" // No Current Implementation
    var state : String = "" // No Current Implementation
    
    var rating : CGFloat!
    var priceLevel : Int!
    
    var reference : String = ""
    var icon : String = "" // Not Used
    
    var geometry : [String:Any]?
    var lattitude : CGFloat!
    var longitude : CGFloat!
    
    // Dictionary Data
    var photos : [String:Any]?
    
    var photoHeight : Int!
    var photoWidth : Int!
    var photoReference : String = ""
    
    var imageSearchResult : ImageSearchResult?
    
    var types : [String] = []
    
    // Required Initialization
    required init(json: [String: Any]) {
        
        super.init()
        
        // Store Places Data to Place Object - These Items Cannot be Nil
        self.ID = json[GooglePlaceFields.ID.rawValue] as! String
        self.placeID = json[GooglePlaceFields.PlaceID.rawValue] as! String
        self.name = json[GooglePlaceFields.Name.rawValue] as! String
        
        if json[GooglePlaceFields.Reference.rawValue] != nil {
            self.reference = json[GooglePlaceFields.Reference.rawValue] as! String
        }
        
        if json[GooglePlaceFields.FormattedAddress.rawValue] != nil {
            self.formattedAddress = json[GooglePlaceFields.FormattedAddress.rawValue] as! String
            self.parseFormattedAddress()
        }
        
        if json[GooglePlaceFields.FormattedAddress.rawValue] != nil {
            self.geometry = json[GooglePlaceFields.Geometry.rawValue] as! [String:Any]
            self.parseLocation()
        }
        
        if json[GooglePlaceFields.Icon.rawValue] != nil {
            self.icon = json[GooglePlaceFields.Icon.rawValue] as! String
        }
        
        if json[GooglePlaceFields.Icon.rawValue] != nil {
            self.icon = json[GooglePlaceFields.Icon.rawValue] as! String
        }
        
        if json[GooglePlaceFields.Rating.rawValue] != nil {
            self.rating = json[GooglePlaceFields.Rating.rawValue] as! CGFloat
        }
        
        if json[GooglePlaceFields.PriceLevel.rawValue] != nil {
            self.priceLevel = json[GooglePlaceFields.PriceLevel.rawValue] as! Int
        }
        
        // Retrieve Image References
        if json[GooglePlaceFields.Photos.rawValue] != nil {
            if let photosArray = json[GooglePlaceFields.Photos.rawValue] as? [[String:Any]], !photosArray.isEmpty {
                self.photos = photosArray[0]
                self.parsePhotos()
            }
        }
        
        if json[GooglePlaceFields.Vicinity.rawValue] != nil {
            self.vicinity = json[GooglePlaceFields.Vicinity.rawValue] as! String
        }
        
        // To Do: Type References
    }
    // Mark: Further Depth Dictionary Parsers for Response Data /////////////////////////
    
    // Parses Location Data (Geometry) to Get Lattitude and Longitude
    private func parseLocation(){
        
        if let geometry = self.geometry, let location = geometry[GooglePlaceFields.Location.rawValue] {
            if let geoLocation = location as? [String:Any] {
                
                if geoLocation[GooglePlaceFields.Lattitude.rawValue] != nil && geoLocation[GooglePlaceFields.Longitude.rawValue] != nil {
                    self.lattitude = geoLocation[GooglePlaceFields.Lattitude.rawValue] as! CGFloat!
                    self.longitude = geoLocation[GooglePlaceFields.Longitude.rawValue] as! CGFloat!
                }
            }
        }
    }
    
    // Parses Formatted Address Into Different Components
    private func parseFormattedAddress(){
        if self.formattedAddress != "" {
            var addressArray = self.formattedAddress.components(separatedBy: ",")
            self.address = addressArray[0]
        }
    }
    // Parse the Photo Array to Get Photo Data
    private func parsePhotos(){
        if let photos = self.photos {
            
            if photos[GooglePlaceFields.PhotoWidth.rawValue] != nil {
                self.photoWidth = photos[GooglePlaceFields.PhotoWidth.rawValue] as! Int
            }
            if photos[GooglePlaceFields.PhotoHeight.rawValue] != nil {
                self.photoHeight = photos[GooglePlaceFields.PhotoHeight.rawValue] as! Int
            }
            if photos[GooglePlaceFields.PhotoReference.rawValue] != nil {
                self.photoReference = photos[GooglePlaceFields.PhotoReference.rawValue] as! String
            }
            
        }
        
    }
    
        
    
    //// Mark: API Requesting /////////////////////
    func loadImage(maxWidth: Int,maxHeight: Int,completionHandler: @escaping (Result<ImageSearchResult>) -> Void){
        
        // Get the Search URL
        guard self.photoReference != "" else {
            completionHandler(.failure(FourSquareQueryError.urlError(reason: "Cannot Find Image - Photo Reference Missing")))
            return
        }
        let photoURL = GoogleQuery.generatePhotoURL(photoRef: self.photoReference,maxWidth: maxWidth,maxHeight: maxHeight)
        print("Requesting Google Places Image for : \(self.name)")
        
        Alamofire.request(photoURL).response { response in
            
            guard let imageData = response.data else {
                NSLog(FourSquareQueryError.urlError(reason:"Could not get image from image URL returned in search results").localizedDescription)
                completionHandler(.failure(FourSquareQueryError.objectSerialization(reason:"Could not get image from image URL returned in search results")))
                return
            }
            let result = ImageSearchResult(anImageID: self.photoReference, anImageURL: photoURL, aSource: "google")
            result.image = UIImage(data: imageData)
            
            // TO DO : Better handling of 403 and 400 Errors from Google Places API
            if response.response?.statusCode == 400{
                NSLog(FourSquareQueryError.urlError(reason:"http400Error").localizedDescription)
                result.http400Error = true
                completionHandler(.failure(FourSquareQueryError.urlError(reason:"http400Error")))
                return
            }
            if response.response?.statusCode == 403{
                NSLog(FourSquareQueryError.urlError(reason:"http403Error").localizedDescription)
                result.http403Error = true
                completionHandler(.failure(FourSquareQueryError.urlError(reason:"http403Error")))
                return
            }
            
            // Store Image Wrapper to This Object
            self.imageSearchResult = result
            completionHandler(.success(result))
        }
    }
    
    
}




