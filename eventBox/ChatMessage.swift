//
//  ChatMessage.swift
//  eventBox
//
//  Created by Michael Berger on 3/2/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatMessage: JSQMessage {

    var avatarImage: UIImage?
    

    
    
    func getImageFromServer() {
        NetworkManager.sharedManager.getUserForUID(senderId) { (user) -> Void in
            
            let url:String = user.image
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) {(data, response, error) in
                self.avatarImage = UIImage(data: data!)
            }
            
            task.resume()
        }
    }
    
}
