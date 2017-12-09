//
//  CorePhotos.swift
//  Pebl
//
//  Created by Nick Florin on 7/17/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

///////////////////////////////////////////////////////////////////////////
class core_user_photos {
    
    var managedObjectContext : NSManagedObjectContext
    
    var documentsDirectory: AnyObject?
    var documentsURL : URL?

    var fileManager : FileManager
    ////////////////////////////////
    init(){
        
        self.fileManager = FileManager.default
        
        // String Path for Photo Folder
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        self.documentsDirectory = paths[0] as AnyObject?
        
        // URL for Photo Folder
        self.documentsURL = self.fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]
        
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    }
    ////////////////////////////////
    func fetch_photo_item_by_id(_ photo_id:String) -> UserImage?{
        
        // Define Fetch Request and Unique ID
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserImage")
        let predicate = NSPredicate(format: "photo_id = %@", photo_id)
        
        // Assign Fetch Request Properties
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        // Handle results
        do {
            let fetchedResults = try self.managedObjectContext.fetch(fetchRequest)
            // If FetchedResults Not Empty
            if fetchedResults.count != 0 {
                
                if let fetchedUserPhotoItem: UserImage = fetchedResults[0] as? UserImage {
                    print("CorePhotos - Fetched Photo Object With ID = \(photo_id) Exists - Successful Fetch")
                    return fetchedUserPhotoItem
                }
            }
            // If FetchedResults is Empty
            else{
                print("CorePhotos - Fetched Photo Object With ID = \(photo_id) Doesn't Exist - Unsuccessful Fetch")
                return nil
            }
        }
        catch {
            print("CorePhotos - Error Fetching Object With ID = \(photo_id) Exists - Unsuccessful Fetch")
        }
        return nil
    }
    ////////////////////////////////
    // Fetches All Images in Core Data for User ID
    func fetch_all_photo_items_for_user(_ user_id:String) -> [UserImage]? {
        
        var photo_items : [UserImage] = []
        
        // Define Fetch Request and Unique ID
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserImage")
        // Handle results
        do {
            let fetchedResults = try self.managedObjectContext.fetch(fetchRequest)
            // If FetchedResults Not Empty
            if fetchedResults.count != 0 {
                print("CorePhotos - Fetching All Photo Objects With For User ID : \(user_id), Photo Objects Exist - Successful Fetch")
                for i in 0...fetchedResults.count-1{
                    if let fetchedPhoto: UserImage = fetchedResults[i] as? UserImage{
                        photo_items.append(fetchedPhoto)
                    }
                }
            }
            // If FetchedResults is Empty
            else{
                print("CorePhotos - No Photo Items for User ID : \(user_id), - Unuccessful Fetch")
                return photo_items
            }
        }
        catch {
            print("CorePhotos - Error Fetching All Photo Objects For User ID : \(user_id) - Unuccessful Fetch")
        }
        return photo_items
    }
    ///////////////////////////////////////////////////
    // Gets Photo IDS of All Photos Stored in Core Data for User ID
    func query_photo_ids(_ user_id:String)->[String]{
        
        let core_image_items = self.fetch_all_photo_items_for_user(user_id)
        var core_image_id_list : [String] = []
        for image_item in core_image_items!{
            core_image_id_list.append(image_item.photo_id!)
        }
        return core_image_id_list
    }
    ///////////////////////////////////////////////////
    // Saves UIImage Photo to Core Data
    func save_uiimage(_ user_id:String,photo_id:String,uiimage:UIImage){
        
        let imageData: Data = UIImagePNGRepresentation(uiimage)!
        
        // Check to See if Photo Already Exists
        let all_photo_ids = self.query_photo_ids(user_id)
        let exists = all_photo_ids.contains(photo_id)
        
        // Photo Item Already Exists - Edit Item
        if exists == true{
            let new_photo_item = self.fetch_photo_item_by_id(photo_id)
            new_photo_item!.photo = imageData
        }
        // Photo Item Doesn't Exist - Add Item
        else{
            // Define New Profile Info Item
            let new_photo_item = NSEntityDescription.insertNewObject(forEntityName: "UserImage", into: self.managedObjectContext) as! UserImage
            new_photo_item.photo_id = photo_id
            new_photo_item.photo = imageData
            new_photo_item.user_id = user_id
        }
        self.save_managed_object_context()
    }
    ////////////////////////////////////////////////////////
    // Finds Image Stored Locally in Documents Photo Folder and Saves to Core Data
    func save_local_image_to_core(_ user_id:String,photo_id:String,uiimage:UIImage){
        
        // Find Photo in Documents Directory
        let photoURL = self.documentsURL!.appendingPathComponent(photo_id)
        let imageData : Data = try! Data(contentsOf: photoURL)
        let uiimage = UIImage(data: imageData)
        self.save_uiimage(user_id,photo_id:photo_id,uiimage:uiimage!)
    }
    ///////////////////////////////////////////////////
    // Deletes UIImage Photo From Core Data
    func delete_user_image(_ photo_id:String){
        // Need to Do
    }
    ////////////////////////////////////////////////////
    func save_managed_object_context(){
        do {
            try self.managedObjectContext.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
}
