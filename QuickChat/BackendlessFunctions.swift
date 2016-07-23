//
//  BackendlessFunctions.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/11/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation

let BACKENDLESS_REF = Backendless.sharedInstance()

class BackendlessFunctions
{
    static let instance = BackendlessFunctions()

    //MARK: Variables
    private var _currentUser = BACKENDLESS_REF.userService.currentUser
    var CURRENT_USER : BackendlessUser?
    {
        return self._currentUser
    }
    
    
    //MARK: Functions
    func LoginUser(email: String, password: String, viewController : UIViewController!, completion: ()->Void)
    {
        ProgressHUD.show("Loading...")
        
        BACKENDLESS_REF.userService.login(email, password: password, response: { (loggedInUser : BackendlessUser!) in
            
            self._currentUser = loggedInUser
            
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
    
    
    func GetBackendlessUser(userID: String!, completion: (BackendlessUser) -> Void)
    {
        //Using WhereClause
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "objectID='\(userID)'"
        
        let dataStore = BACKENDLESS_REF.data.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) in
            
            let firstUser = users.data.first as! BackendlessUser
            completion(firstUser)
            
        }) { (fault : Fault!) in
            
            print ("Error fetching user details \(fault)")
            
        }
    }
    func GetBackendlessUserWithID(userID: String!, completion: (BackendlessUser) -> Void)
    {
         let dataStore = BACKENDLESS_REF.data.of(BackendlessUser.ofClass())
         dataStore.findID(userID, response: { (user : AnyObject!) in
         
         let firstUser = user as! BackendlessUser
            completion(firstUser)
         
         }) { (fault : Fault!) in
         
         print ("Error fetching user details \(fault)")
         
         }
        
    }
    //get list of all users except the current user (not to see his name in the list)
    func GetAllBackendlessUsers(currentUserID : String!, completion: ([BackendlessUser]) -> Void)
    {
        var users = [BackendlessUser]()
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "objectId != '\(currentUserID)'"
        
        let dataStore = BACKENDLESS_REF.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (responseCollection: BackendlessCollection!) in
            
            users = responseCollection.data as! [BackendlessUser]
            completion(users)
            
        }) { (fault: Fault!) in
                print ("Error fetching users")
        }
    }
    
}