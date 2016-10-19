//
//  HelperFunctions.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/16/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import Firebase

class HelperFunctions
{
    static let instance = HelperFunctions()
    
    
    private let dateFormat = "yyyyMMddHHmmss"
    func DateFormatter() -> NSDateFormatter
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter
    }
    
    
    //MARK: Create Chatroom
    func CreateChatroomID(user: BackendlessUser, withUser:BackendlessUser) -> String
    {
        var chatroomID = ""
        
        let userID: String = user.objectId
        let withUserID: String = withUser.objectId
        
        //We use Compare function in order to get the same ChartroomID even if the users switch in the function call parameters
        let value = userID.compare(withUserID).rawValue
        if value < 0
        {
            chatroomID = userID.stringByAppendingString(withUserID)
        }
        else
        {
            chatroomID = withUserID.stringByAppendingString(userID)
        }
        
        let members = [userID, withUserID]
        
        //Create 2 chatrooms for 2 users
        FirebaseFunctions.instance.InsertToFirebase_Recent(userID, withUserID: withUserID, chatroomID: chatroomID, members: members, withUserUsername: withUser.name)
        FirebaseFunctions.instance.InsertToFirebase_Recent(withUserID, withUserID: userID, chatroomID: chatroomID, members: members, withUserUsername: user.name)
        
        return chatroomID
    }
    
    
    //MARK: Restart Recent Chat
    //This function is being used when one user deletes a chat but the other user want to send him a message, so a new Recent data should be added in Firebase, as it should always have 2 recent records in firebase between CurrentUser ane WithUser.
    func RestartRecentChat(recent: Recent)
    {
        for userID in recent.members
        {
            let currentUser = BackendlessFunctions.instance.CURRENT_USER!
            
            if userID != currentUser.objectId
            {
                FirebaseFunctions.instance.InsertToFirebase_Recent(userID, withUserID: currentUser.objectId, chatroomID: recent.chatroomID, members: recent.members, withUserUsername: currentUser.name)
            }
        }
        
        
    }
    
}
