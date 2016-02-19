//
//  CalendarViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/17/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit
import Calendar_iOS

protocol CalendarViewControllerDelegate {
    
    func calendarViewControllerDidDismiss()
    func calendarViewControllerDidSelectDate(date: NSDate)
}

class CalendarViewController: UIViewController, CalendarViewDelegate {

    @IBOutlet weak var calendarView: CalendarView!
    
    var delegate: CalendarViewControllerDelegate?
    
    private var date = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.shouldShowHeaders = true
        calendarView.selectionColor  = UIColor.eventBoxGreen()
        calendarView.fontHeaderColor = UIColor.eventBoxGreen()
        calendarView.calendarDelegate = self
        calendarView.fontColor = UIColor.whiteColor()
        calendarView.bgColor = UIColor.eventBoxBlack()
        calendarView.refresh()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        calendarView.setNeedsDisplay()
    }
    
    func didChangeCalendarDate(date: NSDate!) {
        self.date = NSDate(timeInterval: 43200, sinceDate: date)
        print(date)
    }
    
    @IBAction func onCheckTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.calendarViewControllerDidSelectDate(date)
        delegate?.calendarViewControllerDidDismiss()
    }

    @IBAction func onCancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.calendarViewControllerDidDismiss()
    }
    

}
