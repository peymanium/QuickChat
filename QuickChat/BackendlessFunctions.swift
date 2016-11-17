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
    //static let instance = BackendlessFunctions()

    //MARK: Variables
    static private var _currentUser = BACKENDLESS_REF.userService.currentUser
    static var CURRENT_USER : BackendlessUser!
    {
        return self._currentUser
    }
    
    
    //MARK: Login
    class func LoginUser(email: String, password: String, viewController : UIViewController!, completion: ()->Void)
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
    class func ShowChatViewController(viewController : UIViewController)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            //Segue to ChatViewController UITabBarController
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let chatViewController  = storyBoard.instantiateViewControllerWithIdentifier("ChatView") as! UITabBarController
            chatViewController.selectedIndex = 0
            
            ProgressHUD.dismiss()
            
            viewController.presentViewController(chatViewController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: Backendless User
    class func GetBackendlessUser(userID: String!, completion: (user: BackendlessUser) -> Void)
    {
        //Using WhereClause
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "objectID='\(userID)'"
        
        let dataStore = BACKENDLESS_REF.data.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) in
            
            let firstUser = users.data.first as! BackendlessUser
            completion(user: firstUser)
            
        }) { (fault : Fault!) in
            
            print ("Error fetching user details \(fault)")
            
        }
    }
    class func GetBackendlessUserWithID(userID: String!, completion: (user: BackendlessUser) -> Void)
    {
         let dataStore = BACKENDLESS_REF.data.of(BackendlessUser.ofClass())
         dataStore.findID(userID, response: { (user : AnyObject!) in
         
         let firstUser = user as! BackendlessUser
            completion(user: firstUser)
         
         }) { (fault : Fault!) in
         
         print ("Error fetching user details \(fault)")
         
         }
        
    }
    //get list of all users except the current user (not to see his name in the list)
    class func GetAllBackendlessUsers(currentUserID : String!, completion: (users: [BackendlessUser]) -> Void)
    {
        var users = [BackendlessUser]()
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "objectId != '\(currentUserID)'"
        
        let dataStore = BACKENDLESS_REF.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (responseCollection: BackendlessCollection!) in
            
            users = responseCollection.data as! [BackendlessUser]
            completion(users: users)
            
        }) { (fault: Fault!) in
                print ("Error fetching users")
        }
    }
    
    
    //MARK: Create User
    class func CreateUser(username: String, email: String, password: String, complition: (user: BackendlessUser) -> Void)
    {
        let user = BackendlessUser()
        user.email = email
        user.password = password
        user.name = username
        user.setProperty("dateOfBirth", object: NSDate())
        
        BACKENDLESS_REF.userService.registering(user, response: { (registeredUser: BackendlessUser!) in
            
            complition(user: registeredUser)
            
        }) { (fault: Fault!) in
            
            ProgressHUD.showError("Error registering user \(email))")
            
        }
    
    }


    //MARK:Upload/Download image
    class func UploadAvatarImage(image: UIImage, complition: (imageURL: String?) -> Void)
    {
        let imageData = UIImageJPEGRepresentation(image, 0.3)
        let fileName = "Image/\(CURRENT_USER.objectId).jpeg"
        
        BACKENDLESS_REF.fileService.upload(fileName, content: imageData, overwrite: true, response: { (responseFile: BackendlessFile!) in
            
            complition(imageURL: responseFile.fileURL)
            
        }) { (error: Fault!) in
            print ("There is an error uploading file \(fileName)")
        }
    }
    class func DownloadAvatarImage(imageURL: String, complition: (image: UIImage?) -> Void)
    {
        let nsURL = NSURL(string: imageURL)
        
        let downloadQueue = dispatch_queue_create("imageDownloadQueue", nil)
        dispatch_async(downloadQueue) { 
            if let imageData = NSData(contentsOfURL: nsURL!)
            {
                let image = UIImage(data: imageData)
                
                dispatch_async(dispatch_get_main_queue(), { 
                    complition(image: image)
                })
                
            }
        }
    }
    
    
}
