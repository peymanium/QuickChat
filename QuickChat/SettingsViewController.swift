//
//  SettingsViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 11/5/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var VIEW_Header: UIView!
    @IBOutlet weak var IMG_User: UIImageView!
    @IBOutlet weak var LBL_User: UILabel!
    @IBOutlet weak var CELL_Avatar: UITableViewCell!
    @IBOutlet weak var CELL_Terms: UITableViewCell!
    @IBOutlet weak var CELL_Privacy: UITableViewCell!
    @IBOutlet weak var CELL_Logout: UITableViewCell!
    @IBOutlet weak var SWITCH_UseAvatar: UISwitch!
    
    var showAvatarSwitchStatus: Bool = true
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var firstLoad: Bool?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()


        self.tableView.tableHeaderView = self.VIEW_Header //To place the profile image view on top of the table view
        self.IMG_User.layer.cornerRadius = self.IMG_User.frame.size.width / 2
        self.IMG_User.layer.masksToBounds = true
        
        self.LoadUserDefaults()
        self.UpdateUserDetails()
    }
    
    //MARK: TapGesture AND IBActions
    @IBAction func IMG_Tapped(sender: AnyObject)
    {
        let camera = Camera(delegate: self)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let actionTakePhoto = UIAlertAction(title: "Take Photo", style: .Default) { (alertAction: UIAlertAction) in
            
            camera.PresentCamera(self, canEdit: true)
            
        }
        let actionSharePhoto = UIAlertAction(title: "Photo From Library", style: .Default) { (alertAction: UIAlertAction) in
            
            camera.PresentPhotoLibrary(self, canEdit: true)
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction: UIAlertAction) in
            print ("Cancel")
        }
        
        alertController.addAction(actionTakePhoto)
        alertController.addAction(actionSharePhoto)
        alertController.addAction(actionCancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func SWITCH_ValueChanged(sender: UISwitch)
    {
        if sender.on
        {
            showAvatarSwitchStatus = true
        }
        else
        {
            showAvatarSwitchStatus = false
        }
        
        //Save details in UserDefaults
        
    }
    
    
    //MARK: UserDefaults Function
    func SetUserDefaults()
    {
        self.userDefaults.setBool(true, forKey: kFIRSTRUN)
        self.userDefaults.setBool(self.showAvatarSwitchStatus, forKey: kAVATARSTATE)
        self.userDefaults.synchronize()
    }
    func LoadUserDefaults()
    {
        self.firstLoad = self.userDefaults.boolForKey(kFIRSTRUN)
        if !self.firstLoad! //if self.firstLoad is empty, its first time run
        {
            self.SetUserDefaults()
        }
        
        self.showAvatarSwitchStatus = self.userDefaults.boolForKey(kAVATARSTATE)
    }

    
    //MARK: Update User Details (Avatar/Username)
    func UpdateUserDetails()
    {
        self.LBL_User.text = BackendlessFunctions.CURRENT_USER.name
        
        self.SWITCH_UseAvatar.setOn(self.showAvatarSwitchStatus, animated: false)
        
        if let imageURL = BackendlessFunctions.CURRENT_USER.getProperty("avatarImageURL") as?String
        {
            BackendlessFunctions.DownloadAvatarImage(imageURL, complition: { (image) in
                if let img = image
                {
                    self.IMG_User.image = img
                }
            })
        }
        
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 3
        }
        else if section == 1
        {
            return 1
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 && indexPath.row == 0 { return CELL_Privacy }
        if indexPath.section == 0 && indexPath.row == 1 { return CELL_Terms }
        if indexPath.section == 0 && indexPath.row == 2 { return CELL_Avatar }
        if indexPath.section == 1 && indexPath.row == 0 { return CELL_Logout }
        
        return UITableViewCell()
    }
 
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0
        }
        
        return 25
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                self.ShowLogoutController()
            }
        }
    }
    
    
    //MARK:Logout Controller
    func ShowLogoutController()
    {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        
        let actionLogout = UIAlertAction(title: "Logout", style: .Destructive) { (alertAction: UIAlertAction) in
            
            BACKENDLESS_REF.userService.logout()
            
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let loginViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginView")
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction:UIAlertAction) in
            
        }
        
        alertController.addAction(actionLogout)
        alertController.addAction(actionCancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:UIImagePicketController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let currentUser = BackendlessFunctions.CURRENT_USER
        BackendlessFunctions.UploadAvatarImage(image) { (imageURL) in
            
            currentUser.setProperty("avatarImageURL", object: imageURL!)
            BACKENDLESS_REF.userService.update(currentUser, response: { (updatedUser: BackendlessUser!) in
                
                print ("User \(updatedUser.name) updated successfully")
                
                }, error: { (error: Fault!) in
                    print ("failed to update \(error.debugDescription)")
            })
            
            picker.dismissViewControllerAnimated(true, completion: nil)
            self.UpdateUserDetails()
        }
        
    }
    
}
