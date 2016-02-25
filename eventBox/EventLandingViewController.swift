//
//  EventLandingViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/22/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

protocol dismissEventDelegate {
    
}

class EventLandingViewController: UIViewController {

    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var tableViewContainer: UIView!
    var event: Event!
    
    @IBOutlet weak var shadowView: UIImageView!
    @IBOutlet weak var numberOfTimeLabel: UILabel!
    @IBOutlet weak var timeAmountLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countdownTime()

        
        
        reloadData()
        
        addMotion()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "eventUpdate", object: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let screenBounds = UIScreen.mainScreen().bounds
        
        let tableFrameDest        = tableViewContainer.frame
        let timeAmountFrameDest   = timeAmountLabel.frame
        let closeButtonFrameDes   = closeButton.frame
        let numberOfTimeFrameDest = numberOfTimeLabel.frame
        
        
        tableViewContainer.frame.origin.y = screenBounds.height
     //   shadowView.frame.origin.y         = -shadowView.frame.height
        shadowView.alpha = 0
        timeAmountLabel.frame.origin.y    = -timeAmountLabel.frame.height
        numberOfTimeLabel.frame.origin.y  = -numberOfTimeLabel.frame.origin.y
        closeButton.frame.origin.x        = -closeButton.frame.width
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.shadowView.alpha = 1
        }
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .CurveEaseOut,
            animations: { () -> Void in
                
                self.tableViewContainer.frame = tableFrameDest
                self.timeAmountLabel.frame    = timeAmountFrameDest
                self.numberOfTimeLabel.frame  = numberOfTimeFrameDest
                self.closeButton.frame        = closeButtonFrameDes
                
            }, completion: { (done) -> Void in
                
                
                
        })
        
        
        
    }

    func reloadData() {
            Debug.log("Reloaded")
            self.event = NetworkManager.sharedManager.selectedEvent
            self.eventImageView.image = UIImage(named:  self.event.imageName)
    }
    
    
    
    func addMotion() {
        
        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
            type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -20
        verticalMotionEffect.maximumRelativeValue = 20
        
        // Set horizontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
            type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -20
        horizontalMotionEffect.maximumRelativeValue = 20
        
        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        // Add both effects to your view
        tableViewContainer.addMotionEffect(group)
        
    }

    @IBAction func onExitTapped(sender: AnyObject) {
    }
    
    func countdownTime() {
        let dayCalenderUnit: NSCalendarUnit = [.Day]
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let eventDate = NSDate(timeInterval: event.startDate, sinceDate: today)
        
        let dayUntilStartDate = calendar.components(dayCalenderUnit, fromDate: today, toDate: eventDate, options: [])
        
        print("\(dayUntilStartDate.day) days until start date!" )
        
        
    }


}
