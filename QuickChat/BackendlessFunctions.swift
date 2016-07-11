//
//  BackendlessFunctions.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/11/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation

let REF_INSTANCE = Backendless.sharedInstance()

class BackendlessFunctions
{
    static let instance = BackendlessFunctions()

    func LoginUser(email: String, password: String)
    {
        REF_INSTANCE.userService.login(email, password: password, response: { (loggedInUser : BackendlessUser!) in
            
            print ("User \(email) logged in successfully")
            self.SegueToRecent()
            
        }) { (fault : Fault!) in
                print ("Error login user \(email) with error: \(fault)")
        }
    }
    private func SegueToRecent()
    {
        
    }
    
    
}