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
import IDMPhotoBrowser

class ChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
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
        
        self.senderId = BackendlessFunctions.CURRENT_USER.objectId
        self.senderDisplayName = BackendlessFunctions.CURRENT_USER.name
        
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
        if message.senderId == BackendlessFunctions.CURRENT_USER.objectId //message is for current user
        {
            cell.textView?.textColor = UIColor.whiteColor()
        }
        else
        {
            cell.textView?.textColor = UIColor.blackColor()
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
        if message.senderId == BackendlessFunctions.CURRENT_USER.objectId
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
        let camera = Camera(delegate: self)
        
        var messageType = ""
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let actionTakePhoto = UIAlertAction(title: "Take Photo", style: .Default) { (alertAction: UIAlertAction) in
            
            camera.PresentCamera(self, canEdit: true)
            
        }
        let actionSharePhoto = UIAlertAction(title: "Photo From Library", style: .Default) { (alertAction: UIAlertAction) in
            
            camera.PresentPhotoLibrary(self, canEdit: true)
            
        }
        let actionShareLocation = UIAlertAction(title: "Share Location", style: .Default) { (alertAction: UIAlertAction) in
            
            if HelperFunctions.IsUserHaveAccessToLocation()
            {
                messageType = MESSAGE_TYPE.Location.rawValue
                self.SendMessage(NSDate(), textMessage: nil, pictureMessage: nil, locationMessage: messageType)
            }
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction: UIAlertAction) in
            print ("Cancel")
        }
        
        alertController.addAction(actionTakePhoto)
        alertController.addAction(actionSharePhoto)
        alertController.addAction(actionShareLocation)
        alertController.addAction(actionCancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK: JSQMessage delegate function
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!)
    {
        let messageObject = self.messageObjects[indexPath.row]
        let jsqMessage = self.jsqMessages[indexPath.row]
        if messageObject.messageType == MESSAGE_TYPE.Image.rawValue
        {
            let mediaItem = jsqMessage.media as! JSQPhotoMediaItem
            
            let photos = IDMPhoto.photosWithImages([mediaItem.image])
            let browserViewController = IDMPhotoBrowser(photos: photos)
            
            self.presentViewController(browserViewController, animated: true, completion: nil)
        }
        else if messageObject.messageType == MESSAGE_TYPE.Location.rawValue
        {
            let mediaItem = jsqMessage.media as! JSQLocationMediaItem
            let location = mediaItem.location
            
            self.performSegueWithIdentifier("SEGUE_MAP", sender: location)
        }
    }
    
    
    
    //MARK: TimeStamp
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        if indexPath.item % 3 == 0
        {
            let message = self.messageObjects[indexPath.item]
            let messageDate = HelperFunctions.DateFormatter().dateFromString(message.messageDate)
            
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(messageDate)
        }
        return nil
        
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if indexPath.item % 3 == 0
        {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
        
    }
    //MARK: STATUS
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let message = self.messageObjects[indexPath.row]
        let status = message.status
        if indexPath.row == self.messageObjects.count - 1 //if last message
        {
            return NSAttributedString(string: status)
        }
        return NSAttributedString(string: "")
        
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if self.isOutgoingMessage(self.messageObjects[indexPath.row]) //if last message is outgoing
        {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
        
    }
    

    
    
    
    
    //MARK: Send Message
    func SendMessage(date:NSDate, textMessage: String?, pictureMessage: UIImage?, locationMessage: String?)
    {
        var outgoingMessage: Message = Message()
        let currentUser = BackendlessFunctions.CURRENT_USER
        var messageType: String = ""
        var deliverySatus: String = ""
        
        
        if let text = textMessage //Send text message
        {
            messageType = MESSAGE_TYPE.Text.rawValue
            deliverySatus = DELIVERY_STATUS.Delivered.rawValue
            
            outgoingMessage = Message(messageText: text, senderID: currentUser.objectId, senderName: currentUser.name , messageDate: date, messageType: messageType, status: deliverySatus)
        }
        
        
        if let picture = pictureMessage //Send picture message
        {
            messageType = MESSAGE_TYPE.Image.rawValue
            deliverySatus = DELIVERY_STATUS.Delivered.rawValue
            
            let imageData = UIImageJPEGRepresentation(picture, 1.0) //Convert image to Data
            let imageDataString = HelperFunctions.ConvertImageDataToString(imageData!) //Convert data to String
            
            outgoingMessage = Message(messageText: messageType, imageDataString: imageDataString, senderID: currentUser.objectId, senderName: currentUser.name, messageDate: date, messageType: messageType, status: deliverySatus)
        }
        
        
        if let _ = locationMessage //Send location message
        {
            messageType = MESSAGE_TYPE.Location.rawValue
            deliverySatus = DELIVERY_STATUS.Delivered.rawValue
            
            let latitude: NSNumber = NSNumber(double: (self.appDelegate.coordinate!.latitude))
            let longtitude: NSNumber = NSNumber(double: (self.appDelegate.coordinate!.longitude))
            
            outgoingMessage = Message(messageText: messageType, longtitude: longtitude, latitude: latitude, senderID: currentUser.objectId, senderName: currentUser.name, messageDate: date, messageType: messageType, status: deliverySatus)
        }
        
        
        //Play message sent sound
        JSQSystemSoundPlayer.jsq_playMessageSentAlert()
        self.finishSendingMessage()
        
        
        MessagesFunctions.InsertToFirebase_Message(self.chatroomID, message: outgoingMessage)
    }
    
    
    
    //MARK: Load Messages
    func LoadMessages()
    {
        //One time for load all messasges
        MessagesFunctions.FIREBASE_MESSAGES.child(self.chatroomID).observeSingleEventOfType(.Value) { (snapshotData: FIRDataSnapshot) in
            
            //loop through all loadedMessages and insert them as JSQMessage
            for loadedMessage in self.loadedMessages
            {
                self.CreateJSQMessage(loadedMessage)
            }
            
            self.finishReceivingMessageAnimated(true)
            self.initialLoadCompleted = true
        }
        
        MessagesFunctions.FIREBASE_MESSAGES.child(self.chatroomID).observeEventType(.ChildAdded) { (snapshotData: FIRDataSnapshot) in
            
            if let value = snapshotData.value as? NSDictionary
            {
                let message = Message(values: value)
                if self.initialLoadCompleted
                {
                    self.CreateJSQMessage(message) //insert the message data to JSQMessage
                    
                    if !self.isOutgoingMessage(message) //check if it is an incoming message
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
        
        
        MessagesFunctions.FIREBASE_MESSAGES.child(self.chatroomID).observeEventType(.ChildRemoved) { (snapshotData: FIRDataSnapshot) in
            
            
        }
        
        MessagesFunctions.FIREBASE_MESSAGES.child(self.chatroomID).observeEventType(.ChildChanged) { (snapshotData: FIRDataSnapshot) in
            
            
        }
    }
    func CreateJSQMessage(message: Message)
    {
        var jsqMessage: JSQMessage?
        
        let messageType = message.messageType
        let senderName = message.senderName
        let senderID = message.senderID
        let messageText = message.messageText
        let messageDate = HelperFunctions.DateFormatter().dateFromString(message.messageDate)
        
        
        
        if messageType == MESSAGE_TYPE.Text.rawValue
        {
            jsqMessage = JSQMessage(senderId: senderID, senderDisplayName: senderName, date: messageDate, text: messageText)
        }
        else if messageType == MESSAGE_TYPE.Location.rawValue
        {
            let longtitude = message.longtitude as Double
            let latitude = message.latitude as Double
            let clLocation = CLLocation(latitude: latitude, longitude: longtitude)
            
            
            let mediaItem = JSQLocationMediaItem(location: nil)
            mediaItem.appliesMediaViewMaskAsOutgoing = false
            if senderID == BackendlessFunctions.CURRENT_USER.objectId
            {
                mediaItem.appliesMediaViewMaskAsOutgoing = true//outgoing message
            }
            
            
            mediaItem.setLocation(clLocation, withCompletionHandler: {
                //update our collectionView to show the map in the message collection view
                self.collectionView.reloadData()
            })
            
            
            jsqMessage = JSQMessage(senderId: senderID, senderDisplayName: senderName, date: messageDate, media: mediaItem)
            
        }
        else if messageType == MESSAGE_TYPE.Image.rawValue
        {
            let mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem.appliesMediaViewMaskAsOutgoing = false
            if senderID == BackendlessFunctions.CURRENT_USER.objectId
            {
                mediaItem.appliesMediaViewMaskAsOutgoing = true//outgoing message
            }
            
            HelperFunctions.ConvertStringToImage(message.imageDataString, completion: { (resultImage) in
                mediaItem.image = resultImage
                self.collectionView.reloadData()
            })
            
            jsqMessage = JSQMessage(senderId: senderID, senderDisplayName: senderName, date: messageDate, media: mediaItem)
            
        }
        
        
        self.messageObjects.append(message)
        if let msg = jsqMessage
        {
            self.jsqMessages.append(msg)
        }
        
    }
    
    
    
    //MARK: UIImagePickerController Delegate Functions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.SendMessage(NSDate(), textMessage: nil, pictureMessage: image, locationMessage: nil)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    //MARK: Segue Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "SEGUE_MAP"
        {
            let location = sender as! CLLocation
            
            let mapViewController = segue.destinationViewController as! MapViewController
            mapViewController.location = location
        }
    }
    
    
    //Outgoing Function
    func isOutgoingMessage(message: Message!) -> Bool {
        if message.senderID == self.senderId
        {
            return true
        }
        return false
    }
}
