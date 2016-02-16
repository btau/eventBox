//
//  NetworkManager.swift
//  eventBox
//
//  Created by Brett Tau on 2/15/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import Foundation
import Firebase

class NetworkManager {
    
    class var sharedManager: NetworkManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: NetworkManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkManager()
        }
        return Static.instance!
    }
    
    private
    
    let rootRef = Firebase(url: "https://eventbox.firebaseio.com")
    var eventsRef = Firebase!()
    var authData = FAuthData?()
    
    
}