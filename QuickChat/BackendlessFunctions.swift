//
//  BackendlessFunctions.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/11/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation

let BACKENDLESS_INSTANCE = Backendless.sharedInstance()
let CURRENT_USER = BACKENDLESS_INSTANCE.userService.currentUser

class BackendlessFunctions
{
    static let instance = BackendlessFunctions()

    func LoginUser(email: String, password: String, viewController : UIViewController!, completion: ()->Void)
    {
        ProgressHUD.show("Loading...")
        
        BACKENDLESS_INSTANCE.userService.login(email, password: password, response: { (loggedInUser : BackendlessUser!) in
            
            completion() //To know if user logged in successully or not
            self.ShowChatViewController(viewController)
            
        }) { (fault : Fault!) in
            
                ProgressHUD.showError("Error login user \(email)")
        }
    }
    func ShowChatViewController(viewController : UIViewController)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            //Segue to ChatViewController UITabBarController
            let chatViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ChatViewController") as! UITabBarController
            chatViewController.selectedIndex = 0
            
            ProgressHUD.dismiss()
            
            viewController.presentViewController(chatViewController, animated: true, completion: nil)
        }
    }
    
    
    func GetBackendlessUser(userObjectID: String!, completion: (BackendlessUser) -> Void)
    {
        //Using WhereClause
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "objectID='\(userObjectID)'"
        
        let dataStore = BACKENDLESS_INSTANCE.data.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) in
            
            let firstUser = users.data.first as! BackendlessUser
            completion(firstUser)
            
        }) { (fault : Fault!) in
            
            print ("Error fetching user details \(fault)")
            
        }
    }
    func GetBackendlessUserWithObjectId(userObjectID: String!, completion: (BackendlessUser) -> Void)
    {
         let dataStore = BACKENDLESS_INSTANCE.data.of(BackendlessUser.ofClass())
         dataStore.findID(userObjectID, response: { (user : AnyObject!) in
         
         let firstUser = user as! BackendlessUser
            completion(firstUser)
         
         }) { (fault : Fault!) in
         
         print ("Error fetching user details \(fault)")
         
         }
        
    }
    func GetAllBackendlessUsers(currentUserObjectID : String!) -> [BackendlessUser]
    {
        var users = [BackendlessUser]()
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "objectId != '\(currentUserObjectID)'"
        
        let dataStore = BACKENDLESS_INSTANCE.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (responseCollection: BackendlessCollection!) in
            
            users = responseCollection.data as! [BackendlessUser]
            
        }) { (fault: Fault!) in
                print ("Error fetching users")
        }
        
        return users
    }
    
}