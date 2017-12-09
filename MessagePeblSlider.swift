//
//  MessagePeblSlider.swift
//  Pebl2
//
//  Created by Nick Florin on 12/28/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

let MessagePeblCollectionViewCell_Identifier = "MessagePeblCollectionViewCell"

//////////////////////////////////////////////////////////////////////////
class MessagePeblCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    var imageView: UIImageView!
    var profileImage: UIImage!
    var ageLabel : UILabel!
    var nameLabel : UILabel!
    
    var messagePebl : MessagePebl!
    
    var indexPath : IndexPath!
    var imageViewInsets : CGFloat = 2.0
    
    var nameLabelColor : UIColor = secondaryColor
    var ageLabelColor : UIColor = secondaryColor
    
    var nameLabelWidth : CGFloat = 80.0
    var ageLabelWidth : CGFloat = 20.0
    
    var nameLabelFont = UIFont (name: "SanFranciscoDisplay-Medium", size:14)
    var ageLabelFont = UIFont (name: "SanFranciscoDisplay-Regular", size:14)
    var labelVPadding : CGFloat = 2.0
    var labelHeight : CGFloat = 14.0
    
    var imageViewCornerRadius : CGFloat = 4.5
    var imageViewBorderColor : UIColor = UIColor.lightGray
    var imageViewBorderWidth : CGFloat = 1.5
    //////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //////////////////////////////
    // Init for Drawing Underlying
    override func draw(_ rect: CGRect) {
        
        
    }
    /////////////////////////////////////
    func setup(_ messagePebl:MessagePebl) {
        
        self.backgroundColor = UIColor.clear
        self.messagePebl = messagePebl
        self.createImage()
        self.createLabels()
    }
    /////////////////////////////////////
    func createImage(){
        
        let imageWidth = self.bounds.width - 2.0*imageViewInsets
        let imageHeight = imageWidth
        
        let imageViewFrame = CGRect(x: self.bounds.minX + imageViewInsets, y: self.bounds.minY + imageViewInsets, width: imageWidth, height: imageHeight)
        imageView = UIImageView(frame: imageViewFrame)
        imageView.image = messagePebl.user?.userInfo.profileImage
  
        imageView.layer.cornerRadius = imageViewCornerRadius
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = imageViewBorderWidth
        imageView.layer.borderColor = imageViewBorderColor.cgColor
        imageView.layer.masksToBounds = true
        
        self.addSubview(imageView)
    }
    /////////////////////////////////////
    // Creates Name and Age Labels
    func createLabels(){
        
        let nameLabelFrame = CGRect(x: self.imageView.frame.minX, y: self.imageView.frame.maxY+labelVPadding, width: nameLabelWidth, height: labelHeight)
        nameLabel = UILabel(frame: nameLabelFrame)
        
        //nameLabel.text = self.messagePebl.user?.userInfo.first_name
        nameLabel.font = self.nameLabelFont
        self.nameLabel.textColor = self.nameLabelColor
        
        self.addSubview(self.nameLabel)
        
        // Label Frame Will Be Updated After Age Label is Sized to Fit
//        let ageLabelFrame = CGRect(x: self.imageView.frame.maxX, y: self.imageView.frame.maxY+labelVPadding, width: 80.0, height: labelHeight)
//        ageLabel = UILabel(frame: ageLabelFrame)
//        
//        ageLabel.text = self.messagePebl.user?.userInfo.age
//        ageLabel.font = self.ageLabelFont
//        ageLabel.textColor = self.ageLabelColor
//        ageLabel.sizeToFit()
//        
//        let width = ageLabel.frame.width
//        ageLabel.frame = CGRect(x: self.imageView.frame.maxX-width, y: self.imageView.frame.maxY+labelVPadding, width: width, height: labelHeight)
//        self.addSubview(self.ageLabel)
    }
    /////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//////////////////////////////////////////////////////////////////////////
class MessagePeblSlider: UICollectionViewController, UICollectionViewDelegateFlowLayout { 
    
    var indexPathPebls : [IndexPath:MessagePebl]=[:]
    var messagePebls = NSMutableArray()
    var horizontalPadding : CGFloat = 2.0
    /////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(MessagePeblCollectionViewCell.self, forCellWithReuseIdentifier: MessagePeblCollectionViewCell_Identifier)
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
    func addMessagePebl(_ messagePebl:MessagePebl){

        self.collectionView!.performBatchUpdates({
            
            self.messagePebls.add(messagePebl)
            let num_cells = self.messagePebls.count-1
            let index_path = IndexPath(row: num_cells, section: 0)
            
            print("Adding New Message Pebl to Thumbnails for User : \(messagePebl.userID) at Index : \(index_path)")
            print("Current Number of Message Pebls After Addition : \(num_cells)")
            
            self.indexPathPebls[index_path]=messagePebl

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
        return self.messagePebls.count
    }
    ////////////////////////////////////
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        // Create New Thumbnail Cell and Set Up Cell
        let newCell = self.collectionView!.dequeueReusableCell(withReuseIdentifier: MessagePeblCollectionViewCell_Identifier, for: indexPath) as! MessagePeblCollectionViewCell
        newCell.contentView.isUserInteractionEnabled = true
        
        // Find Message Pebl Corresponding to Index Path
        let messagePebl = self.indexPathPebls[indexPath]
        newCell.indexPath = indexPath
        newCell.setup(messagePebl!)
        return newCell

    }
    ////////////////////////////////////
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


