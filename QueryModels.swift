//
//  FourSquareResultAttributes.swift
//  Pebl2
//
//  Created by Nick Florin on 2/16/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import UIKit

//////////////////////////////////////////
// FourSquare tips are broken down into self, friends, following and others.
// The first three are out of scope but may be used down the line, this one just focuses on the 
// tips from other users.

class FourSquareTip : NSObject {
    
    var id : String!
    var createdAt : Int!
    var type : String!
    var text : String!
    
    var agreeCount : Int!
    var disagreeCount : Int!
    
    var authorInteractionType : String! // Important
    
    var valid : Bool = false // Default
    var invalidReason : String!
    
    // Other parameters to include: CanonicalURl, photo, likes, agree count, disagree count, etc.
    // Might want to filter the tips by using the one that has the most likes or agreements
    // Might need to include user down the line, we need to look into this.
    
    // Required initialization - Can either be initialized with response data from details (tipJSON) or response data
    // from Tips endpoint
    
    
    // Init from Details Endpoint
    init(tipJson: [String: Any]) {
        
        // Need to Handle Error for Missing ID Here - Shouldn't Happen Often Though
        if let jsonID = tipJson["id"] {
            self.id = jsonID as! String
        }
        if let type = tipJson["type"] {
            self.type = type as! String
        }
        if let createdAt = tipJson["createdAt"] {
            self.createdAt = createdAt as! Int
        }
        // To do: Disclude all tips that don't have a text with them, this is the only thing we are 
        // interested in.
        if let text = tipJson["text"] {
            self.text = text as! String
        }
        if let agreeCount = tipJson["agreeCount"] {
            self.agreeCount = agreeCount as! Int
        }
        if let disagreeCount = tipJson["disagreeCount"] {
            self.disagreeCount = disagreeCount as! Int
        }
        
        if let authorInteractionType = tipJson["authorInteractionType"] {
            self.authorInteractionType = authorInteractionType as! String
        }
        
    }
    // Determine if the Tip object passes the qualification tests that we set and 
    // inform caller if it is valid/desired or not.
    func validate(){
        
        // To Do: Include other ways to determine if tip is desired/filter tip, possibly filtering 
        // out tips that have inappropriate words.
        guard self.text != nil && self.text != "" else {
            self.invalidReason = "Missing Tip Text"
            return
        }
        
        guard self.authorInteractionType != nil && self.authorInteractionType == "liked" else {
            self.invalidReason = "Invalid AuthorInteractionType"
            return
        }
        
        guard self.type != nil && self.type == "user" else {
            self.invalidReason = "Invalid Type"
            self.valid = false
            return
        }
        self.valid = true
        return
    }
}

//////////////////////////////////////////////////////////////////////////////
// Detail Result for a Single Request of a Venue
class FourSquareVenueDetailData : NSObject {
    
    //////////////////
    // MARK: Properties
    var id: String!
    var name : String!
    var url : String!
    
    var categories : [FourSquareCategory] = []
    var location : FourSquareLocation!
    
    var rating : CGFloat! // 1-10
    var ratingColor : String!
    var ratingSignals : String!
    var venueRatingBlacklisted : Bool! // Need to implement
    
    var tags : [String]!
    var tips : [FourSquareTip]! // Tips with 'Other' Type
    var desiredTip : FourSquareTip!
    
    var bestImageSearchResult : FourSquareVenueImageData! // Stores Photo Data for Best Image
    
    var priceTier : Int!
    var priceCurrency : String!
    var priceMessage : String!
    
    // Don't Parse Photos Here but We Can If We Want Additional Photos Other than Best Image
    
    // Need to implement these different features - may not need them ////////////////////////
    
    var contact : [String:AnyObject]!
    var hasPerk : Int!
    var hereNow : [String:AnyObject]!
    
    var specials : [String:AnyObject]!
    var stats : [String:AnyObject]!
    var referralID : [String:AnyObject]!
    var verified : Bool!
    var canonicalUrl : String!
    var listed : [String:AnyObject]!
    
    var attributes : [String:AnyObject]! // Could be useful
    var popular : [String:AnyObject]! // Could be useful
    var hours : [String:AnyObject]! // Could be useful
    var phrases : [String:AnyObject]! // Could be useful
    
    // Required initialization ////////////////////////////////////////////////////////////////////////
    required init(json: [String: Any]) {
        
        // Need to throw error if these are nil, we need these at all times.
        if json["id"] != nil {
            self.id = json["id"] as! String
        }
        if json["name"] != nil {
            self.name = json["name"] as! String
        }
        // Unpack location data
        if json["location"] != nil {
            let locationJson = json["location"] as! [String:AnyObject]
            self.location = FourSquareLocation(locationJson:locationJson)
        }
        // Parse Categories
        if json["categories"] != nil {
            let categoriesJson = json["categories"] as! [[String:AnyObject]]
            for categoryJson in categoriesJson {
                let newCategory = FourSquareCategory(categoryJson:categoryJson)
                self.categories.append(newCategory)
            }
        }
        
//        // Parse Tips ////////////////
//        if json["tips"] != nil {
//            let tipsJson = json["tips"] as! [String:AnyObject]
//            if tipsJson["groups"] != nil {
//                let groupsJson = tipsJson["groups"] as! [[String:AnyObject]]
//                // Find Others Tips
//                for groupJson in groupsJson {
//                    if groupJson["type"] != nil {
//                        if let type = groupJson["type"] as? String {
//                            if type == "others" {
//                                
//                                // Items corresponding to everybody's individual tips
//                                let otherTips = groupJson["items"] as! [[String:AnyObject]]
//                                self.tips = []
//                                
//                                var maxAgrees : Int = 0 // Keep track of most agreeable tip
//                                
//                                // Append tips to the list of tips associated with search result
//                                for tip in otherTips {
//                                    let newTip = FourSquareTip(tipJson: tip)
//                                    self.tips.append(newTip)
//                                    
//                                    if newTip.agreeCount != nil {
//                                        if newTip.agreeCount > maxAgrees {
//                                            maxAgrees = newTip.agreeCount
//                                            self.maxAgreeCountTip = newTip
//                                        }
//                                    }
//                                }
//                                
//                                
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
        // Parse Other First Level Data
        if json["url"] != nil {
            let url = json["url"] as! String
            self.url = url
        }
        // Parse Price Tier
        if json["price"] != nil {
            let priceJson = json["price"] as! [String:AnyObject]
            if priceJson["tier"] != nil {
                self.priceTier = priceJson["tier"] as! Int
            }
            if priceJson["message"] != nil {
                self.priceMessage = priceJson["message"] as! String
            }
            if priceJson["currency"] != nil {
                self.priceCurrency = priceJson["currency"] as! String
            }
        }
        
        if json["rating"] != nil {
            let rating = json["rating"] as! CGFloat
            self.rating = rating
        }
        if json["ratingColor"] != nil {
            let ratingColor = json["ratingColor"] as! String
            self.ratingColor = ratingColor
        }
        
        // Tags List
        if json["tags"] != nil {
            let tags = json["tags"] as! [String]
            self.tags = tags
        }
        
        // Store Best Photo Result for Image Access
        if json["bestPhoto"] != nil {
            let imageJson = json["bestPhoto"] as! [String:AnyObject]
            let imageResult = FourSquareVenueImageData(json: imageJson)
            self.bestImageSearchResult = imageResult
        }
    }
}



//////////////////////////////////////////
class FourSquareCategory : NSObject {
    
    var iconPrefix : String!
    var iconSuffix : String!
    var id : String!
    var name : String!
    var pluralName : String!
    var primary : Bool = false // Default
    var shortName : String!
    var neighborhood : String! // Only in Details Search
    
    // Required initialization
    required init(categoryJson: [String: Any]) {
        
        // Need to Handle Error for Missing ID Here - Shouldn't Happen Often Though
        if let jsonID = categoryJson["id"] {
            self.id = jsonID as! String
        }
        
        // Unwrap Icon Data
        if let iconJson = categoryJson["icon"] {
            let iconJsonUnwrapped = iconJson as! [String:Any]
            if let prefix = iconJsonUnwrapped["prefix"] {
                self.iconPrefix = prefix as! String
            }
            if let suffix = iconJsonUnwrapped["suffix"] {
                self.iconSuffix = suffix as! String
            }
        }
        
        // Unwrap Other First Level Data
        if let jsonName = categoryJson["name"] {
            self.name = jsonName as! String
        }
        if let jsonPluralName = categoryJson["pluralName"] {
            self.pluralName = jsonPluralName as! String
        }
        if let primary = categoryJson["primary"] {
            self.primary = primary as! Bool
        }
        if let shortName = categoryJson["shortName"] {
            self.shortName = shortName as! String
        }
    }
}

//////////////////////////////////////////
class FourSquareLocation : NSObject {
    
    var address : String = ""
    var crossStreet : String = ""
    var lattitude : CGFloat!
    var longitude : CGFloat!
    var distance : Int!
    var cc : String = ""
    var city : String = ""
    var state : String = ""
    var postalCode : Int!
    var country : String = ""
    var formattedAddress : [String] = []
    
    var neighborhood : String! // Only in Details Search
    
    // Required initialization
    required init(locationJson: [String: Any]) {
        
        if locationJson["address"] != nil {
            self.address = locationJson["address"] as! String
        }
        if locationJson["neighborhood"] != nil {
            self.neighborhood = locationJson["neighborhood"] as! String
        }        
        if locationJson["cc"] != nil {
            self.cc = locationJson["cc"] as! String
        }
        if locationJson["city"] != nil {
            self.city = locationJson["city"] as! String
        }
        if locationJson["state"] != nil {
            self.state = locationJson["state"] as! String
        }
        if locationJson["country"] != nil {
            self.country = locationJson["country"] as! String
        }
        if locationJson["crossStreet"] != nil {
            self.crossStreet = locationJson["crossStreet"] as! String
        }
        if locationJson["lng"] != nil {
            self.longitude = locationJson["lng"] as! CGFloat
        }
        if locationJson["lat"] != nil {
            self.lattitude = locationJson["lat"] as! CGFloat
        }
        if locationJson["distance"] != nil {
            self.distance = locationJson["distance"] as! Int
        }
        if locationJson["lat"] != nil {
            self.lattitude = locationJson["lat"] as! CGFloat
        }
        if locationJson["postalCode"] != nil {
            let postal = (locationJson["postalCode"] as! NSString).integerValue
            self.postalCode = postal
        }
        
        if locationJson["formattedAddress"] != nil {
            self.formattedAddress = locationJson["formattedAddress"] as! [String]
        }
       
        
    }
}

//////////////////////////////////////////////////////////////////////////////
class FourSquareVenueSearchData : NSObject{
    
    //////////////////
    // MARK: Properties
    var id: String!
    var name : String!
    var url : String!
    
    var categories : [FourSquareCategory] = []
    var contact : [String:AnyObject]! // Need to implement, don't know if we need to include this or not
    var hasPerk : Int! // Need to implement
    var hereNow : [String:AnyObject]! // Need to implement
    
    var specials : [String:AnyObject]! // Need to implement
    var stats : [String:AnyObject]! // Need to implement
    var referralID : [String:AnyObject]! // Need to implement
    
    var location : FourSquareLocation!
    
    // Additional Parameters to Possibly Include : Herenow, has perk, menu edit, stats, verified, specials
    
    // Required initialization
    required init(json: [String: Any]) {
        
        // Need to throw error if these are nil, we need these at all times.
        if json["id"] != nil {
            self.id = json["id"] as! String
        }
        if json["name"] != nil {
            self.name = json["name"] as! String
        }
        // Unpack location data
        if json["location"] != nil {
            let locationJson = json["location"] as! [String:AnyObject]
            self.location = FourSquareLocation(locationJson:locationJson)
        }
        
        // Parse Categories
        if json["categories"] != nil {
            let categoriesJson = json["categories"] as! [[String:AnyObject]]
            for categoryJson in categoriesJson {
                let newCategory = FourSquareCategory(categoryJson:categoryJson)
                self.categories.append(newCategory)
            }
        }
        
        // Parse Other First Level Data
        if json["url"] != nil {
            let url = json["url"] as! String
            self.url = url
        }
        
    }
}

//////////////////////////////////////////////////////////////////////////////
// Image Result for a Single Image of a Venue
class FourSquareVenueImageData : NSObject {
    
    //////////////////
    // MARK: Properties
    var id: String!
    
    var createdAt : Int!
    
    // Image Request Params
    var suffix : String!
    var prefix : String!
    var width : Int!
    var height : Int!
    
    var imageUrl : String! // -> Created in Parse Method
    
    // Original Source of Image (Url is not a requestable url but a domain name like instagram.com)
    var sourceName : String!
    var sourceUrl : String!
    
    var visibility : String! // Need to implement, don't know if we need to include this or not
    var checkin : [String:AnyObject]! // Need to implement, don't know if we need to include this or not
    var user : [String:AnyObject]! // Need to implement, don't know if we need to include this or not
    
    // Required initialization
    required init(json: [String: Any]) {
        
        // Handle Missing ID Here - ID is Required
        if json["id"] != nil {
            self.id = json["id"] as! String
        }
        
        // Also Necessary Info for Request
        if json["prefix"] != nil {
            self.prefix = json["prefix"] as! String
        }
        if json["suffix"] != nil {
            self.suffix = json["suffix"] as! String
        }
        if json["width"] != nil {
            self.width = json["width"] as! Int
        }
        if json["height"] != nil {
            self.height = json["height"] as! Int
        }
        
        // Not Necessary Below
        if json["createdAt"] != nil {
            self.createdAt = json["createdAt"] as! Int
        }
        
        if json["source"] != nil {
            let source = json["source"] as! [String:AnyObject]
            if source["name"] != nil {
                self.sourceName = source["name"] as! String
            }
            if source["url"] != nil {
                self.sourceUrl = source["url"] as! String
            }
        }
    }
    // Combines the response portions of the image from Foursquare to create/construct
    // the image URL
    func parseImageUrl() -> String{
        
        var url = ""
        
        // Need this info to generate an image url
        if self.suffix != nil && self.prefix != nil && self.height != nil && self.width != nil {
            let size = String(describing:self.width!) + "x" + String(describing:self.height!)
            url = self.prefix! + size + self.suffix!
            
            self.imageUrl = url // Store to Result
        }
        
        return url
        
    }
}


//////////////////////////////////////////
// Need to Make Better
class FourSquareExploreSearchResultReason : NSObject {
    
    var summary : String = ""
    var type : String = ""
    var reasonName : String = ""
    
    // Required initialization
    required init(json: [String: Any]) {
        if json["summary"] != nil {
            self.summary = json["summary"] as! String
        }
        if json["type"] != nil {
            self.type = json["type"] as! String
        }
        if json["reasonName"] != nil {
            self.reasonName = json["reasonName"] as! String
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
class FourSquareVenueExploreData : NSObject{
    
    //////////////////
    // MARK: Properties
    var venueID: String = ""
    var name : String = ""
    var contact : String = "" // Need to implement
    
    var reasons : [FourSquareExploreSearchResultReason] = []
    var tips : [String:AnyObject]! // Need to implement, don't know if we can include this or not
    
    var location : FourSquareLocation!
    var subCategoryID : String = ""
    var subCategoryName : String = ""
    
    var address : String = ""
    var city : String = ""
    var state : String = ""
    
    var rating : CGFloat!
    var bestPhotoUrl : String!
    var imageUrl : String!
    var url : String!
    
    var priceExp : String = ""
    var priceTier : Int!
    
    var lattitude : CGFloat!
    var longitude : CGFloat!
    
    var categoryNames : [String] = []
    var tags : [String] = []
    
    var venueImage : UIImage!
    var searchURL : String = ""
    
    // Required initialization
    required init(json: [String: Any]) {
        
        // Parse Reasons at Header of Venue Response
        if json["reasons"] != nil {
            let reasons = json["reasons"] as! [String:AnyObject]
            if reasons["items"] != nil {
                let reasonItems = reasons["items"] as! [[String:AnyObject]]
                for reasonItem in reasonItems {
                    let newReasonItem = FourSquareExploreSearchResultReason(json:reasonItem)
                    self.reasons.append(newReasonItem)
                }
            }
        }
        // To do: if this is nil there needs to be an error thrown, this should never be nil.
        if json["venue"] != nil {
            let venueData = json["venue"] as! [String:AnyObject]
            
            // Need to throw error if this is nil, we need the id at all times.
            if venueData["id"] != nil {
                self.venueID = venueData["id"] as! String
            }
            if venueData["name"] != nil {
                self.name = venueData[name] as! String
            }
            // Unpack location data
            if venueData["location"] != nil {
                let locationJson = venueData["location"] as! [String:AnyObject]
                self.location = FourSquareLocation(locationJson:locationJson)
            }
        }
    }
}

