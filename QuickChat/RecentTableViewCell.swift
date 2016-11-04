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
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func ConfigureCell(recent : Recent)
    {
        //User AVATAR
        self.IMG_Avatar.layer.cornerRadius = self.IMG_Avatar.frame.size.width/2
        self.IMG_Avatar.clipsToBounds = true
        self.IMG_Avatar.image = UIImage(named: "profile")
        
        BackendlessFunctions.GetBackendlessUser(recent.userReceiverID) { (user: BackendlessUser) in
            let userReceiver = user
            
            print ("userReceiver: \(userReceiver)")
        }
        
        
        
        //Name
        self.LBL_Name.text = recent.userReceiverUsername
        self.LBL_LastMessage.text = recent.lastMessage
        
        //New message
        self.LBL_Counter.text = ""
        if ((recent.counter) != 0)
        {
            self.LBL_Counter.text = "\(recent.counter) New"
        }
        
        //Date
        let messageDate = HelperFunctions.DateFormatter().dateFromString((recent.messageDate))
        let seconds = NSDate().timeIntervalSinceDate(messageDate!) //check how many seconds has been passed from today and the date of the recent message date
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
