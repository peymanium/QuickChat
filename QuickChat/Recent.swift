//
//  Recent.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/16/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation

class Recent
{
    private var _withUserObjectID: String!
    private var _withUserUsername: String?
    private var _lastMessage: String?
    private var _counter: Int?
    private var _messageDate: String?
    private var _chatroomId : String!
    
    var withUserObjectID: String
        {
        return self._withUserObjectID
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
    var ChatroomID : String
    {
        return self._chatroomId
    }
    
    
    init(withUserObjectID: String!, withUserUsername: String?, lastMessage: String?, counter: Int?, messageDate: String?)
    {
        self._withUserObjectID = withUserObjectID
        self._withUserUsername = withUserUsername
        self._lastMessage = lastMessage
        self._counter = counter
        self._messageDate = messageDate
    }
    
    
}