//
//  HelperFunctions.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 10/24/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation

class HelperFunctions
{
    static let instance = HelperFunctions()
    
    
    private let dateFormat = "yyyyMMddHHmmss"
    func DateFormatter() -> NSDateFormatter
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter
    }
}
