//
//  NewEventViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/16/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController {

    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var joinEventButton: UIButton!
    
    @IBOutlet weak var createButtonDestination: UIView!
    @IBOutlet weak var joinButtonDestination: UIView!
    
    
    var animator = UIDynamicAnimator()
    let screenBounds = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        
        hideUI()
        showCreateShow()
        
    }
    
    func hideUI() {
        createEventButton.center = CGPointMake(createEventButton.center.x, screenBounds.size.height + 200)
        joinEventButton.center = CGPointMake(joinEventButton.center.x, -screenBounds.size.height - 200)
        
        
        
    }

    
    func showCreateShow() {
        let damping: CGFloat = 0.4
        
        let snapCreate = UISnapBehavior(item: createEventButton, snapToPoint: createButtonDestination.center)
        let snapJoin = UISnapBehavior(item: joinEventButton, snapToPoint: joinButtonDestination.center)
        
        
        snapCreate.damping = damping
        snapJoin.damping   = damping
        
        animator.addBehavior(snapCreate)
        animator.addBehavior(snapJoin)
        
        
    }
    
    
    
    
    
    @IBAction func onExitTapped(sender: AnyObject) {
        //TODO: Unwind
    }
    
}
