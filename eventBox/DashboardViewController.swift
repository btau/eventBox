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
    
    @IBOutlet weak var collectionView: UICollectionView!
    var events: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.sharedManager.getUserEvents(
            Success: { (events) -> Void in
                self.events = events
                self.collectionView.reloadData()
            },
            Failed: { () -> Void in
                
        })
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)

    }

    
    //MARK: - ColectionView
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventCell", forIndexPath: indexPath)
        
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let eventCount = events?.count {
            collectionView.hidden = false
            return eventCount
        }
        collectionView.hidden = true
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
    
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "addEventUnwind" {
                let unwindSegue = NewEventUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)!
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
        
    }

}
