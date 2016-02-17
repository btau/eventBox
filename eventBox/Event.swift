//
//  Event.swift
//  eventBox
//
//  Created by Brett Tau on 2/16/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import Foundation
import UIKit

struct LocationCords {
    var lat: Double
    var lon: Double
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

struct Guest {
    var userUID: String
    
    init(userUID: String) {
        self.userUID = userUID
    }
}

struct Comment {
    var userUID: String
    var time: NSDate
    var message: String
    var commentUID: String
    
    init(userUID: String, time: Double, message: String, commentUID: String) {
        self.userUID = userUID
        self.time = NSDate(timeIntervalSince1970: time)
        self.message = message
        self.commentUID = commentUID
    }
}

class Event {
    var hostUID: String
    var eventUID: String
    var eventName: String
    var startDate: Double
    var location: LocationCords
    var comments: [Comment]
    var guests: [User]
    
    init() {
        hostUID = ""
        eventUID = ""
        eventName = ""
        startDate = 0
        location = LocationCords(lat: 0.0, lon: 0.0)
        comments = []
        guests = []
    }
}