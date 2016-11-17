//
//  RegisterViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/11/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var TXT_Email: UITextField!
    @IBOutlet weak var TXT_Username: UITextField!
    @IBOutlet weak var TXT_Password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    
    @IBAction func BTN_Register_Tapped(sender: AnyObject)
    {
        if let email = self.TXT_Email.text where email != "", let password = self.TXT_Password.text where password != "", let username = self.TXT_Username.text where username != ""
        {
            BackendlessFunctions.CreateUser(username, email: email, password: password, complition: { (user) in
                
                ProgressHUD.showSuccess("User created successfully")
                
                BackendlessFunctions.LoginUser(user.email, password: user.password, viewController: self, completion: {
                    
                    self.TXT_Username.text = ""
                    self.TXT_Password.text = ""
                    self.TXT_Email.text = ""
                    
                })
                
            })
        }
        else
        {
            ProgressHUD.showError("All fields required")
        }
    }
    
}
