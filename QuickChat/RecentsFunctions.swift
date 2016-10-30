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
    static let instance = RecentsFunctions()
    
    private var _firebase_recent = FIRDatabase.database().reference().child("Recents")
    var FIREBASE_RECENT : FIRDatabaseReference
    {
        return self._firebase_recent
    }
    

    //MARK: Firebase Function
    func InsertToFirebase_Recent(userID: String, userReceiverID: String, chatroomID: String, members: [String], userReceiverUsername: String)
    {
        //Check if chatroomID already exists or not
        self._firebase_recent.queryOrderedByChild("chatroomID").queryEqualToValue(chatroomID).observeSingleEventOfType(.Value) { (snapshotData: FIRDataSnapshot!) in
            
            var createNewChat = true
            
            //if let values = snapshot.value?.allValues
            if let snapshots = snapshotData.children.allObjects as? [FIRDataSnapshot]
            {
                for snapshot in snapshots
                {
                    let recent = Recent(values: snapshot.value as! Dictionary<String, AnyObject>)
                    
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
                let messageDate = HelperFunctions.instance.DateFormatter().stringFromDate(NSDate())
                
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
    func DeleteFromFirebase_Recent(recent: Recent)
    {
        FIREBASE_RECENT.child(recent.recentID).removeValueWithCompletionBlock { (error: NSError?, reference: FIRDatabaseReference) in
            
            if error != nil
            {
                print ("error in deleting \(recent.recentID)")
            }
            
        }
    }
    func UpdateRecents(chatroomID: String, message: Message)
    {
        self._firebase_recent.queryOrderedByChild("chatroomID").queryEqualToValue(chatroomID).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            
            if snapshot.exists()
            {
                if let values = snapshot.value?.allValues
                {
                    for value in values
                    {
                        let recent = Recent(values: value as! Dictionary<String, AnyObject>)
                        
                        let messageDate = message.messageDate
                        let lastMessage = message.messageText
                        var counter = recent.counter
                        //User should not be Curent User in order to see counter=1 for new message
                        if recent.userID != BackendlessFunctions.instance.CURRENT_USER?.objectId
                        {
                            counter = counter + 1
                        }
                        
                        //Create Dictionary for updated values
                        let values = ["lastMessage": lastMessage, "messageDate": messageDate, "counter": counter]
                        
                        //Update Firebase for that RecentID
                        self._firebase_recent.child(recent.recentID).updateChildValues(values as [NSObject : AnyObject], withCompletionBlock: { (error: NSError?, reference: FIRDatabaseReference) in
                            
                            if error != nil
                            {
                                print ("error in updating \(recent.recentID)")
                            }
                            
                        })
                    }
                }
            }
            
        }
    }
    
    
    //MARK: Create Chatroom
    func CreateRecentAndGenerateChatroomID(userSender: BackendlessUser, userReceiver:BackendlessUser) -> String
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
    func RestartRecentChat(recent: Recent)
    {
        for userID in recent.members
        {
            let currentUser = BackendlessFunctions.instance.CURRENT_USER!
            
            //if userID != currentUser.objectId
            //{
                self.InsertToFirebase_Recent(userID, userReceiverID: currentUser.objectId, chatroomID: recent.chatroomID, members: recent.members, userReceiverUsername: currentUser.name)
            //}
        }
        
        
    }
    
}
