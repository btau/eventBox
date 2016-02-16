//
//  NewEventSegue.swift
//  eventBox
//
//  Created by Michael Berger on 2/16/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class NewEventSegue: UIStoryboardSegue {

    var animator:UIDynamicAnimator? = nil
    
    override func perform() {
        
        let sourceVC      = self.sourceViewController.view
        let destinationVC = self.destinationViewController.view

        let screenWidth   = UIScreen.mainScreen().bounds.width
        let screenHeight  = UIScreen.mainScreen().bounds.height
        
        destinationVC.frame = CGRectMake(0.0, screenHeight, screenWidth, screenHeight)
        
        let window = UIApplication.sharedApplication().keyWindow
        //window?.insertSubview(destinationVC, aboveSubview: sourceVC)
        
        let viewDrop: UIView = destinationVC.snapshotViewAfterScreenUpdates(true)
        
        viewDrop.frame = CGRectMake(0.0, screenHeight/2, screenWidth, screenHeight)
        
        sourceVC.addSubview(viewDrop)
        
        animator = UIDynamicAnimator(referenceView: self.sourceViewController.view)
       
        let gravity = UIGravityBehavior()
        
        gravity.addItem(viewDrop)
        gravity.gravityDirection = CGVectorMake(0, -1)
        
        animator!.addBehavior(gravity)
        
        
        
    }
    
 
    
}
