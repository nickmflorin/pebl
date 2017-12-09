//
//  EventDetailView.swift
//  Pebl2
//
//  Created by Nick Florin on 2/20/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit
import MapKit


//////////////////////////////////////////////////////////////
class VenueDetailViewController: UIViewController, MKMapViewDelegate{
    
    // MARK: Properties
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var urlField: UILabel!
    
    @IBOutlet weak var matchesInterestedField: UILabel!
    @IBOutlet weak var categoryField: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    //@IBOutlet weak var venueCategoryView: VenueCategoryView!
    @IBOutlet weak var ratingView: RatingView!
    
    @IBOutlet weak var mapView: MKMapView!
    var span = MKCoordinateSpanMake(0.005, 0.005) // Map View Span
    var region : MKCoordinateRegion!
    
    var venueLocation : CLLocationCoordinate2D!
    var venue : Venue!
    
    class func instantiateFromStoryboard() -> VenueDetailViewController {
        let storyboard = UIStoryboard(name: "Base", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! VenueDetailViewController
    }
    
    ///////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.venueImageView.contentMode = .scaleAspectFill
        self.venueImageView.clipsToBounds = true
        
        // Change Button Color
        let image = self.favoriteButton.imageView?.image
        let coloredImage = image?.imageWithColor(color: default_blue)
        self.favoriteButton.setImage(coloredImage, for: .normal)
        
        // Map Config
        self.mapView.showsUserLocation = true
        self.mapView.mapType = .standard
    }
    ///////////////////////////////
    override func viewDidLayoutSubviews() {
        if self.venue != nil{
            
            var categories : [String] = []
            if self.venue.categories != nil {
                for category in self.venue.categories{
                    categories.append(category.shortName)
                }
            }
            // To Do: Handle Situations When Venue Rating Missing
            if let rating = self.venue.rating {
                self.ratingView.applyRating(rating: self.venue.rating)
            }
            // Not using the category tags for now
            self.categoryField.text = "Bar, Happy Hour, Restaurant"
            
            //self.venueCategoryView.options = categories
            //self.venueCategoryView.generateTags()
            
            self.venueImageView.contentMode = .scaleAspectFill
            self.venueImageView.clipsToBounds = true
            self.venueImageView.image = self.venue.image
            
        }
    }
    ///////////////////////////////
    // Parses the Data from the Match Object and Populates the VC View with Data
    func setup(venue:Venue){
        
        self.venue = venue
        // This should never be nil or empty, need to handle error here.
        guard self.venue.name != "" else {
            return
        }
        self.nameField.text = self.venue.name
        
        if self.venue.url != nil{
            self.urlField.text = self.venue.url
        }
        
        // Matches Data
        self.matchesInterestedField.text = "3 matches interested"
        
        // Location Data
        // To Do: Better handling of missing information
        if self.venue.location != nil && self.venue.location.address != "" {

            // Venue Location
            // To Do: Handle situations when lattitude and longitude are missing
            if let lat = self.venue.location.lattitude {
                if let lng = self.venue.location.longitude {
                    venueLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat),longitude: CLLocationDegrees(lng))
                    region = MKCoordinateRegion(center: venueLocation, span: span)
                    
                    self.mapView.setRegion(region, animated: true)
                    
                    // Create Annotation for Venue
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = venueLocation
                    annotation.title = self.venue.name
                    annotation.subtitle = self.venue.location.address
                    self.mapView.addAnnotation(annotation)
                    
                    // Select Annoation - this will need to be changed if we have additional annotations
                    let yourAnnotationAtIndex = 0
                    self.mapView.selectAnnotation(mapView.annotations[yourAnnotationAtIndex], animated: true)
                }
            }
            
            
        }
        
    }
}
