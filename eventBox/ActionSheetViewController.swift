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
    
}

class ActionSheetViewController: UIViewController {

    
    @IBOutlet weak var joinView: UIView!
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var cancelView: UIView!
   
    
    var joinDestination: CGRect!
    var createDestination: CGRect!
    var cancelDestination: CGRect!
    
    var delegate: ActionSheetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        joinView.backgroundColor   = UIColor.eventBoxAccent()
        createView.backgroundColor = UIColor.eventBoxAccent()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        joinDestination   = joinView.frame
        createDestination = createView.frame
        cancelDestination = cancelView.frame
        
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        joinView.frame.origin.y   = screenHeight
        createView.frame.origin.y = screenHeight
        cancelView.frame.origin.y = screenHeight
        

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
        
    }
    
    
    @IBAction func onCancelTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func onCreateTapped(sender: AnyObject) {
        self.delegate?.didSelectCreate()
        dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

    
    
    
}
