//
//  NewEventUnwind.swift
//  eventBox
//
//  Created by Michael Berger on 2/17/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class NewEventUnwind: UIStoryboardSegue {

    var cancel: Bool = true
    var animator: UIDynamicAnimator?
    var snap: UISnapBehavior?
    
    override func perform() {
        
        let sourceVCView      = sourceViewController.view as UIView
        let destinationVCView = destinationViewController.view as UIView

        let screenHeight = UIScreen.mainScreen().bounds.size.height
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        
        if cancel {
            //Cancel Animation
            
            snap?.damping = 0.4
            snap?.snapPoint = CGPointMake(sourceVCView.center.x, -screenHeight/1.5)
            //let push = UIPushBehavior(items: [sourceVCView], mode: UIPushBehaviorMode.Instantaneous)
            //push.setAngle(90, magnitude: 1)
            
            animator?.addBehavior(snap!)
            
            
            
        } else {
            //Create Animation
            
            
            
            
            
        }
        
        //let timer = NSTimer(fireDate: NSDate(timeIntervalSinceNow: 5), interval: 1, target: self, selector: "dismiss", userInfo: nil, repeats: false)
    }
    
}
