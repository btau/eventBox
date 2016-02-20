//
//  NetworkManager.swift
//  eventBox
//
//  Created by Brett Tau on 2/15/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

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
    var usersRef = Firebase!()
    
    private var events: [Event] = []
    private var currentUser: User?
    
    //MARK: Internal Functions
    init() {
        print("Network Manager Initialized")
        eventsRef = rootRef.childByAppendingPath("events")
        usersRef = rootRef.childByAppendingPath("users")
//        setUpObservers()
    }
    
    //MARK: Facebook Login
//    func isLoggedIn() -> Bool {
//        if authData != nil {
//            return true
//        }
//        return false
//    }
//    
//    func logout() {
//        rootRef.unauth()
//        authData = nil
//    }
    
    let facebookLogin = FBSDKLoginManager()
    
    func loginWithFB() 
    {
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: nil, handler:
            {(facebookResult, facebookError) -> Void in
            
            if facebookError != nil {
                print("Facebook Login failed. Error \(facebookError)")
            }
            else if facebookResult.isCancelled {
                print("Facebook Login was cancelled")
            }
            else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                self.rootRef.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    
                    if error != nil {
                        print("Login failed. \(error)")
                    }
                    else {
                        print("Logged In \(authData.providerData["displayName"])")
                        
                        let newUser = User(UID: authData.uid)
                        newUser.UID = authData.uid
                        newUser.userName = (authData.providerData["displayName"] as? String)!
                        newUser.image = (authData.providerData["profileImageURL"] as? String)!

                        let newUserRef = self.usersRef.childByAppendingPath(newUser.UID)
                        
                        let userData: [String:AnyObject] =
                        ["userName":newUser.userName,
                                 "image":newUser.image]

                        newUserRef.updateChildValues(userData)
                        
                        self.currentUser = newUser
                        print("Facebook func: \(self.currentUser!.UID)")
                    }
                })
            }
        })
    }
    
    //MARK: Set Up Observers
    func setUpObservers() {
        
        eventsRef.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) -> Void in
            let eventData = snapshot.value as! [String:AnyObject]
            let newEvent = self.unpackEvent(eventData)
            self.events.append(newEvent)
        }
        
        eventsRef.observeEventType(.ChildChanged) { (snapshot: FDataSnapshot!) -> Void in
            let eventData = snapshot.value as! [String:AnyObject]
            let changedEvent = self.unpackEvent(eventData)
            
            if let foundIndex = self.events.indexOf({ $0.eventUID == changedEvent.eventUID }) {
                self.events.removeAtIndex(foundIndex)
                self.events.insert(changedEvent, atIndex: foundIndex)
            }
        }
        
        eventsRef.observeEventType(.ChildRemoved) { (snapshot: FDataSnapshot!) -> Void in
            let eventData = snapshot.value as! [String:AnyObject]
            let removedEvent = self.unpackEvent(eventData)
            
            if let foundIndex = self.events.indexOf({ $0.eventUID == removedEvent.eventUID }) {
                self.events.removeAtIndex(foundIndex)
            }
        }
    }

    
    //MARK: Event Handling
    func sendEvent(event: Event) {
        
        let eventRef = eventsRef.childByAutoId()
        
        let eventData: [String:AnyObject] =
        ["eventUID": eventRef.key,
            "eventName": event.eventName,
            "hostUID": event.hostUID,
            "startDate": event.startDate,
            "lat":String(event.location.lat),
            "lon":String(event.location.lon),
            "messages": [],
            "guests":[],
            "items": []]
        
        eventRef.setValue(eventData)
    }
   
    
    func deleteEvent(eventUID: String) {
        let eventRef = eventsRef.childByAppendingPath(eventUID)
        
        let foundIndex = events.indexOf { (event:Event) -> Bool in
            if event.eventUID == eventUID {
                return true
            }
            return false
        }
        
        if let index = foundIndex {
            events.removeAtIndex(index)
            eventRef.removeValue()
        }
    }
    
    
    func unpackEvent(eventData: [String:AnyObject]) -> Event {
        let newEvent = Event()
        
        let lat = eventData["lat"] as! String
        let lon = eventData["lon"] as! String
        
        newEvent.location = LocationCords(lat: Double(lat)!, lon: Double(lon)!)
        newEvent.hostUID = eventData["hostUID"] as! String
        newEvent.eventUID = eventData["eventUID"] as! String
        newEvent.eventName = eventData["eventName"] as! String
        newEvent.startDate = eventData["startDate"] as! Double
        
        if let guests = eventData["guests"] as? [String] {
            for guest in guests {
                newEvent.guests.append(guest)
            }
        }
        
        if let items = eventData["items"] as? [Item] {
            for item in items {
                newEvent.items.append(item)
            }
        }
        
        return newEvent
        
            //        if let messages = eventData["messages"] as? [String:AnyObject] {
            //            for message in messages {
            //
            //                let time = message.1["time"] as! Double
            //                let newMessage = message.1["message"] as! String
            //                let userUID = message.1["userUID"] as! String
            //
            //                let messageUID = message.0
            //
            //                newEvent.messages.append(Message(userUID: userUID, time: time, message: message, messageUID: messageUID))
            //            }
            //        }
    }
    
    
    func getUserEvents() {
        eventsRef.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) -> Void in
            print("get Event Func: \(self.currentUser!.UID)")
            let keys = snapshot.value.allKeys as! [String]
            
            var userEvents = [Event]()
            
            for key in keys {
                guard let eventData = snapshot.value.objectForKey(key) as? [String:AnyObject]
                    else { print("Error in events"); break }
                
                let newEvent = self.unpackEvent(eventData)
                if newEvent.guests.contains((self.currentUser?.UID)!) {
                    userEvents.append(newEvent)
                    print("Count: \(userEvents.count)")
                }
            }
        }
    }
    
    //Event Attendance Handling
    func attendEvent(eventUID: String) {
        
        guard let userUID = currentUser?.UID
            else { Debug.log("No User"); return}
        
        let attendEventRef = eventsRef.childByAppendingPath("\(eventUID)/guests/\(userUID)")
        let attendanceData = ["time": String(NSDate().timeIntervalSince1970)]
        
        let userEventRef = usersRef.childByAppendingPath("\(userUID)/userEvents/\(eventUID)")
        let userEventData = ["time": String(NSDate().timeIntervalSince1970)]
        
        attendEventRef.updateChildValues(attendanceData)
        userEventRef.updateChildValues(userEventData)
    }
    
    func unattendEvent(userUID: String, eventUID: String) {
        
        let attendEventRef = eventsRef.childByAppendingPath("\(eventUID)/guests/\(userUID)")
        attendEventRef.removeValue()
        
        let userEventRef = usersRef.childByAppendingPath("\(userUID)/userEvents/\(eventUID)")
        userEventRef.removeValue()
    }
    
    
    //Admin Item Handling
    func addItem(item item: String, eventUID: String) {
        
        let eventItemRef = eventsRef.childByAppendingPath("\(eventUID)/items/").childByAutoId()
        
        let eventItemData = ["item": item]
        
        eventItemRef.setValue(eventItemData)
    }
    
    func removeItem(eventUID eventUID: String, itemUID: String) {
        
        let eventItemRef = eventsRef.childByAppendingPath("\(eventUID)/items/\(itemUID)")

        eventItemRef.removeValue()
    }
    
    //User Item Handling
    func selectItem(eventUID eventUID: String, itemUID: String, userUID: String) {
        
        let eventItemRef = eventsRef.childByAppendingPath("\(eventUID)/items/\(itemUID)")
        let eventItemData = ["userUID": String(userUID)]
        
        eventItemRef.updateChildValues(eventItemData)
    }
    
    func unselectItem(eventUID eventUID: String, itemUID: String) {
        
        let eventItemRef = eventsRef.childByAppendingPath("\(eventUID)/items/\(itemUID)/userUID")
        
        eventItemRef.removeValue()
    }
    
}


