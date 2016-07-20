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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.senderId = BackendlessFunctions.instance.CURRENT_USER?.objectId
        self.senderDisplayName = BackendlessFunctions.instance.CURRENT_USER?.name
        
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        self.inputToolbar.contentView.textView.placeHolder = "New Message..."
    }

}
