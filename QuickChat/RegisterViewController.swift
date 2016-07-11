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
            let user = BackendlessUser()
            user.email = email
            user.password = password
            user.name = username
            user.setProperty("dateOfBirth", object: NSDate())
            
            REF_INSTANCE.userService.registering(user, response: { (registeredUser: BackendlessUser!) in
                
                print ("User created successfully \(registeredUser.email)")
                
                BackendlessFunctions.instance.LoginUser(email, password: password)
                
                self.TXT_Username.text = ""
                self.TXT_Password.text = ""
                self.TXT_Email.text = ""
                
            }) { (fault: Fault!) in
                
                print ("Error registering user \(fault)")
                
            }
        }
        else
        {
            print ("All feilds are mandatory")
        }
    }
    
}
