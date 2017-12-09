//
//  Utilities.swift
//  Pebl
//
//  Created by Nick Florin on 8/6/16.
//  Copyright © 2016 Nick Florin. All rights reserved.
//

import Foundation
import UIKit

// Converts Meters to Miles Rounded to Nearest Tenth
func convertMetersToMiles(meters:CGFloat)->CGFloat{
    let numMetersInMile : CGFloat = 1609.0
    var miles : CGFloat = meters/numMetersInMile

    // Round Miles to Nearest Tenth
    miles = round(10.0*miles)/10.0
    miles = CGFloat(miles)
    
    return miles
}


//////////////////////////////////////////////////////////////
func createDate(dateString:String) -> NSDate {
    let dateStringFormatter = DateFormatter()
    dateStringFormatter.dateFormat = "yyyy-MM-dd"
    dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
    let d = dateStringFormatter.date(from: dateString)!
    
    return NSDate(timeInterval: 0, since: d)
}

//////////////////////////////////////////////////////////////
func generateRandomDate()->String {
    
    let monthChoices = ["01","02","03"]
    var dayChoices : [String] = []
    for i in 1...28 {
        dayChoices.append(String(describing:i))
    }
    
    let randomIndex = Int(arc4random_uniform(UInt32(monthChoices.count)))
    let randomIndex2 = Int(arc4random_uniform(UInt32(dayChoices.count)))
    
    let chosenMonth = monthChoices[randomIndex]
    let chosenDay = dayChoices[randomIndex2]
    
    let randomDateString = "2017-"+chosenMonth+"-"+chosenDay
    //let newDate = createDate(dateString: randomDateString)
    
    return randomDateString
}


// Converts String to Float
func makeFloat(string:String)->CGFloat{
    
    // Format String Rating to FLoat
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.minimumFractionDigits = 2
    
    var float = numberFormatter.number(from: string)
    float = CGFloat(float!) as NSNumber?
    
    return float as! CGFloat
}

//////////////////////////////////////////////////////////////
//// Scales image down to new width keeping aspect ratio the same.
func scaleImageToWidthCG(image:UIImage,newWidth:CGFloat)->UIImage{

    let imageScale : CGFloat = newWidth / image.size.width
    
    let cgImage = image.cgImage
    
    let width = imageScale*CGFloat(cgImage!.width)
    let height = imageScale*CGFloat(cgImage!.height)
    
    let bitsPerComponent = cgImage!.bitsPerComponent
    let bytesPerRow = cgImage!.bytesPerRow
    let colorSpace = cgImage!.colorSpace
    let bitmapInfo = cgImage!.bitmapInfo
    
    let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)
    
    context?.interpolationQuality = .high
    context?.draw(cgImage!, in: CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(width), height: CGFloat(height))))
    
    let scaledImage = context!.makeImage().flatMap { UIImage(cgImage: $0) }
    return scaledImage!
}

////////////////////////////////////////////////////////////
func resize_image_to_size(_ uiimage:UIImage,newHeight:CGFloat) -> UIImage{
    
    let scale = newHeight / uiimage.size.height
    let newWidth = uiimage.size.width * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    uiimage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    newImage?.withRenderingMode(.alwaysOriginal)
    UIGraphicsEndImageContext()
    
    return newImage!
}
////////////////////////////////////////////////////////////
func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


////////////////////////////////////////
// Calculates Overlapping Area of Two Rectangles
func overlapArea(rect1:CGRect,rect2:CGRect)->CGFloat{
    
    let leftRect : CGRect!
    let rightRect : CGRect!
    let topRect : CGRect!
    let bottomRect : CGRect!
    
    if rect1.minX <= rect2.minX{
        leftRect = rect1
        rightRect = rect2
    }
    else{
        leftRect = rect2
        rightRect = rect1
    }
    // Horizontal Overlap
    let horOverlap = leftRect.maxX - rightRect.minX
    
    if rect1.minY >= rect2.minY{
        topRect = rect1
        bottomRect = rect2
    }
    else{
        topRect = rect2
        bottomRect = rect1
    }
    // Vertical Overlap
    let verOverlap = bottomRect.maxY - topRect.minY
    let overlapArea = verOverlap*horOverlap
    return overlapArea
}
////////////////////////////////////////
func convert_string_to_nsdate(_ ns_date_string:String)->Date{

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let dateFromString = dateFormatter.date(from: ns_date_string)
    return dateFromString!
}
////////////////////////////////////////
func convert_nsdate_to_string(_ ns_date:Date)-> String{
    // Convert Match Date to String Format
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    let stringDate: String = formatter.string(from: ns_date)
    return stringDate
}
////////////////////////////////////////
func convert_dic_to_json(_ matches_dict:[String:AnyObject])->String{
    // Convert Dictionary to JSON
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: matches_dict, options: .prettyPrinted)
        //let matches_json = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        let matches_json = "Test"
        return matches_json 

    } catch let error as NSError {
        print(error)
    }
    return ""
}
////////////////////////////////////////
func convert_json_to_dic(_ matches_json:String)->[String:AnyObject]{

    let matches_dict : [String:AnyObject] = [:]
    return matches_dict
    // Decode Photo ID Json
//    do {
//        let json_data = matches_json.data(using: String.Encoding.utf8)
//        matches_dict = try JSONSerialization.jsonObject(with: json_data!, options: .mutableLeaves) as! [String : AnyObject]
//        return matches_dict
//    } catch let error as NSError {
//        print(error)
//        matches_dict = [:]
//        return matches_dict
//
//    }
}
