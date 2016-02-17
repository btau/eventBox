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
        
        
        if cancel {
            //Cancel Animation
            
            
            snap?.snapPoint = CGPointMake(sourceVCView.center.x, screenHeight * 2)
            
            animator?.addBehavior(snap!)
            
            
            
        } else {
            //Create Animation
            
            
            
            
            
        }
    }
    
}
