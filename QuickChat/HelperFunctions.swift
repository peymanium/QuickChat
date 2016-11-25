//
//  HelperFunctions.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 10/24/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation





class HelperFunctions
{
    //static let instance = HelperFunctions()
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    static private let dateFormat = "yyyyMMddHHmmss"
    class func DateFormatter() -> NSDateFormatter
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter
    }
    
    
    class func IsUserHaveAccessToLocation() -> Bool
    {
        if self.appDelegate.coordinate != nil
        {
            return true
        }
        
        return false
    }
    
    
    //MARK: Image functions
    class func ConvertImageDataToString()
    {
        
    }
    class func ConvertStringToImage(imageDataString: String?, completion: (image: UIImage?) -> Void)
    {
        var image: UIImage?
        
        let decodedData = NSData(base64EncodedString: imageDataString!, options: NSDataBase64DecodingOptions(rawValue: 0))
        image = UIImage(data: decodedData!)
        
        completion(image: image)
    }
    class func ConvertImageDataToString(imageData: NSData) -> String
    {
        let imageDataString = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        return imageDataString
    }
    
    
}
