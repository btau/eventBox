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
    
    @IBOutlet weak var newEventButton: UIButton!
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    var cvFrame: CGRect!
    var events: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.sharedManager.getUserEvents(
            Success: { (events) -> Void in
                self.events = events
                self.setupCollectionView()
                
            },
            Failed: { () -> Void in
                
        })
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = self.eventsCollectionView.contentInset
        let value = (self.view.frame.size.width - (self.eventsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        insets.left = value
        insets.right = value
        self.eventsCollectionView.contentInset = insets
        self.eventsCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
    }
    
    
    //MARK: - ColectionView
    
    
    
    func setupCollectionView() {
        
        let flowLayout = CenterCellCollectionViewFlowLayout()
        let screenBounds = UIScreen.mainScreen().bounds
        let refresh = UIRefreshControl()
        
        flowLayout.itemSize = CGSizeMake(screenBounds.width - 50, eventsCollectionView.frame.height)
        flowLayout.minimumLineSpacing = -10
        flowLayout.scrollDirection = .Horizontal
        
        refresh.addTarget(self, action: "startRefresh", forControlEvents: UIControlEvents.ValueChanged)
       // eventsCollectionView.addSubview(refresh)
       // refresh.bounds.offsetInPlace(dx: -20, dy: 0)
        
        eventsCollectionView.collectionViewLayout = flowLayout
        
        cvFrame = eventsCollectionView.frame
        eventsCollectionView.frame = CGRect(x: cvFrame.origin.x, y: cvFrame.origin.y + UIScreen.mainScreen().bounds.height, width: cvFrame.width, height: cvFrame.height)
        
        eventsCollectionView.reloadData()
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: {

            self.eventsCollectionView.frame = self.cvFrame
            
            }, completion: {
                //Code to run after animating
                (value: Bool) in
        })
        
    }

    
    
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
    
    func startRefresh() {
        
    }
    
    
    func setColors() {
        newEventButton.tintColor = UIColor.eventBoxAccent()
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
