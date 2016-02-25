//
//  TimeViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/20/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

protocol TimeViewControllerDelegate {
    
    func timeViewControllerDidDismiss()
    func timeViewControllerDidSelectTime(time: NSDate)
}

class TimeViewController: UIViewController, UIPickerViewDelegate {

    @IBOutlet weak var timePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        timePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
    }

    var delegate: TimeViewControllerDelegate?
    
    @IBAction func onCancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.timeViewControllerDidDismiss()
    }
    @IBAction func onAcceptCheck(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.timeViewControllerDidDismiss()
        delegate?.timeViewControllerDidSelectTime(timePicker.date)
    }

   
    
}
