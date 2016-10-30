//
//  ChatViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/19/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController
{
    var jsqMessages = [JSQMessage]()
    var messageObjects = [Message]()
    var loadedMessages = [Message]()
    
    var userReceiver : BackendlessUser? //For new Chat
    var recent : Recent? //for already exist chat
    var chatroomID : String! //Mandatory field for both new/existing chats
    
    var initialLoadCompleted: Bool = false
    
    //Bubbles
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.senderId = BackendlessFunctions.instance.CURRENT_USER?.objectId
        self.senderDisplayName = BackendlessFunctions.instance.CURRENT_USER?.name
        
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        self.inputToolbar.contentView.textView.placeHolder = "New Message..."
        
        self.LoadMessages()
    }

    
    
    //MARK: JSQMessages/CollectionView Delegate Functions
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.jsqMessages.count
    }
    //for cell color
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = self.jsqMessages[indexPath.row]
        
        if message.senderId == BackendlessFunctions.instance.CURRENT_USER?.objectId //message is for current user
        {
            cell.textView.textColor = UIColor.whiteColor()
        }
        else
        {
            cell.textView.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData!
    {
        let message = self.jsqMessages[indexPath.row]
        
        return message
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        
        let message = self.jsqMessages[indexPath.row]
        if message.senderId == BackendlessFunctions.instance.CURRENT_USER?.objectId
        {
            return outgoingBubble
        }
        else
        {
            return incomingBubble
        }
        
    }
    
    
    
    //MARK: JSQMessage Delegate functions
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
    {
        if text != ""
        {
            //Send message
            self.SendMessage(date, textMessage: text, pictureMessage: nil, locationMessage: nil)
        }
    }
    override func didPressAccessoryButton(sender: UIButton!)
    {
        
    }
    
    
    
    //MARK: Send Message
    func SendMessage(date:NSDate, textMessage: String?, pictureMessage: UIImage?, locationMessage: String?)
    {
        var outgoingMessage: Message = Message()
        
        if let text = textMessage //Send text message
        {
            outgoingMessage = Message(messageText: text, senderID: BackendlessFunctions.instance.CURRENT_USER!.objectId , senderName: BackendlessFunctions.instance.CURRENT_USER!.name , messageDate: date, messageType: "Text", status: "Delivered")
        }
        if let picture = pictureMessage //Send picture message
        {
            
        }
        if let location = locationMessage //Send location message
        {
            
        }
    
        //Play message sent sound
        JSQSystemSoundPlayer.jsq_playMessageSentAlert()
        self.finishSendingMessage()
        
        MessagesFunctions.instance.InsertToFirebase_SendMessage(self.chatroomID, message: outgoingMessage)
    }
    
    
    //MARK: Load messages
    func LoadMessages()
    {
        MessagesFunctions.instance.FIREBASE_MESSAGES.child(self.chatroomID).observeSingleEventOfType(.Value) { (snapshotData: FIRDataSnapshot) in
            
            self.InsertMessage()
            self.finishReceivingMessageAnimated(true)
            self.initialLoadCompleted = true
        }
        
        MessagesFunctions.instance.FIREBASE_MESSAGES.child(self.chatroomID).observeEventType(.ChildAdded) { (snapshotData: FIRDataSnapshot) in
            
            if let value = snapshotData.value as? NSDictionary
            {
                let message = Message(values: value)
                if self.initialLoadCompleted
                {
                    self.InsertMessage(message)
                    let isIncoming = self.IsIncoming(message)
                    if isIncoming
                    {
                        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                    }
                    self.finishReceivingMessageAnimated(true)
                }
                else
                {
                    self.loadedMessages.append(message)
                }
            }

        }
        
        MessagesFunctions.instance.FIREBASE_MESSAGES.child(self.chatroomID).observeEventType(.ChildRemoved) { (snapshotData: FIRDataSnapshot) in
            
            
        }
        
        MessagesFunctions.instance.FIREBASE_MESSAGES.child(self.chatroomID).observeEventType(.ChildChanged) { (snapshotData: FIRDataSnapshot) in
            
            
        }
    }
    
    
    //MARK: Helper functions
    func InsertMessage()
    {
        for loadedMessage in self.loadedMessages
        {
            self.InsertMessage(loadedMessage)
        }
    }
    func InsertMessage(message: Message)
    {
        let incomeMessage = IncomingMessage(collectionView: self.collectionView)
        let jsqMessage = incomeMessage.CreateJSQMessage(message)
        
        self.messageObjects.append(message)
        self.jsqMessages.append(jsqMessage!)
    }
    func IsIncoming(item: Message) -> Bool
    {
        if self.senderId == item.senderID
        {
            return false
        }
        else
        {
            return true
        }
    }

}
