//
//  EventLandingDetailsTableViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/23/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class EventLandingDetailsTableViewController: UITableViewController {

    
    @IBOutlet weak var headerSpace: UITableViewCell!
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDataLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventTokenLabel: UILabel!
    @IBOutlet weak var eventGuestsLabel: UILabel!
    @IBOutlet weak var itemsNeededLabel: UILabel!
    @IBOutlet weak var attendButton: UIButton!
    
    let event = NetworkManager.sharedManager.selectedEvent!
    let currentUser = NetworkManager.sharedManager.authData?.uid
    var isAttending: Bool?
    var itemCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for item in event.items {
            if item.userUID == "" {
                self.itemCount++
            }
        }
        
        print("Count: \(itemCount)")
        
        if itemCount == 0 {
            itemsNeededLabel.text = "No items needed"

        } else if  itemCount == 1 {
            itemsNeededLabel.text = "\(itemCount) item needed"
        } else  {
            itemsNeededLabel.text = "\(itemCount) items needed"

        }
        
        
        
        eventNameLabel.text = event.eventName
        
        let date = NSDate(timeIntervalSince1970: event.startDate)
        let formatter = NSDateFormatter()
            formatter.dateStyle = .FullStyle
            formatter.timeStyle = .NoStyle
        
        eventDataLabel.text = formatter.stringFromDate(date)
        
            formatter.dateStyle = .NoStyle
            formatter.timeStyle = .ShortStyle
        
        eventTimeLabel.text = formatter.stringFromDate(date)
        
        eventTokenLabel.text = "Token: " + event.eventUID
        
        eventGuestsLabel.text = "\(event.guests.count) Guests"
    }
    
    override func viewWillAppear(animated: Bool) {
        if event.guests.contains(currentUser!) {
            configureUnattendButton()
            isAttending = true
        }
        else {
            attendButton.setTitle("Attend", forState: .Normal)
            attendButton.tintColor = UIColor.eventBoxBlack()
            attendButton.backgroundColor = UIColor.eventBoxAccent()
            isAttending = false
        }
        
//        for guest in event.guests {
//            if guest == currentUser! {
//                attendButton.setTitle("Attend", forState: .Normal)
//                attendButton.tintColor = UIColor.eventBoxBlack()
//                attendButton.backgroundColor = UIColor.eventBoxAccent()
//                isAttending = true
//            }
//            else if guest != currentUser! {
//                configureUnattendButton()
//                isAttending = false
//            }
//        }
    }


    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return UIScreen.mainScreen().bounds.height - 300
            
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    @IBAction func onCopyTokenTapped(sender: UIButton) {
        
        UIPasteboard.generalPasteboard().string = event.eventUID
        
    }

    @IBAction func onUnattendTapped(sender: UIButton) {
        if isAttending == true {
            NetworkManager.sharedManager.unattendEvent(currentUser!, eventUID: event.eventUID)
            attendButton.setTitle("Attend", forState: .Normal)
            attendButton.tintColor = UIColor.eventBoxBlack()
            attendButton.backgroundColor = UIColor.eventBoxAccent()
            isAttending = false
        } else if isAttending == false {
            NetworkManager.sharedManager.attendEvent(event.eventUID, done: { () -> Void in
                
            })
            configureUnattendButton()
            isAttending = true
        }
        

        
        
    }
    
    func configureUnattendButton() {
        attendButton.backgroundColor = UIColor.redColor()
        attendButton.tintColor = UIColor.whiteColor()
        attendButton.setTitle("Unattend", forState: .Normal)
        
    }

}
