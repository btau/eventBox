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
    
    //MARK: Internal Functions
    init() {
        print("Network Manager Initialized")
        eventsRef = rootRef.childByAppendingPath("events")
        usersRef = rootRef.childByAppendingPath("users")
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
                    }
                
                })
            }
        })
    }
    
    //MARK: Event Handling
    func sendEvent(event: Event) {
        
        let eventRef = eventsRef.childByAutoId()
        
        let eventData =
        ["eventUID": eventRef.key,
            "eventName": event.eventName,
            "startDate": event.startDate,
            "lat":String(event.location.lat),
            "lon":String(event.location.lon),
            "comments": [],
            "guests":[]]
        
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
        newEvent.eventUID = eventData["eventUID"] as! String
        newEvent.eventName = eventData["eventName"] as! String
        newEvent.startDate = eventData["startDate"] as! Double
        //        newEvent.hostUID = eventData["hostUID"] as! String
        
        //        if let comments = eventData["comments"] as? [String:AnyObject] {
        //            for comment in comments {
        //
        //                let time = comment.1["time"] as! Double
        //                let message = comment.1["message"] as! String
        //                let userUID = comment.1["userUID"] as! String
        //
        //                let commentUID = comment.0
        //
        //                newEvent.comments.append(Comment(userUID: userUID, time: time, message: message, commentUID: commentUID))
        //            }
        //        }
        return newEvent
    }
    
    
    func getEvents() {
        eventsRef.observeEventType(.Value) { (snapshot: FDataSnapshot!) -> Void in
            
            let keys = snapshot.value.allKeys as! [String]
            
            var allEvents = [Event]()
            
            for key in keys {
                guard let eventData = snapshot.value.objectForKey(key) as? [String:AnyObject]
                    else { print("Error in events"); break }
                
                let newEvent = self.unpackEvent(eventData)
                
                allEvents.append(newEvent)
                print(newEvent.eventName)
            }

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            })
        }
    }

    
}