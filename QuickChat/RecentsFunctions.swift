//
//  RecentsFunctions.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/16/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import Firebase

class RecentsFunctions
{
    //static let instance = RecentsFunctions()
    
    static private var _firebase_recent = FIRDatabase.database().reference().child("Recents")
    static var FIREBASE_RECENT : FIRDatabaseReference
    {
        return self._firebase_recent
    }
    

    //MARK: Firebase Function
    class func InsertToFirebase_Recent(userID: String, userReceiverID: String, chatroomID: String, members: [String], userReceiverUsername: String)
    {
        //Check if chatroomID already exists or not
        self._firebase_recent.queryOrderedByChild("chatroomID").queryEqualToValue(chatroomID).observeSingleEventOfType(.Value) { (snapshotData: FIRDataSnapshot!) in
            
            var createNewChat = true
            
            //if let values = snapshot.value?.allValues
            if let snapshots = snapshotData.value?.allValues
            {
                for snapshot in snapshots
                {
                    let recent = Recent(values: snapshot as! Dictionary<String, AnyObject>)
                    
                    if (recent.userID == userID) //There is no recent created for userID
                    {
                        createNewChat = false //dont create any new chat of the chatroom already created for userID
                    }
                }
            }
            
            
            if createNewChat
            {
                //Create a reference for a new child branch in firebase for the new data branch
                let recentReference = self._firebase_recent.childByAutoId()
                
                let recentID = recentReference.key
                let messageDate = HelperFunctions.DateFormatter().stringFromDate(NSDate())
                
                let values : Dictionary<String,AnyObject> =
                    ["recentID": recentID ,
                     "chatroomID": chatroomID ,
                     "userID": userID,
                     "userReceiverID": userReceiverID,
                     "userReceiverUsername": userReceiverUsername,
                     "members": members,
                     "counter": 0,
                     "lastMessage": "",
                     "messageDate" : messageDate,
                     "order" : -1 * NSDate.timeIntervalSinceReferenceDate()
                ]
                
                //Add to Firebase
                recentReference.setValue(values, withCompletionBlock: { (error: NSError?, firebaseReference: FIRDatabaseReference) in
                    
                    if error != nil
                    {
                        print ("Something went wrong \(error.debugDescription)")
                    }
                    
                })
            }
            
        }
        
    }
    class func UpdateRecents(chatroomID: String, message: Message)
    {
        let messageDate = message.messageDate
        let lastMessage = message.messageText
        
        self._firebase_recent.queryOrderedByChild("chatroomID").queryEqualToValue(chatroomID).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            
            if snapshot.exists()
            {
                if let values = snapshot.value?.allValues
                {
                    for value in values
                    {
                        let recent = Recent(values: value as! Dictionary<String, AnyObject>)
                        recent.UpdateRecent(lastMessage, messageDate: messageDate)
                    }
                }
            }
            
        }
    }
    
    
    //MARK: Create Chatroom
    class func CreateRecentChat(userSender: BackendlessUser!, userReceiver:BackendlessUser!) -> String
    {
        var chatroomID = ""
        
        let userID: String = userSender.objectId
        let userReceiverID: String = userReceiver.objectId
        
        //We use Compare function in order to get the same ChartroomID even if the users switch in the function call parameters
        let value = userID.compare(userReceiverID).rawValue
        if value < 0
        {
            chatroomID = userID.stringByAppendingString(userReceiverID)
        }
        else
        {
            chatroomID = userReceiverID.stringByAppendingString(userID)
        }
        
        
        
        let members = [userID, userReceiverID]
        
        
        
        //Create 2 chatrooms for 2 users
        self.InsertToFirebase_Recent(userID, userReceiverID: userReceiverID, chatroomID: chatroomID, members: members, userReceiverUsername: userReceiver.name)
        
        self.InsertToFirebase_Recent(userReceiverID, userReceiverID: userID, chatroomID: chatroomID, members: members, userReceiverUsername: userSender.name)
        
        
        return chatroomID
    }
    
    
    //MARK: Restart Recent Chat
    //This function is being used when one user deletes a chat but the other user want to send him a message, so a new Recent data should be added in Firebase, as it should always have 2 recent records in firebase between CurrentUser ane userReceiver.
    class func RestartRecentChat(recent: Recent)
    {
        for userID in recent.members
        {
            let currentUser = BackendlessFunctions.CURRENT_USER
            
            if userID != currentUser.objectId
            {
                self.InsertToFirebase_Recent(userID, userReceiverID: currentUser.objectId, chatroomID: recent.chatroomID, members: recent.members, userReceiverUsername: currentUser.name)
            }
        }
        
        
    }
    
}
