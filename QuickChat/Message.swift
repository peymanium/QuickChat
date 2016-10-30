//
//  Message.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 10/22/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import Firebase

class Message
{
    private var _messageID: String!
    private var _messageText: String!
    private var _senderID: String!
    private var _senderName: String!
    private var _messageDate: String!
    private var _status: String!
    private var _messageType: String!
    private var _longtitude: String?
    private var _latitude: String?
    private var _imageData: String?
    
    var messageID: String
    {
        get{
            return self._messageID
        }
        set{
            self._messageID = newValue
        }
        
    }
    
    var messageText: String
    {
        return self._messageText
    }
    
    var senderID: String
    {
        return self._senderID
    }
    
    var senderName: String
    {
        return self._senderName
    }
    
    var messageDate: String
    {
        return self._messageDate
    }
    
    var status: String
    {
        return self._status
    }
    
    var messageType: String
    {
        return self._messageType
    }
    
    var longtitude: String
    {
        return self._longtitude!
    }
    
    var latitude: String
    {
        return self._latitude!
    }
    
    var imageData: String
    {
        return self._imageData!
    }
    
    //MARK: init funcation
    init(values: NSDictionary)
    {
        self._messageID = ""
        self._messageText = values["messageText"] as! String
        self._senderID = values["senderID"] as! String
        self._senderName = values["senderName"] as! String
        self._messageDate = values["messageDate"] as! String
        self._messageType = values["messageType"] as! String
        self._status = values["status"] as! String
        
        //Optional
        if (values["imageData"] as? NSData) != nil
        {
            let imageData = values["imageData"] as? NSData
            
            self._imageData = imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        }
        if values["longtitude"] !=  nil && values["latitue"] != nil
        {
            self._longtitude = values["longtitude"] as? String
            self._latitude = values["latitude"] as? String
        }
        
    }
    
    
    init()
    {
        
    }
    init(messageText: String, senderID: String, senderName: String, messageDate: NSDate, messageType: String, status: String)
    {
        self.initializeProperties(messageText, senderID: senderID, senderName: senderName, messageDate: messageDate, messageType: messageType, status: status)
    }
    
    init(messageText: String, senderID: String, senderName: String, messageDate: NSDate, messageType: String, status: String, imageData: NSData)
    {
        self.initializeProperties(messageText, senderID: senderID, senderName: senderName, messageDate: messageDate, messageType: messageType, status: status)
        
        self._imageData = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    
    init(messageText: String, senderID: String, senderName: String, messageDate: NSDate, messageType: String, status: String, longtitude: String, latitude: String)
    {        
        self.initializeProperties(messageText, senderID: senderID, senderName: senderName, messageDate: messageDate, messageType: messageType, status: status)
        
        self._longtitude = longtitude
        self._latitude = latitude
    }
    
    //MARK: method for initializing all properties
    private func initializeProperties(messageText: String, senderID: String, senderName: String, messageDate: NSDate, messageType: String, status: String)
    {
        self._messageText = messageText
        self._senderID = senderID
        self._senderName = senderName
        self._messageDate = HelperFunctions.instance.DateFormatter().stringFromDate(messageDate)
        self._messageType = messageType
        self._status = status

    }
    
}
