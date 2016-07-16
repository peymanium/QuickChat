//
//  HelperFunctions.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/16/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation


private let dateFormat = "yyyyMMddHHmmss"
func DateFormatter() -> NSDateFormatter
{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}