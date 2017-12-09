//
//  FavoriteEventView.swift
//  Pebl2
//
//  Created by Nick Florin on 1/25/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit

//////////////////////////////////////////////////////////////////////////
class FavoriteEventView: UIView {

    var sliderLayout : UICollectionViewFlowLayout!
    var favoriteEventSlider : FavoriteEventSlider!
    var favoriteEventSliderFrame : CGRect!
    
    // Favorite Event Item Content Can Be Outside of Containing View
    var horizontalMargin : CGFloat = 15.0
    var verticalMargin : CGFloat = 5.0
    
    /////////////////////////////////////
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
    }
    /////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.setup(rect:frame)
    }
    //////////////////////////////
    // Init for Drawing Underlying
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.setup(rect:rect)
    }
    //////////////////////////////
    // Sets Up Collection View
    func setup(rect:CGRect){
        
        let itemHeight = rect.size.height - 2.0 * verticalMargin
        let itemWidth = 0.3*(rect.size.width - 2.0*horizontalMargin)
        
        // Create Thumbnail Slider at Top for New Message Pebls
        sliderLayout = UICollectionViewFlowLayout()
        sliderLayout.sectionInset = UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin)
        sliderLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        sliderLayout.scrollDirection = .horizontal
        
        sliderLayout.minimumLineSpacing = 8.0 /// Makes Single Row
        sliderLayout.minimumInteritemSpacing = 8.0
        
        // Add Event Slider as Subview
        favoriteEventSlider = FavoriteEventSlider(collectionViewLayout: sliderLayout)
        
        favoriteEventSlider.collectionView?.showsHorizontalScrollIndicator = true
        favoriteEventSlider.collectionView?.backgroundColor = UIColor.clear
        //favoriteEventSlider.collectionView?.clipsToBounds = false
        
        guard let collectionV = favoriteEventSlider.collectionView else{
            fatalError("Error Initializing Collection View")
        }
        collectionV.frame = rect
        self.addSubview(collectionV)
    }
}
