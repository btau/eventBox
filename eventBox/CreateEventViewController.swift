//
//  CreateEventViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/17/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit
import Calendar_iOS

class CreateEventViewController: UIViewController, UITextFieldDelegate, CalendarViewControllerDelegate, TimeViewControllerDelegate {
    
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDateTextField: UITextField!
    @IBOutlet weak var eventTimeTextField: UITextField!
    
    var textFields: [UITextField]!
    
    let animationSpeed = 0.25
    
    var tintView: UIView?
    
    var cancel = true
    
    var animator: UIDynamicAnimator?
    var snap: UISnapBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [eventNameTextField,eventDateTextField,eventTimeTextField]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        clearTextfields(Except: textField)
        
        UIView.animateWithDuration(animationSpeed) { () -> Void in
            textField.backgroundColor = .whiteColor()
        }
        
        
        textField.borderWidth = 3
        let width:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        width.fromValue = 0
        width.toValue = 3
        width.duration = animationSpeed
        width.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        textField.layer.addAnimation(width, forKey: "borderWidth")
        
        switch textField.tag {
        case 1:
            return true
        case 2:
            performSegueWithIdentifier("CalendarPop", sender: nil)
        case 3:
            performSegueWithIdentifier("TimePop", sender: nil)
        default:
            return false
        }
        return false

    }
    
    func clearTextfields(Except selectedTextfield: UITextField?) {
        
        for textField in textFields {
            guard textField.tag != selectedTextfield?.tag else {
                continue
            }
            
            textField.resignFirstResponder()
            
            let color = UIColor(red: 240/255, green: 249/255, blue: 255/255, alpha: 1.0)
            UIView.animateWithDuration(animationSpeed) { () -> Void in
                textField.backgroundColor = color
            }
            
            let currentWidth = textField.borderWidth
            textField.borderWidth = 0
            let width:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
            width.fromValue = currentWidth
            width.toValue = 0
            width.duration = animationSpeed
            width.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            textField.layer.addAnimation(width, forKey: "borderWidth")
            
        }
    }
    
    //MARK: - CalenderView -
    
    func calendarViewControllerDidDismiss() {
        dismissTintView()
    }
    
    func calendarViewControllerDidSelectDate(date: NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        formatter.timeStyle = .NoStyle
        
        eventDateTextField.text = formatter.stringFromDate(date)
    }
    
    func timeViewControllerDidDismiss() {
        dismissTintView()
    }
    
    func timeViewControllerDidSelectTime(time: NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        
        eventTimeTextField.text = formatter.stringFromDate(time)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CalendarPop" {
            
            let calVC = segue.destinationViewController as! CalendarViewController
            
            calVC.delegate = self
            
            tintView = UIView(frame: (UIApplication.sharedApplication().keyWindow?.bounds)!)
            tintView!.alpha = 0
            tintView!.backgroundColor = .blackColor()
            self.view.insertSubview(tintView!, atIndex: self.view.subviews.count)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tintView!.alpha = 0.5
            })
            
            
        } else if segue.identifier == "TimePop" {
            
            let timeVC = segue.destinationViewController as! TimeViewController
            
            timeVC.delegate = self
            
            tintView = UIView(frame: (UIApplication.sharedApplication().keyWindow?.bounds)!)
            tintView!.alpha = 0
            tintView!.backgroundColor = .blackColor()
            self.view.insertSubview(tintView!, atIndex: self.view.subviews.count)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tintView!.alpha = 0.5
            })
            
            
        } else if segue.identifier == "addEventUnwind" {
            
            let unwindSegue = segue as! NewEventUnwind
            
            animator = UIDynamicAnimator(referenceView: segue.destinationViewController.view)
            snap = UISnapBehavior(item: segue.sourceViewController.view, snapToPoint: CGPointMake(0, 0))
            
            unwindSegue.animator = animator!
            unwindSegue.snap = snap!
            unwindSegue.cancel = cancel
            
           
            
          //  let time = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "dismiss", userInfo: nil, repeats: false)
        }
    }
    
        func dismiss() {
            dismissViewControllerAnimated(false, completion: nil)
            print("dealloc")
        }
    
    func dismissTintView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.tintView!.alpha = 0
            }) { (bool:Bool) -> Void in
                self.tintView?.removeFromSuperview()
        }
        
        clearTextfields(Except: nil)
    }
    
    
    @IBAction func onCreateTapped(sender: UIButton) {
        
        
        
    }
    
    
    
    
}
