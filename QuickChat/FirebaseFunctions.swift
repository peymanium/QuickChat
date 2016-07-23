//
//  FirebaseFunctions.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/19/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import Firebase

let FIREBASE_REF = FIRDatabase.database().reference()

class FirebaseFunctions
{
    static let instance = FirebaseFunctions()
    
    //MARK: Variables
    private var _firebase_messages = FIREBASE_REF.child("Messages")
    var FIREBASE_MESSAGES : FIRDatabaseReference
        {
        return self._firebase_messages
    }
    private var _firebase_recent = FIREBASE_REF.child("Recents")
    var FIREBASE_RECENT : FIRDatabaseReference
        {
        return self._firebase_recent
    }
    
    
    //MARK: Functions
    func InserToFirebase_Recent(userID: String, withUserID: String, chatroomID: String, members: [String], withUserUsername: String)
    {
        
        //Check if chatroomID already exists or not
        let chatroomRef = FirebaseFunctions.instance.FIREBASE_RECENT.queryOrderedByChild("chatroomID").queryEqualToValue(chatroomID)
        chatroomRef.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot!) in
            
            if snapshot.childrenCount == 0 //No value found
            {
                //Create a reference in firebase for the new data branch
                let ref = FirebaseFunctions.instance.FIREBASE_RECENT.childByAutoId()
                
                let recentID = ref.key
                let messageDate = HelperFunctions.instance.DateFormatter().stringFromDate(NSDate())
                
                let values : Dictionary<String,AnyObject> =
                    ["recentID": recentID ,
                     "chatroomID": chatroomID ,
                     "userID": userID,
                     "withUserID": withUserID,
                     "withUserUsername": withUserUsername,
                     "members": members,
                     "counter": 0,
                     "lastMessage": "",
                     "date" : messageDate,
                     "order" : -1 * NSDate.timeIntervalSinceReferenceDate()
                ]
                
                //Add to Firebase
                ref.setValue(values, withCompletionBlock: { (error: NSError?, firebaseReference: FIRDatabaseReference) in
                    
                    if error != nil
                    {
                        print ("Something went wrong \(error.debugDescription)")
                    }
                    
                })
            }
            
        }
        
        
        
        
        
    }
    
}