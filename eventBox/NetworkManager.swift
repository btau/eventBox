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
    
    
    //MARK: Facebook Login
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
                        print("Logged In \(authData)")
                    }
                
                })
            }
        })
    }
    
    
    
    
    
}