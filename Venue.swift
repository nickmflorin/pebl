//
//  Venue.swift
//  Pods
//
//  Created by Nick Florin on 2/16/17.
//
//

import Foundation
import UIKit
import Alamofire

//////////////////////////////////////////////////////////////////////////////
// This is our main venue object that we are going to use, all other search result objects
// will map to this to create a consistent object that has only the data that we want.
class Venue : NSObject{
    
    //////////////////
    // MARK: Properties
    var id: String!
    var name : String!
    var location : FourSquareLocation!
    
    var rating : CGFloat!
    var photoUrl : String!
    var url : String!
    
    var tags : [String]!
    var categories : [FourSquareCategory]!
    
    var priceMessage : String!
    var priceTier : Int!
    var priceCurrency : String!
    
    var image : UIImage!
    var imageUrl : String!
    var bestImageSearchResult : FourSquareVenueImageData!
    
    var tips : [FourSquareTip]! // Tips with 'Other' Type
    var desiredTip : FourSquareTip!
    
    var valid : Bool = true // Default
    var invalidReason : String = ""
    
    // Required Initialization
    required init(id:String) {
        self.id = id
    }
    // Validates the Venue to see if it meets the criteria that we deem required
    // for us to include the venue in our events selection.
    func validate(){
        
        // ID and Name Should Already be Validated
        if self.name == nil  {
            self.valid = false
            self.invalidReason = "No Name"
            return
        }
        if self.name == nil || self.location == nil {
            self.valid = false
            self.invalidReason = "No Location"
            return
        }
        if self.desiredTip == nil{
            self.valid = false
            self.invalidReason = "No Agreed Upon Tip"
            return
        }
        if self.image == nil{
            self.valid = false
            self.invalidReason = "No Image"
            return
        }
        
        
    }
    // Sifts through the venue tips and associates the desired tip with the best
    // qualified tip in the group.
    func findDesiredTip(){
        
        if self.tips != nil && self.tips.count != 0 {
            for tip in self.tips{
                tip.validate()
                // To Do : Find more recent desired tip, don't just grab the first one
                if tip.valid{
                    self.desiredTip = tip
                    return
                } 
            }
        }
    }
    
    // Create Venue or Attribute Data from Search Result
    func attribute(fourSquareVenueSearchData:FourSquareVenueSearchData){
        
        // Store Data from Search Result
        if fourSquareVenueSearchData.name != nil {
            self.name = fourSquareVenueSearchData.name
        }
        if fourSquareVenueSearchData.url != nil {
            self.url = fourSquareVenueSearchData.url
        }
        if fourSquareVenueSearchData.location != nil {
            self.location = fourSquareVenueSearchData.location
        }
    }
    
    // Create Venue or Attribute Data from Search Result
    func attribute(fourSquareTips:[FourSquareTip]){
        self.tips = fourSquareTips
        // Find Best Tip, Determine Which Tips are Valid and Invalid
    }
    
    // Attribute FourSquareDetailResult Result to Venue
    func attribute(fourSquareVenueDetailData:FourSquareVenueDetailData){
        
        // Store Data from Detail Result
        if fourSquareVenueDetailData.name != nil {
            self.name = fourSquareVenueDetailData.name
        }
        if fourSquareVenueDetailData.rating != nil {
            self.rating = fourSquareVenueDetailData.rating
        }
        if fourSquareVenueDetailData.bestImageSearchResult != nil {
            self.bestImageSearchResult = fourSquareVenueDetailData.bestImageSearchResult
        }
        if fourSquareVenueDetailData.location != nil {
            self.location = fourSquareVenueDetailData.location
        }
        if fourSquareVenueDetailData.tags != nil {
            self.tags = fourSquareVenueDetailData.tags
        }
        if fourSquareVenueDetailData.categories != nil {
            self.categories = fourSquareVenueDetailData.categories
        }
        if fourSquareVenueDetailData.priceMessage != nil {
            self.priceMessage = fourSquareVenueDetailData.priceMessage
        }
        if fourSquareVenueDetailData.priceCurrency != nil {
            self.priceCurrency = fourSquareVenueDetailData.priceCurrency
        }
        if fourSquareVenueDetailData.priceTier != nil {
            self.priceTier = fourSquareVenueDetailData.priceTier
        }
        if fourSquareVenueDetailData.tips != nil {
            self.tips = fourSquareVenueDetailData.tips
        }
        // Location, name and url already included in main search.  Need to include later if we are not
        // performing the base search before this result is retrieved.
    }
    // Parses the Category objects to create a string of categories for the event descriptions.
    func createCategoryString()->String{
        var categoryString = ""
        
        var count = 1
        if self.categories != nil {
            for category in self.categories{
                categoryString = categoryString + category.shortName
                if count != self.categories.count {
                    categoryString = categoryString + ", "
                }
                count = count + 1
            }
        }
        return categoryString
    }
    // Creates a string representation of Integer Price Field by counting the price tier and denoting each level as $
    func createPriceString()->String{
        var priceString : String = ""
        if self.priceTier != nil {
            for _ in 0...self.priceTier {
                priceString = priceString + "$"
            }
        }
        return priceString
    }
    
    //// Mark: API Requesting /////////////////////
    // Venue image loaded depending on the image URL that was supplied by any of the available different search results.
    func loadImage(_ completionHandler: @escaping (Result<UIImage>) -> Void){
        
        // Get the Search URL
        guard self.bestImageSearchResult != nil else {
            completionHandler(.failure(FourSquareQueryError.urlError(reason: "Cannot Find Image - Image Result Missing")))
            return
        }
        let imageUrl = bestImageSearchResult.parseImageUrl()
        self.imageUrl = imageUrl
        
        print("Requesting FourSquare Image for : \(self.name)")

        Alamofire.request(imageUrl).response { response in

            guard let imageData = response.data else {
                completionHandler(.failure(FourSquareQueryError.objectSerialization(reason:"Could not get image from image URL returned in search results")))
                return
            }

            // TO DO : Better handling of 403 and 400 Errors from Google Places API
            if response.response?.statusCode == 400{
                completionHandler(.failure(FourSquareQueryError.urlError(reason:"http400Error")))
                return
            }
            if response.response?.statusCode == 403{
                completionHandler(.failure(FourSquareQueryError.urlError(reason:"http403Error")))
                return
            }
            // Successful Return and Conversion
            let convertedImage = UIImage(data: imageData)
            
            guard convertedImage != nil else {
                completionHandler(.failure(FourSquareQueryError.objectSerialization(reason:"Could not get convert image to UIImage")))
                return
            }
            self.image = convertedImage // Store Image Result to This Object
            completionHandler(.success(convertedImage as! UIImage!))
            return

        }
    }
    
}
