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
    
    let event = NetworkManager.sharedManager.selectedEvent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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


    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return UIScreen.mainScreen().bounds.height - 300
            
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    @IBAction func onCopyTokenTapped(sender: UIButton) {
        
        UIPasteboard.generalPasteboard().string = event.eventUID
        
    }


}
