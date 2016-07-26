//
//  RecentsViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/16/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit
import Firebase

class RecentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChooseUserDelegate {

    @IBOutlet weak var tableView: UITableView!
    var recents = [Recent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.ReadDataFromFirebase_Recent()
    
    }
    func ReadDataFromFirebase_Recent()
    {
        let userID = BackendlessFunctions.instance.CURRENT_USER?.objectId
        
        FirebaseFunctions.instance.FIREBASE_RECENT.queryOrderedByChild("userID").queryEqualToValue(userID).observeEventType(.Value) { (snapshotData: FIRDataSnapshot) in
            
            //snapshotData.children.allObjects as? [FIRDataSnapshot]
            //snapshotData.value?.allValues as? [Dictionary<String,AnyObject>]
            self.recents.removeAll()
            if let values = snapshotData.value?.allValues
            {
                let sortDescriptor = NSSortDescriptor(key: "messageDate", ascending: false)
                let sorted = (values as NSArray).sortedArrayUsingDescriptors([sortDescriptor])
                
                for value in sorted
                {
                    let recent = Recent(values: value as! Dictionary<String, AnyObject>)
                    self.recents.append(recent)
                }
            }
            
            self.tableView.reloadData()
        }
    }


    
    //MARK: UITableView Delegate Functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recents.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as? RecentTableViewCell
        {
            let recent = self.recents[indexPath.row]
            cell.ConfigureCell(recent)
            
            return cell
        }
        else
        {
            return RecentTableViewCell()
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("SEGUE_CHAT", sender: indexPath)
    }
    
    
    
    //MARK: New Chat Button
    @IBAction func BTN_NewChat_Tapped(sender: AnyObject)
    {
        self.performSegueWithIdentifier("SEGUE_CHOOSEUSER", sender: self)
    }
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "SEGUE_CHOOSEUSER"
        {
            let chooseUserViewController = segue.destinationViewController as! ChooseUserViewController
            chooseUserViewController.delegate = self
        }
        
        if segue.identifier == "SEGUE_CHAT"
        {
            let indexPath = sender as! NSIndexPath
            let recent = self.recents[indexPath.row]
            
            let chatViewController = segue.destinationViewController as! ChatViewController
            
            chatViewController.chatroomID = recent.chatroomID
            chatViewController.recent = recent
            
        }
    }
    
    
    //MARK: NewMessageDelegate
    func CreateChatroom(withUser: BackendlessUser)
    {
        let chatViewController = ChatViewController()
        chatViewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
        
        chatViewController.chatroomID = HelperFunctions.instance.StartChat(BackendlessFunctions.instance.CURRENT_USER!, withUser: withUser)
        
        chatViewController.withUser = withUser
    }
    
}
