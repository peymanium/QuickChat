//
//  Recent.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/16/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import Firebase

class Recent
{
    private var _firebaseRef : FIRDatabaseReference!
    
    private var _recentID : String!
    private var _userID: String!
    private var _userReceiverID: String!
    private var _userReceiverUsername: String?
    private var _lastMessage: String?
    private var _counter: Int?
    private var _messageDate: String?
    private var _chatroomID : String!
    private var _members: [String]!
    
    var recentID: String
        {
        return self._recentID
    }
    var userID: String
    {
        return self._userID
    }
    var userReceiverID: String
        {
        return self._userReceiverID
    }
    var userReceiverUsername: String
    {
        return self._userReceiverUsername!
    }
    var lastMessage: String
        {
        return self._lastMessage!
    }
    var counter: Int
        {
        return self._counter!
    }
    var messageDate: String
        {
        return self._messageDate!
    }
    var chatroomID : String
    {
        return self._chatroomID
    }
    var members: [String]
    {
        return self._members
    }
    
    
    init(values: Dictionary<String,AnyObject>!)
    {
        self._recentID = values["recentID"] as! String
        self._counter = values["counter"] as? Int
        self._chatroomID = values["chatroomID"] as! String
        self._userReceiverUsername = values["userReceiverUsername"] as? String
        self._messageDate = values["messageDate"] as? String
        self._lastMessage = values["lastMessage"] as? String
        self._members = values["members"] as? [String]
        self._userID = values["userID"] as? String
        self._userReceiverID = values["userReceiverID"] as? String
        

        //We use this as a reference for further functions if we need to perform any action on that branch (childID) of the database (Delete Recent, Update Recent)
        self._firebaseRef = RecentsFunctions.FIREBASE_RECENT.child(self._recentID)
        
    }
    
    func DeleteRecentChat()
    {
        self._firebaseRef.removeValueWithCompletionBlock { (error: NSError?, reference: FIRDatabaseReference) in
            
            if error != nil
            {
                print ("error in deleting \(self._recentID)")
            }
            
        }
    }
    func UpdateRecent(lastMessageText: String, messageDate: String)
    {
        var counter = self._counter!
        
        //User should not be Curent User in order to see counter=1 for new message
        if self._userID != BackendlessFunctions.CURRENT_USER.objectId
        {
            counter = counter + 1
        }
        
        
        //Create Dictionary for updated values
        let values: Dictionary<String, AnyObject> = ["lastMessage": lastMessageText, "messageDate": messageDate, "counter": counter]
        
        
        //Update Firebase for that RecentID
        self._firebaseRef.updateChildValues(values as [NSObject : AnyObject], withCompletionBlock: { (error: NSError?, reference: FIRDatabaseReference) in
            
            if error != nil
            {
                print ("error in updating \(self._recentID)")
            }
            
        })
    }
    
}
