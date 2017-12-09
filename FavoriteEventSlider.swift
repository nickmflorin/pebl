//
//  FavoriteCollectionViewCell.swift
//  Pebl2
//
//  Created by Nick Florin on 1/24/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

let FavoriteCollectionViewCell_Identifier = "FavoriteCollectionViewCell"

//////////////////////////////////////////////////////////////////////////
class FavoriteEventSlider: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var indexPathEvents : [IndexPath:Venue]=[:]
    var favoritedVenueIDs : [String] = []
    var favoritedVenues : [Venue] = []
    
    /////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell_Identifier)
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.backgroundColor = UIColor.clear
    }
    /////////////////////////////////////
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout:layout)
    }
    ///////////////////////////////////////////
    // Adds a New Cell to Existing Event Collection
    func addVenue(_ venue:Venue){

        self.collectionView!.performBatchUpdates({
            
            self.favoritedVenues.append(venue)
            self.favoritedVenueIDs.append(venue.id)
            let num_cells = self.favoritedVenues.count
            
            let index_path = IndexPath(row: num_cells - 1, section: 0)
            self.indexPathEvents[index_path]=venue

            // Create Index Path Array for Update
            var arrayWithIndexPaths : [IndexPath] = []
            arrayWithIndexPaths.append(index_path)
  
            // Insert Items
            self.collectionView!.insertItems(at: arrayWithIndexPaths)
        }, completion:nil)
    }
    ////////////////////////////////////
    // Mark: Collection View Data Source
    
    ////////////////////////////////////
    // 0 Sections Keeps Collection View Only Horizontal
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    ////////////////////////////////////
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favoritedVenues.count
    }
    ////////////////////////////////////
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        // Create New Thumbnail Cell and Set Up Cell
        let newCell = self.collectionView!.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell_Identifier, for: indexPath) as! FavoriteCollectionViewCell
        newCell.contentView.isUserInteractionEnabled = true
        
        // Find Message Pebl Corresponding to Index Path
        let venue = self.indexPathEvents[indexPath]
        newCell.indexPath = indexPath
        
        newCell.clipsToBounds = true
        newCell.layer.borderColor = accentColor.cgColor
        newCell.layer.borderWidth = 1.0
        newCell.layer.cornerRadius = 3.0
        
        newCell.setup(venue!)
        return newCell
    }
    ////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

