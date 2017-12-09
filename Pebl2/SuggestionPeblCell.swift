////
////  SuggestionPeblTableVC.swift
////  Pebl
////
////  Created by Nick Florin on 10/5/16.
////  Copyright © 2016 Nick Florin. All rights reserved.
////
//
import Foundation
import FirebaseAuth
import Firebase
import FirebaseDatabase

let suggestion_cellIdentifier = "SuggestionPeblTableViewCell"

////////////////////////////////////////////////////////////////////////////////
class SuggestionPeblTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var profilePhoto: UIButton!
    @IBOutlet weak var firstNameField: UILabel!
    @IBOutlet weak var eventSliderCollection: SuggestedEventSliderView!
    
    // Information Parameters
    var user_id : String!
    var indexPath : IndexPath!
    var user : User!
    
    var indexPathEvents : [IndexPath:SuggestedEvent]=[:]
    var suggestedEvents : [SuggestedEvent] = []
    var suggestionPebls : [SuggestionPebl] = []
    
    //////////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Styling
        self.backgroundColor = UIColor.clear
        self.profilePhoto.layer.borderWidth = 1.0
        self.profilePhoto.layer.cornerRadius = 3.0
        self.profilePhoto.layer.borderColor = secondaryColor.cgColor
        self.profilePhoto.layer.masksToBounds = true
        
        // Initialization Code
        self.isHighlighted = false
        self.isSelected = false
        self.clipsToBounds = true
        
        // Delegate and Datasource to Collection View
        eventSliderCollection.delegate = self
        eventSliderCollection.dataSource = self
    }
    //////////////////////////////
    // Performs Initial Setup After Pebls Assigned to Cell
    func setup(){
        
        // Get User Info from First Suggestion Pebl
        let firstPebl : SuggestionPebl = self.suggestionPebls[0]
        self.user = firstPebl.user
        self.user_id = firstPebl.userID
        
        //self.firstNameField.text = firstPebl.user?.userInfo.first_name
        
        // Add Profile Image
        if let profileImage : UIImage = firstPebl.user?.userInfo.profileImage{
            self.profilePhoto.setImage(profileImage, for: .normal)
        }
        
        // Parse Through Suggestion PEbls and Get Suggested Events From User
        for pebl in self.suggestionPebls{
            
            // Get Event From Pebl
            if let suggestedEvent : SuggestedEvent = pebl.suggestedEvent {
                
                // Store Event Associated with Index Path
                let indexPath = IndexPath(item: self.suggestionPebls.count-1, section: 0)
                self.indexPathEvents[indexPath]=suggestedEvent
                
                // Add Suggested Event to the Collection View
                self.addSuggestedEvent(suggestedEvent)
            }
            
        }
        
    }
    //////////////////////////////
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    ///////////////////////////////////////////
    // Adds Suggestion Pebls to Event Slider
    // Adds a New Cell to Existing Event Collection
    func addSuggestedEvent(_ eventSuggestion:SuggestedEvent){

        self.eventSliderCollection.performBatchUpdates({
            
            self.suggestedEvents.append(eventSuggestion)
            let num_cells = self.suggestedEvents.count-1
            let index_path = IndexPath(row: num_cells, section: 0)
            
            print("Adding New Event to Thumbnails for Event : \(eventSuggestion.event_name) at Index : \(index_path)")
            print("Current Number of Events After Addition : \(num_cells)")
            
            self.indexPathEvents[index_path]=eventSuggestion
            
            // Create Index Path Array for Update
            var arrayWithIndexPaths : [IndexPath] = []
            arrayWithIndexPaths.append(index_path)
            
            // Insert Items
            self.eventSliderCollection.insertItems(at: arrayWithIndexPaths)
            }, completion:nil)
    }
    ////////////////////////////////////
    // Mark: Collection View Data Source
    
    ////////////////////////////////////
    // 0 Sections Keeps Collection View Only Horizontal
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    ////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.suggestedEvents.count
    }
    ////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        // Create New Thumbnail Cell and Set Up Cell
        let newCell = self.eventSliderCollection.dequeueReusableCell(withReuseIdentifier: SuggestedEventCollectionViewCell_Identifier, for: indexPath) as! SuggestedEventCollectionViewCell
        newCell.contentView.isUserInteractionEnabled = true
        
        // Find Message Pebl Corresponding to Index Path
        let suggestedEvent = self.indexPathEvents[indexPath]
        newCell.suggestedEvent = suggestedEvent
        newCell.setup()
        return newCell
    }

}

