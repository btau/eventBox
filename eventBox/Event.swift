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

struct Comment {
    var userUID: String
    var time: NSDate
    var message: String
    
    init(userUID: String, time: Double, message: String) {
        self.userUID = userUID
        self.time = NSDate(timeIntervalSince1970: time)
        self.message = message
    }
}

class Event {
    var eventUID: String
    var eventName: String
//    var startDate: NSDate
//    var startTime: NSDate
//    var endDate: NSDate
//    var endTime: NSDate
    var location: LocationCords
    var comments: [Comment]
    
    init(time: Double) {
        eventUID = ""
        eventName = ""
//        startDate = NSDate(
//        startTime = NSDate(
//        endDate = NSDate(
//        endTime = NSDate(
        location = LocationCords(lat: 0.0, lon: 0.0)
        comments = []
    }
}