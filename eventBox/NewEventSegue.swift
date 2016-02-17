//
//  NewEventSegue.swift
//  eventBox
//
//  Created by Michael Berger on 2/16/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class NewEventSegue: UIStoryboardSegue {
    
    var collision: UICollisionBehavior?
    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior?
    
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        
        source.addChildViewController(destination)
        destination.didMoveToParentViewController(source)
        
        let screenWidth  = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        destination.view.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight)
        destination.view.alpha = 0
        source.view.addSubview(destination.view)
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            destination.view.alpha = 1
            }) { (bool:Bool) -> Void in
                
        }
        
        print("init")
        
    }
    
    override func perform() {
        

        
        
//        animator!.removeAllBehaviors()
//        
//        gravity!.addItem(destinationVC)
//        gravity!.gravityDirection = CGVectorMake(0, -10)
//        
//        collision!.addItem(destinationVC)
//        
//        let left = CGPointMake(self.animator!.referenceView!.bounds.origin.x, self.animator!.referenceView!.bounds.origin.y)
//        
//        let right = CGPointMake(self.animator!.referenceView!.bounds.origin.x + self.animator!.referenceView!.bounds.size.width, self.animator!.referenceView!.bounds.origin.y);
//
//        collision!.addBoundaryWithIdentifier("top", fromPoint: left, toPoint: right)
//
//        animator!.addBehavior(collision!)
//        animator!.addBehavior(gravity!)
        
    }
    
    
    
}
