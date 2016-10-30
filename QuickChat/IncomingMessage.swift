//
//  IncomingMessage.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 10/29/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class IncomingMessage
{
    var _collectionView: JSQMessagesCollectionView
    
    init(collectionView: JSQMessagesCollectionView)
    {
        self._collectionView = collectionView
    }
    
    func CreateJSQMessage(message: Message) -> JSQMessage?
    {
        var jsqMessage: JSQMessage?
        
        let messageType = message.messageType
        let senderName = message.senderName
        let senderID = message.senderID
        let messageText = message.messageText
        let messageDate = HelperFunctions.instance.DateFormatter().dateFromString(message.messageDate)
        
        if messageType == "Text"
        {
            jsqMessage = JSQMessage(senderId: senderID, senderDisplayName: senderName, date: messageDate, text: messageText)
        }
        else if messageType == "Location"
        {
            
        }
        else if messageType == "Picture"
        {
            
        }
        
        if let msg = jsqMessage
        {
            return msg
        }
        
        return nil
    }

}
