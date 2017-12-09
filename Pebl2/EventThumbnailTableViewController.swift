//
//  EventThumbnailTableViewController.swift
//  Pebl
//
//  Created by Nick Florin on 10/20/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

let eventThumbnail_cellIdentifier = "EventThumbNailCell"


////////////////////////////////////////
class EventThumbnails: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    ////////////////////////////////////
    //MARK : Properties
    var ref: FIRDatabaseReference!
    var storageRef:FIRStorageReference!
    
    var events = [Event]()
    var event_ids = [String]()
    
    /////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        self.storageRef = FIRStorage.storage().reference()
        
        self.collectionView!.register(UINib(nibName: "ThumbnailCell", bundle: nil), forCellWithReuseIdentifier: "ThumbNailCellID")
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.backgroundColor = UIColor.red
    }
    /////////////////////////////////////
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout:layout)
    }
    ///////////////////////////////////////////
    // Adds a New Cell to Existing Event Collection
    func add_cell(_ eventInfo:Event){
        
        self.collectionView!.performBatchUpdates({
            
            let num_cells = self.events.count
            var arrayWithIndexPaths:[IndexPath] = []
            
            let index_path = IndexPath(row: num_cells, section: 0)
            arrayWithIndexPaths.append(index_path)
            
            //print("Adding Cell Info for : \(eventInfo.first_name) at \((index_path as NSIndexPath).item)", terminator: "")
            //self.item_dict[(index_path as NSIndexPath).item]=user_info_item
            //self.events.add(user_info_item)
            
            // Insert Items at Path
            self.collectionView!.insertItems(at: arrayWithIndexPaths as [IndexPath])
            },
                                                 completion: nil)
    }
    ////////////////////////////////////
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.events.count
    }
    ////////////////////////////////////
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventThumbnail_cellIdentifier, for: indexPath) as! EventThumbNailCell
        cell.contentView.isUserInteractionEnabled = true
        
        // Put Info in Cell
        //let eventItem = self.events[(indexPath as NSIndexPath).item] as! Event
        
        // Put Info in Cell
//        cell.user_name = info_item.user_name
//        cell.user_id = info_item.user_id
//        cell.profile_image = info_item.image
//        cell.first_name = info_item.first_name!
        
        cell.backgroundColor = UIColor.clear
        cell.isHighlighted = false
        cell.isSelected = false
        cell.clipsToBounds = true
        
        return cell
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
