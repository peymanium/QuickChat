//
//  BackendlessFunctions.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/11/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation

let REF_INSTANCE = Backendless.sharedInstance()
let CURRENT_USER = REF_INSTANCE.userService.currentUser

class BackendlessFunctions
{
    static let instance = BackendlessFunctions()

    func LoginUser(email: String, password: String, viewController : UIViewController!)
    {
        REF_INSTANCE.userService.login(email, password: password, response: { (loggedInUser : BackendlessUser!) in
            
            print ("User \(email) logged in successfully")
            
            self.ShowChatViewController(viewController)
            
        }) { (fault : Fault!) in
                print ("Error login user \(email) with error: \(fault)")
        }
    }
    func ShowChatViewController(viewController : UIViewController)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            //Segue to ChatViewController UITabBarController
            let chatViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ChatViewController") as! UITabBarController
            chatViewController.selectedIndex = 0
            
            viewController.presentViewController(chatViewController, animated: true, completion: nil)
        }
    }
    
}