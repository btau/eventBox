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
    var time: NSDate
    
    init(userUID: String, time: String) {
        self.userUID = userUID
        self.time = NSDate(timeIntervalSince1970: Double(time)!)
    }
}

struct Message {
    var userUID: String
    var time: NSDate
    var message: String
    var messageUID: String
    
    init(userUID: String, time: Double, message: String, messageUID: String) {
        self.userUID = userUID
        self.time = NSDate(timeIntervalSince1970: time)
        self.message = message
        self.messageUID = messageUID
    }
}

struct Item {
    var itemUID: String
    var item: String
    var userUID: String
    
    init(itemUID: String, item: String, userUID: String) {
        self.itemUID = itemUID
        self.item = item
        self.userUID = userUID
    }
}

class Event {
    var hostUID: String
    var eventUID: String
    var eventName: String
    var startDate: Double
    var location: LocationCords
    var messages: [Message]
    var guests: [String] //String with userUID
    var items: [Item]
    var backgroundImage: UIImage {
        return UIImage(named: imageName)!
    }
    var imageName: String
    
    init() {
        hostUID = ""
        eventUID = ""
        eventName = ""
        startDate = 0
        location = LocationCords(lat: 0.0, lon: 0.0)
        messages = []
        guests = []
        items = []
        imageName = "1"
    }
}