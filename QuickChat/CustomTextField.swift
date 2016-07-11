//
//  CustomTextField.swift
//  QuickChat
//
//  Created by Peyman Attarzadeh on 7/11/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {


    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.font = UIFont(name: "Helvetica Neue Thin ", size: 40)
    }

}
