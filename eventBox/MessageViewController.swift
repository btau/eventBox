//
//  MessageViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/18/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit
import FoldingTabBar

class MessageViewController: UIViewController, YALTabBarInteracting, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textEntryView: UIVisualEffectView!
    
    var event: Event = NetworkManager.sharedManager.selectedEvent!
    
    var messagesArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
        self.view.backgroundColor = .eventBoxBlack()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "eventUpdate", object: nil)
        
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.setContentOffset(CGPoint(x: 0.0, y: tableView.contentSize.height), animated: false)
        //tableView.reloadData()
        //tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 23, inSection: 0), atScrollPosition: .Bottom, animated: true)
        
       tableView.transform = CGAffineTransformMakeScale(1, -1)
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       // tableView.reloadData()
        
        messagesArray = []
        
        for message in event.messages {
            
            messagesArray.append(message)
            
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: messagesArray.count-1, inSection: 0)], withRowAnimation: .Automatic)
            tableView.endUpdates()
            
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(indexPath.row)
        guard indexPath.row != tableView.numberOfRowsInSection(indexPath.section) - 1 else {
            
            let blankCell = UITableViewCell(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: 180))
            blankCell.backgroundColor = .eventBoxBlack()
            return blankCell
            
        }
        
        guard indexPath.row != 0 else {
            
            let blankCell = UITableViewCell(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: 64))
            blankCell.backgroundColor = .eventBoxBlack()
            return blankCell
            
        }
        
        var cell: MessageTableViewCell!
        
        if indexPath.row % 2 == 0 {
            
            cell = tableView.dequeueReusableCellWithIdentifier("LocalMessage")! as! MessageTableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("RemoteMessage")! as! MessageTableViewCell
            
        }
        
        let message: Message = messagesArray[indexPath.row - 1]
        
        cell.textView.text = message.message
        cell.textView.textContainer.lineBreakMode = .ByWordWrapping;
        cell.textView.sizeToFit()
        cell.backgroundColor = .eventBoxBlack()
        cell.transform = CGAffineTransformMakeScale(1, -1)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        guard indexPath.row != event.messages.count else {
            return 180
        }
        
        guard indexPath.row != 0 else {

            return 64
            
        }
        
       
        return 50
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return event.messages.count + 2
       return messagesArray.count + 2
    }
    
    func tabBarViewWillExpand() {
        print("Will Expand")
    }
    
    func tabBarViewWillCollapse() {
        
    }
    
    func extraRightItemDidPress() {

        //displayKeyboard()
    }
    
    func displayKeyboard() {
        textEntryView.hidden = false
        textField.becomeFirstResponder()
        let window: UIWindow = UIApplication.sharedApplication().windows.last!
        window.addSubview(textEntryView)
    }
    
    
    func reloadData() {
        event = NetworkManager.sharedManager.selectedEvent!
        print(event.messages.first!.time)
        if messagesArray.first?.messageUID != event.messages.first?.messageUID {
         //   messagesArray.insert(event.messages.last!, atIndex: 0)
            messagesArray.append(event.messages.last!)
            
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }

        
        
        //tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: messagesArray.count-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    

}
