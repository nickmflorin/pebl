//
//  ImageExtensions.swift
//  Pebl2
//
//  Created by Nick Florin on 2/8/17.
//  Copyright © 2017 Nick Florin. All rights reserved.
//

import Foundation
import UIKit



////////////////////////////////////////////////////////////
extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x:0, y:0, width:self.size.width, height:self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    // Applies Slight KCI Filter to Image
    func applyKCIFilter(kCIInputLevel:CGFloat)->UIImage{
        
        var outputImage : UIImage?
        
        let cgImage = self.cgImage
        let coreImage = CIImage(cgImage: cgImage!)
        
        // Apply Filter to Image
        let filter = CIFilter(name:"CIExposureAdjust")
        let ciContext = CIContext()
        
        if let unwrwappedFilter : CIFilter = filter  {
            
            unwrwappedFilter.setDefaults()
            unwrwappedFilter.setValue(coreImage, forKey: kCIInputImageKey)
            unwrwappedFilter.setValue(kCIInputLevel,forKey:kCIInputEVKey)
            
            if let outputCIImage : CIImage = unwrwappedFilter.outputImage {
                let createdCGImage = ciContext.createCGImage(outputCIImage,from:outputCIImage.extent)
                outputImage = UIImage(cgImage: createdCGImage!)
            }
        }
        return outputImage!
    }
    // Applies Slight Brightness Filtering to Make Image More Producable for White Text
    func applyBrightnessFilter(brightnessLevel:CGFloat)->UIImage{
        
        var outputImage : UIImage?
        
        let cgImage = self.cgImage
        let coreImage = CIImage(cgImage: cgImage!)
        
        // Apply Filter to Image
        let filter = CIFilter(name: "CIColorControls")
        
        let ciContext = CIContext()
        if let unwrwappedFilter : CIFilter = filter  {
            
            unwrwappedFilter.setDefaults()
            unwrwappedFilter.setValue(coreImage, forKey: kCIInputImageKey)
            unwrwappedFilter.setValue(brightnessLevel,forKey:kCIInputBrightnessKey)
            
            if let outputCIImage : CIImage = unwrwappedFilter.outputImage {
                let createdCGImage = ciContext.createCGImage(outputCIImage,from:outputCIImage.extent)
                outputImage = UIImage(cgImage: createdCGImage!)
            }
        }
        
        return outputImage!
    }
    // Applies Constant Color to Image
    func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0);
        draw(in: rect)
        let context = UIGraphicsGetCurrentContext()
        context!.setBlendMode(.sourceIn)
        context!.setFillColor(color.cgColor)
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}



