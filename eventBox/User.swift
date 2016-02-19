//
//  User.swift
//  eventBox
//
//  Created by Brett Tau on 2/17/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import Foundation
import UIKit


struct UserEvent {
    var eventUID: String
    var time: NSDate
    
    init(eventUID: String, time: String) {
        self.eventUID = eventUID
        self.time = NSDate(timeIntervalSince1970: Double(time)!)
    }
}

class User {
    var UID: String
    var userName: String
    var image: String
    var userEvents: [String] //String will be eventUID
    
    init(UID: String) {
        self.UID = UID
        self.userName = ""
        self.image = ""
        self.userEvents = []
    }
}
