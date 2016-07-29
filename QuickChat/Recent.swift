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
    private var _recentID : String!
    private var _userID: String!
    private var _withUserID: String!
    private var _withUserUsername: String?
    private var _lastMessage: String?
    private var _counter: Int?
    private var _messageDate: String?
    private var _chatroomID : String!
    private var _members: [String]!
    
    private var _firebaseReference : FIRDatabaseReference!
    
    var recentID: String
        {
        return self._recentID
    }
    var userID: String
    {
        return self._userID
    }
    var withUserID: String
        {
        return self._withUserID
    }
    var withUserUsername: String
    {
        return self._withUserUsername!
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
        self._withUserUsername = values["withUserUsername"] as? String
        self._messageDate = values["messageDate"] as? String
        self._lastMessage = values["lastMessage"] as? String
        self._members = values["members"] as? [String]
        self._userID = values["userID"] as? String
        self._withUserID = values["withUserID"] as? String
        
        
        //We use this as a reference for further functions if we need to perform any action on that branch (childID) of the database
        self._firebaseReference = FirebaseFunctions.instance.FIREBASE_RECENT.child(self._recentID)
        
    }
    
    
}