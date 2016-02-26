//
//  EventCollectionViewCell.swift
//  eventBox
//
//  Created by Michael Berger on 2/22/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var bigCountdownLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var cellView: UIView!
    
    var event: Event!
    
    func configureWithEvent(event: Event) {
        
        self.event = event
        
        eventImageView.image = UIImage(named: event.imageName)
        
        eventNameLabel.text = event.eventName
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        formatter.timeStyle = .ShortStyle
        
        
        let date = NSDate(timeIntervalSince1970: event.startDate)
        
        let dateString = formatter.stringFromDate(date).stringByReplacingOccurrencesOfString(" at ", withString: "\n")
        
        eventDateLabel.text = dateString
        
        NetworkManager.sharedManager.getUserForUID(event.hostUID) { (user) -> Void in
            self.hostNameLabel.text = user.userName
        }
        
        countdownTime()
        
    }
    
    func countdownTime() {
        
        let dayCalenderUnit: NSCalendarUnit = [.Day]
        let today = NSDate()                   // Todays date
        let calendar = NSCalendar.currentCalendar()
        
        // Getting the startDate double and converting to NSDate
        let eventDate = NSDate(timeIntervalSince1970: event.startDate)
        
        
        // Getting days until event date
        let daysUntilStartDate = calendar.components(dayCalenderUnit, fromDate: today, toDate: eventDate, options: [])
        
        // Getting hours until event date
        let hoursUntilStartDate = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: today, toDate: eventDate, options: [])
        
        // Comparing the two dates in units of Days and returning a NSComparisonResult
        let compareDatesByDays = calendar.compareDate(today, toDate: eventDate, toUnitGranularity: dayCalenderUnit)
        
        
        // Logic
        if compareDatesByDays == NSComparisonResult.OrderedSame {
            bigCountdownLabel.text = "Today"
        } else if compareDatesByDays == NSComparisonResult.OrderedAscending {
            if hoursUntilStartDate.hour < 24 {
                bigCountdownLabel.text = "Tomorrow"
            } else {
                bigCountdownLabel.text = "\(String(daysUntilStartDate.day)) Days Until Event"
            }
        } else {
            bigCountdownLabel.text = "Event Over"
        }
        
    }

    
    
    
}
