//
//  RecentsViewController.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/16/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class RecentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var recents: [Recent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    //MARK: New Chat Button
    @IBAction func BTN_BewChat_Tapped(sender: AnyObject)
    {
    
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
}
