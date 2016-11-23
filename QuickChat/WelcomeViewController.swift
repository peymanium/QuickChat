//
//  WelcomeViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/9/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    let backendless = Backendless.sharedInstance()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Automatically logs in if the user already logged in
        backendless.userService.setStayLoggedIn(true)
        let currentUser = backendless.userService.currentUser
        if currentUser != nil
        {
            print ("Welcome user: \(currentUser.name)")
            BackendlessFunctions.ShowChatViewController(self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
