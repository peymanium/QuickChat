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
    private var _firebase_database = FIREBASE_REF.child("Messages")
    var FIREBASE_DATABASE : FIRDatabaseReference
        {
        return self._firebase_database
    }
    
    
    //MARK: Functions
    
    
}