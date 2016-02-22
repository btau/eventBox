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

class TimeViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
