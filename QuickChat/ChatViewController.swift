//
//  ChatViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/19/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit
import JSQMessagesViewController


class ChatViewController: JSQMessagesViewController {

    var messages = [JSQMessage]()
    var objects = [Recent]()
    var loaded = [Recent]()
    
    var withUser : BackendlessUser? //For new Chat
    var recent : Recent? //for already exist chat
    var chatroomID : String! //Mandatory field for both new/existing chats
    
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
    }

    
    
    //MARK: JSQMessages/CollectionView Delegate Functions
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.messages.count
    }
    //for cell color
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = self.messages[indexPath.row]
        
        if message.senderId == BackendlessFunctions.instance.CURRENT_USER?.objectId
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
        let message = self.messages[indexPath.row]
        
        return message
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        
        let message = self.messages[indexPath.row]
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
        }
    }
    override func didPressAccessoryButton(sender: UIButton!)
    {
        
    }
    func SendMessage(date:NSDate, textMessage: String?, pictureMessage: UIImage?, locationMessage: String?)
    {
        if let text = textMessage //Send text message
        {
            
        }
        if let picture = pictureMessage //Send picture message
        {
            
        }
        if let location = locationMessage //Send location message
        {
            
        }
    
    }
}
