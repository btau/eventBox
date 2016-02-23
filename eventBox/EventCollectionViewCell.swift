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
    
    func configureWithEvent(event: Event) {
        
        eventImageView.image = UIImage(named: event.imageName)
        
        eventNameLabel.text = event.eventName
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        formatter.timeStyle = .ShortStyle
        
        
        let date = NSDate(timeIntervalSince1970: event.startDate)
        eventDateLabel.text = formatter.stringFromDate(date)
        
        NetworkManager.sharedManager.getUserForUID(event.hostUID) { (user) -> Void in
            self.hostNameLabel.text = user.userName
        }
        
        
        
    }
    
}
