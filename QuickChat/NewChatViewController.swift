//
//  NewChatViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/18/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

protocol NewChatDelegate
{
    func CreateChatroom(withUser : BackendlessUser)
}

class NewChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [BackendlessUser]()
    var delegate : NewChatDelegate!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        users = BackendlessFunctions.instance.GetAllBackendlessUsers(CURRENT_USER.objectId)
        self.tableView.reloadData()
        
    }
    
    @IBAction func BTN_Cancel_Tapped(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: UITableViewDelegateFunctions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath)
        
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.name
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let user = self.users[indexPath.row]
        
        delegate.CreateChatroom(user)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
