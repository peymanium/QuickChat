//
//  LoginViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/11/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var TXT_Email: UITextField!
    @IBOutlet weak var TXT_Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func BTN_Login_Tapped (sender: AnyObject)
    {
        if let email = self.TXT_Email.text where email != "", let password = self.TXT_Password.text where password != ""
        {
            BackendlessFunctions.instance.LoginUser(email, password: password)
            
            self.TXT_Password.text = ""
            self.TXT_Email.text = ""
        }
        else
        {
            print ("All fields are mandatory")
        }
    }
}
