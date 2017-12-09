//
//  MatchEventVC.swift
//  Pebl2
//
//  Created by Nick Florin on 1/7/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import UIKit
import Foundation

class MatchEventVC: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventAddressField: UILabel!
    @IBOutlet weak var eventNameField: UILabel!
    @IBOutlet weak var suggestionPeblButton: UIButton!
    @IBOutlet weak var priceStringField: UILabel!
    @IBOutlet weak var urlField: UILabel!
    
    @IBOutlet weak var matchEventTagView: MatchEventTagView!
    @IBOutlet weak var ratingView: RatingView!
    
    var match : Match!
    var user : User!
    var userVenue : Venue!
    var userStatus : UserStatus!
    var venueImage : UIImage!
    
    ///////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        // Style View Layer/Border
        self.view.clipsToBounds = true
        self.view.layer.borderColor = UIColor.clear.cgColor
        self.view.layer.borderWidth = 1.3
        self.view.layer.cornerRadius = 5.0
        
        self.eventImageView.contentMode = .scaleAspectFill
        self.eventImageView.clipsToBounds = true
        self.setup()
    }
    ///////////////////////////////
    override func viewDidLayoutSubviews() {
        if self.userVenue != nil{
            self.ratingView.applyRating(rating: userVenue.rating)
            
            //self.matchEventTagView.options = self.userVenue.categoryNames
            self.matchEventTagView.generateTags()
        }
    }
    ///////////////////////////////
    // Parses the Data from the Match Object and Populates the VC View with Data
    func setup(){
        
        // Unwrap User, User Info, User Status and Venue
        guard let user = match.user else {
            fatalError("Fatal Error : Match Has no User Object")
        }
        guard let userStatus = user.userStatus else {
            fatalError("Fatal Error : Match User Has no User Status Object")
        }
        guard let userVenue = userStatus.userVenue else {
            fatalError("Fatal Error : Match User Has no User Venue Object")
        }
        
        self.user = user
        self.userStatus = userStatus
        self.userVenue = userVenue
        
        eventNameField.text = userVenue.name
        eventAddressField.text = self.userVenue.location.address
        urlField.text = userVenue.url
//        priceStringField.text = userVenue.parsePriceTier()
//        
//        guard let imageURL = userVenue.bestPhotoUrl else{
//            print("Venue Does Not Have Image URL")
//            return
//        }
        //self.viewDidLayoutSubviews()
        
        //Asynchronously Load Image from URL
        DispatchQueue.main.async {
            
//            let myUrl = URL(string: imageURL)
//            let request = NSMutableURLRequest(url:myUrl!);
//            request.httpMethod = "GET"
//            let task = URLSession.shared.dataTask(with: request as URLRequest) {
//                data, response, error in
//                
//                if error != nil {
//                    print("Error Downloading Image from URL")
//                    print(error!.localizedDescription)
//                }
//                else{
//                    let httpURLResponse = response as? HTTPURLResponse
//                    print("Response : \(httpURLResponse)")
//
//                    if httpURLResponse?.statusCode == 200{
//                        if let mimeType = response?.mimeType {
//                            if mimeType.hasPrefix("image") {
//                                self.venueImage = UIImage(data: data!)
//                                DispatchQueue.main.async {
//                                    self.eventImageView.image = self.venueImage
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            task.resume()
     
        }
    }
}
