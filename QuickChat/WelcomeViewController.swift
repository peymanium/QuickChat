//
//  WelcomeViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/9/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Automatically logs in if the user already logged in
        BACKENDLESS_REF.userService.setStayLoggedIn(true)
        if let user = BackendlessFunctions.instance.CURRENT_USER
        {
            BackendlessFunctions.instance.ShowChatViewController(self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
