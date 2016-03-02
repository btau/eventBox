//
//  ActionSheetViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/26/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit


protocol ActionSheetDelegate {
    
    func didSelectCreate()
    func didJoinEvent(eventUID: String)
    
}

class ActionSheetViewController: UIViewController {

    
    @IBOutlet weak var joinView: UIView!
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var tokenTextField: UITextField!
   
    @IBOutlet weak var joinViewHeight: NSLayoutConstraint!
        
    var joinDestination: CGRect!
    var createDestination: CGRect!
    var cancelDestination: CGRect!
    
    var delegate: ActionSheetDelegate?
    
    var views = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinView.backgroundColor   = UIColor.eventBoxAccent()
        createView.backgroundColor = UIColor.eventBoxAccent()
        
        views = [joinView,createView,cancelView]
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for view in views {
            view.hidden = true
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        joinDestination   = joinView.frame
        createDestination = createView.frame
        cancelDestination = cancelView.frame
        
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        for view in views {
            view.frame.origin.y = screenHeight
        }

        for view in views {
            view.hidden = false
        }
        
        animate()
    }
    
    
    func animate() {
        
        UIView.animateWithDuration(0.75, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .CurveEaseInOut,
            animations: { () -> Void in
                
                self.joinView.frame = self.joinDestination
                
            }) { (done) -> Void in
                
                
        }
        
        UIView.animateWithDuration(0.75, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .CurveEaseInOut,
            animations: { () -> Void in
                
                self.createView.frame = self.createDestination
                
            }) { (done) -> Void in
                
                
        }
        
        UIView.animateWithDuration(0.75, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseInOut,
            animations: { () -> Void in
                
                self.cancelView.frame = self.cancelDestination
                
            }) { (done) -> Void in
                
                
        }
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        UIView.animateWithDuration(0.25) { () -> Void in
            
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

            
        }
        
        joinDestination   = joinView.frame
        createDestination = createView.frame
        cancelDestination = cancelView.frame
        
    }
    
    
    @IBAction func onCancelTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func onCreateTapped(sender: AnyObject) {
        self.delegate?.didSelectCreate()
        dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

    @IBAction func onJointapped(sender: AnyObject) {
        
        print(tokenTextField.frame)
        
        for view in views {
            view.layoutSubviews()
        }
        
        let SB = UIScreen.mainScreen().bounds
        
        print(tokenTextField.frame)
        //self.joinView.frame = CGRect(x: self.joinView.frame.origin.x , y: SB.height / 2 - (self.joinView.frame.height / 2), width: self.joinView.frame.width, height: 100)
        
        joinViewHeight.constant = 100
        
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .CurveEaseInOut,
            animations: { () -> Void in
                print(self.tokenTextField.frame)
                self.view.layoutIfNeeded()
                // self.joinView.frame.size.height = 100
                //self.joinView.frame = CGRect(x: self.joinView.frame.origin.x , y: SB.height / 2 - (self.joinView.frame.height / 2), width: self.joinView.frame.width, height: 100)
               // self.joinView.center = CGPoint(x: SB.width/2, y: SB.height/2)
                //  self.view.frame.origin.y = -300
                // self.joinView.bringSubviewToFront(self.tokenTextField)
                
            }) { (complete) -> Void in
                // self.joinView.frame = CGRect(x: self.joinView.frame.origin.x , y: SB.height / 2 - (self.joinView.frame.height / 2), width: self.joinView.frame.width, height: 100)
                // print(self.tokenTextField.frame)
        }
        
        
    }
    
    
    @IBAction func onPasteJoinTapped(sender: AnyObject) {
        
        let pasteboardString:String? = UIPasteboard.generalPasteboard().string
        if let theString = pasteboardString {
            tokenTextField.text = theString
            
            NetworkManager.sharedManager.attendEvent(theString, done: { () -> Void in
                self.delegate?.didJoinEvent(theString)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
           
        }
        
        
        
    }
    
    
}
