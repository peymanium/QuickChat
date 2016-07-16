//
//  RecentTableViewCell.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/16/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet weak var IMG_Avatar : UIImageView!
    @IBOutlet weak var LBL_Name : UILabel!
    @IBOutlet weak var LBL_LastMessage : UILabel!
    @IBOutlet weak var LBL_Date : UILabel!
    @IBOutlet weak var LBL_Counter : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    func BindData(recent : Dictionary<String,AnyObject>)
    {
        //User AVATAR
        self.IMG_Avatar.layer.cornerRadius = self.IMG_Avatar.frame.size.width/2
        self.IMG_Avatar.clipsToBounds = true
        self.IMG_Avatar.image = UIImage(named: "profile")
        
        //Get ObjectID
        let withUserObjectID = recent["withUserObjectID"] as! String
    
        //Get Backendless user details
        
        //Using WhereClause
        let dataQuery = BackendlessDataQuery()
        let whereClause = "objectID='\(withUserObjectID)'"
        dataQuery.whereClause = whereClause
        
        let dataStore = REF_INSTANCE.data.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) in
            
            let firstUser = users.data.first as! BackendlessUser
            
        }) { (fault : Fault!) in
            
            print ("Error fetching user details \(fault)")
            
        }
        
        /*
        //Using FindBy ObjectID
        dataStore.findID(withUserObjectID, response: { (user : AnyObject!) in
            
            let firstUser = user as! BackendlessUser
            
        }) { (fault : Fault!) in
            
            print ("Error fetching user details \(fault)")
            
        }
         */
        
        
        //Name
        self.LBL_Name.text = recent["withUserUsername"] as? String
        self.LBL_LastMessage.text = recent["lastMessage"] as? String
        
        //New message
        self.LBL_Counter.text = ""
        if ((recent["counter"] as? Int)! != 0)
        {
            self.LBL_Counter.text = "\(recent["counter"]!) New"
        }
        
        //Date
        let messageDate = DateFormatter().dateFromString((recent["date"] as? String)!)
        let seconds = NSDate().timeIntervalSinceDate(messageDate!)
        self.LBL_Date.text = self.TimeElapsed(seconds)
        
    }
    func TimeElapsed(seconds : NSTimeInterval) -> String
    {
        let elapsed: String!
        
        if seconds < 60
        {
            elapsed = "Just now"
        }
        else if seconds < (60 * 60)
        {
            let minutes = Int(seconds/60)
            var minuteText = "min"
            
            if minutes > 1
            {
                minuteText = "mins"
            }
            
            elapsed = "\(minutes) \(minuteText)"
            
        }
        else if seconds < (24 * 60 * 60)
        {
            let hours = Int(seconds / (60 * 60))
            var hourText = "hour"
            
            if hours > 1
            {
                hourText = "hours"
            }
            
            elapsed = "\(hours) \(hourText)"
        }
        else
        {
            let days = Int(seconds / (24 * 60 * 60))
            var dayText = "day"
            
            if days > 1
            {
                dayText = "days"
            }
            
            elapsed = "\(days) \(dayText)"
        }
        
        return elapsed
    }
    
}
