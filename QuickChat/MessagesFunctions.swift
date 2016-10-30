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
    static let instance = MessagesFunctions()
    
    //MARK: Variables
    private var _firebase_messages = FIRDatabase.database().reference().child("Messages")
    var FIREBASE_MESSAGES : FIRDatabaseReference
    {
        return self._firebase_messages
    }
    
    
    
    //Mark: Firebase Functions
    func InsertToFirebase_SendMessage(chatroomID: String, message: Message)
    {
        let messageRef = self._firebase_messages.child(chatroomID).childByAutoId()
        
        message.messageID = messageRef.key
        
        let values : Dictionary<String, AnyObject> = [
            "messageID":message.messageID,
            "messageText":message.messageText,
            "senderID":message.senderID,
            "senderName":message.senderName,
            "messageDate":message.messageDate,
            "messageType":message.messageType,
            "status":message.status,
            ]
        
        messageRef.setValue(values) { (error: NSError?, reference: FIRDatabaseReference) in
            if error != nil
            {
                print ("Something went wrong \(error.debugDescription)")
            }
        }
        
        //Send Push Notification
        
        
        //Update Recents tableView
        RecentsFunctions.instance.UpdateRecents(chatroomID, message: message)
    }
    
}
