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
    private var _longtitude: NSNumber?
    private var _latitude: NSNumber?
    private var _imageDataString: String?
    
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
    
    var longtitude: NSNumber
    {
        return self._longtitude!
    }
    
    var latitude: NSNumber
    {
        return self._latitude!
    }
    
    var imageDataString: String
    {
        return self._imageDataString!
    }
    
    //MARK: init funcations
    init()
    {
        
    }
    
    init(values: NSDictionary) //From Firebase
    {
        self._messageID = values["messageID"] as! String
        self._messageText = values["messageText"] as! String
        self._senderID = values["senderID"] as! String
        self._senderName = values["senderName"] as! String
        self._messageDate = values["messageDate"] as! String
        self._messageType = values["messageType"] as! String
        self._status = values["status"] as! String
        
        //Optional
        if self._messageType == MESSAGE_TYPE.Image.rawValue
        {
            self._imageDataString = values["imageDataString"] as? String
        }
        if self._messageType == MESSAGE_TYPE.Location.rawValue
        {
            self._longtitude = values["longtitude"] as? NSNumber
            self._latitude = values["latitude"] as? NSNumber
        }
        
    }
    
    
    init(messageText: String, senderID: String, senderName: String, messageDate: NSDate, messageType: String, status: String)
    {
        self.initializeProperties(messageText, senderID: senderID, senderName: senderName, messageDate: messageDate, messageType: messageType, status: status)
        
        self._messageText = messageText
    }
    
    init(messageText: String, imageDataString: String, senderID: String, senderName: String, messageDate: NSDate, messageType: String, status: String)
    {
        self.initializeProperties(messageText, senderID: senderID, senderName: senderName, messageDate: messageDate, messageType: messageType, status: status)
        
        self._imageDataString = imageDataString
    }
    
    init(messageText: String, longtitude: NSNumber, latitude: NSNumber,  senderID: String, senderName: String, messageDate: NSDate, messageType: String, status: String)
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
        self._messageDate = HelperFunctions.DateFormatter().stringFromDate(messageDate)
        self._messageType = messageType
        self._status = status

    }
    
}
