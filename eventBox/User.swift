//
//  User.swift
//  eventBox
//
//  Created by Brett Tau on 2/17/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import Foundation
import UIKit

class User {
    var UID: String
    var userName: String
    var image: UIImage
    
    init(UID: String, userName: String) {
        self.UID = UID
        self.userName = ""
        self.image = UIImage()
    }
}
