//
//  DashboardViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/16/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var animator: UIDynamicAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    //MARK: - ColectionView
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventCell", forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func onSegmentControlChanged(sender: SegmentedControlView, forEvent event: UIEvent) {
        switch sender.selectedIndex {
        case 0:
            print("All")
        case 1:
            print("Upcoming")
        case 2:
            print("Past")
        default:
            return
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addEventSegue" {
            
            let eventSegue       = segue as! NewEventSegue
            animator             = UIDynamicAnimator(referenceView: self.view)
            let gravity          = UIGravityBehavior()
            let collision        = UICollisionBehavior()
            eventSegue.animator  = animator
            eventSegue.gravity   = gravity
            eventSegue.collision = collision
        }
    }

}
