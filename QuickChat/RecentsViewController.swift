//
//  RecentsViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/16/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class RecentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewChatDelegate {

    var recents = [Recent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
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
    
    
    
    //MARK: New Chat Button
    @IBAction func BTN_NewChat_Tapped(sender: AnyObject)
    {
        self.performSegueWithIdentifier("SEGUE_NEWCHAT", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "SEGUE_NEWCHAT"
        {
            let newChatViewController = segue.destinationViewController as! NewChatViewController
            newChatViewController.delegate = self
        }
    }
    
    
    //MARK: NewMessageDelegate
    func CreateChatroom(withUser: BackendlessUser)
    {
        
    }
    
}
