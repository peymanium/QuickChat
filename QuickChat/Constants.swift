//
//  Constants.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/8/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation

//Backendless Constants
let APP_ID = "FC76E559-4456-576D-FFBB-8821BA34BA00"
let SECRET_KEY = "8DC820B2-A606-7B39-FFC4-565DCD7AAF00"
let VERSION_NUM = "v1"

//Contants for SettingViewController
let kAVATARSTATE = "AvatarState"
let kFIRSTRUN = "FirstRun"

//MARK: Enums
enum MESSAGE_TYPE: String
{
    case Text
    case Image
    case Location
}
enum DELIVERY_STATUS: String
{
    case Delivered
}
