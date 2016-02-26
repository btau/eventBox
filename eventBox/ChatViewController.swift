//
//  ChatViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/25/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FoldingTabBar
import Firebase

class ChatViewController: JSQMessagesViewController, YALTabBarInteracting {

    var messages = [JSQMessage]()
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChat()
    }

    private func initChat() {
        guard let selfAuth =  NetworkManager.sharedManager.authData else {
            Debug.log("No AuthData found")
            fatalError("No User")
        }
        NetworkManager.sharedManager.getUserForUID(senderId) { (user) -> Void in
            self.senderDisplayName = user.userName
        }
        tempFirebase()
        self.inputToolbar?.barStyle = .Black
        self.inputToolbar?.contentView?.textView?.keyboardAppearance = .Dark
        self.inputToolbar?.hidden = true
        self.collectionView?.backgroundColor = .eventBoxBlack()
        self.collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        title = "EventChat"
        senderDisplayName = ""
        senderId = selfAuth.uid
        automaticallyScrollsToMostRecentMessage = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        bubbleFunc()
        
 
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func bubbleFunc() {
        
        let factory = JSQMessagesBubbleImageFactory()
        
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor.eventBoxAccent())
        
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
    }
    
    
    func addMessage(userUID: String, text: String) {
        
            let newMessage = JSQMessage(senderId: userUID, displayName: "", text: text)
            self.messages.append(newMessage)
        
        if userUID == senderId {
            self.finishSendingMessageAnimated(true)
        } else {
            self.finishReceivingMessageAnimated(true)
        }
  
    }
    
    //MARK: - Chat Delegate
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
        messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
            return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.row]
        
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
            
            let message = messages[indexPath.item]
            
            if message.senderId == senderId {
                cell.textView!.textColor = UIColor.whiteColor()
            } else {
                cell.textView!.textColor = UIColor.blackColor()
            }
            
            return cell
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    
        
        //self.addMessage(senderId, text: text)
        NetworkManager.sharedManager.addMessage(message: text,
            messageSent: { (message) -> Void in
                
            },
            messageFailedToSend: { ()
                
        })
    }
 
    func keyboardWillHide(notification: NSNotification) {
        self.inputToolbar?.hidden = true
    }
    
    func extraRightItemDidPress() {
        
        self.inputToolbar?.hidden = false
        self.inputToolbar?.contentView?.textView?.becomeFirstResponder()
        
    }
    
    
    //MARK: - Firebase temp
    func tempFirebase() {
        let ref = Firebase(url: "https://eventbox.firebaseio.com/events/\(NetworkManager.sharedManager.selectedEvent!.eventUID)/messages")
        
        ref.queryLimitedToLast(25).observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
            
            let id = snapshot.value["userUID"] as! String
            let text = snapshot.value["message"] as! String
        
            self.addMessage(id, text: text)
            
        }
    }
}
