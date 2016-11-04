//
//  MessagesFunctions
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/19/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import Firebase

class MessagesFunctions
{
    //static let instance = MessagesFunctions()
    
    
    //MARK: Variables
    static private var _firebase_messages = FIRDatabase.database().reference().child("Messages")
    static var FIREBASE_MESSAGES : FIRDatabaseReference
    {
        return self._firebase_messages
    }
    
    
    
    //Mark: Firebase Functions
    class func InsertToFirebase_Message(chatroomID: String, message: Message)
    {
        let messageRef = self._firebase_messages.child(chatroomID).childByAutoId()
        
        
        message.messageID = messageRef.key //create messageID
        
        
        //Create dictionary for adding all fields
        var values : Dictionary<String, AnyObject> = [
            "messageID":message.messageID,
            "messageText":message.messageText,
            "senderID":message.senderID,
            "senderName":message.senderName,
            "messageDate":message.messageDate,
            "messageType":message.messageType,
            "status":message.status,
            ]
        
        
        //Add extra fields for different type of messages
        if message.messageType == MESSAGE_TYPE.Location.rawValue
        {
            values["longtitude"] = message.longtitude
            values["latitude"] = message.latitude
        }
        else if message.messageType == MESSAGE_TYPE.Image.rawValue
        {
            values["imageDataString"] = message.imageDataString
        }
        
        
        
        //Add to firebase
        messageRef.setValue(values) { (error: NSError?, reference: FIRDatabaseReference) in
            if error != nil
            {
                print ("Something went wrong \(error.debugDescription)")
            }
        }
        
        
        //Send Push Notification
        
        
        //Update Recents tableView
        RecentsFunctions.UpdateRecents(chatroomID, message: message)
    }
    
}
