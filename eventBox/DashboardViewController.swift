//
//  DashboardViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/16/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

enum DisplayItems {
    
    case All
    case Upcoming
    case Past
    
}

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var animator: UIDynamicAnimator?
    
    @IBOutlet weak var newEventButton: UIButton!
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    var cvFrame: CGRect!
    var events: [Event]?
    
    let CVA_DURATION: Double  = 0.8
    let CVA_DELAY: Double     = 0.0
    let CVA_DAMPING: CGFloat  = 0.5
    let CVA_VELOCITY: CGFloat = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()

        NetworkManager.sharedManager.getUserEvents(
            Success: { (events) -> Void in
                self.events = events
                self.popDropCollectionView(true)
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
        
        
        //eventsCollectionView.addSubview(refresh)
        //refresh.bounds.offsetInPlace(dx: 0, dy: -20)
        
        eventsCollectionView.collectionViewLayout = flowLayout
        
        cvFrame = eventsCollectionView.frame
        eventsCollectionView.frame = CGRect(x: cvFrame.origin.x, y: cvFrame.origin.y + UIScreen.mainScreen().bounds.height, width: cvFrame.width, height: cvFrame.height)
        
//        eventsCollectionView.reloadData()
//        UIView.animateWithDuration(CVA_DURATION, delay: CVA_DELAY, usingSpringWithDamping: CVA_DAMPING, initialSpringVelocity: CVA_VELOCITY, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//            
//            self.eventsCollectionView.frame = self.cvFrame
//            
//            }, completion: {
//                //Code to run after animating
//                (value: Bool) in
//        })
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventCell", forIndexPath: indexPath) as? EventCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureWithEvent(events![indexPath.row])
        
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let b = UIScreen.mainScreen().bounds
        
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? EventCollectionViewCell else {
            return
        }
        
        
        NetworkManager.sharedManager.selectEvent(cell.event)
        
        let cellImageView = UIImageView(image: cell.eventImageView.image)
        cellImageView.frame = cell.eventImageView.frame
        cellImageView.contentMode = .ScaleAspectFill
        cellImageView.clipsToBounds = true
        cellImageView.center = UIApplication.sharedApplication().keyWindow!.center
        cellImageView.cornerRadius = 10
        cellImageView.alpha = 0

        self.view.addSubview(cellImageView)

        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            cellImageView.alpha = 1
            
            }) { (done) -> Void in
            
            
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { () -> Void in
                    
                    cellImageView.frame = CGRect(x: b.origin.x, y: b.origin.y, width: b.width, height: b.height)
                    
                    }, completion: { (done) -> Void in
                        self.performSegueWithIdentifier("enterEventSegue", sender: nil)
                })
                
                
        }
        
        
    }

    func popDropCollectionView(drop: Bool) {
        
        UIView.animateWithDuration(CVA_DURATION, delay: CVA_DELAY, usingSpringWithDamping: CVA_DAMPING, initialSpringVelocity: CVA_VELOCITY, options: .CurveEaseInOut, animations: { () -> Void in
            
            if drop {
                
                let f = self.eventsCollectionView.frame
                self.cvFrame = f
                self.eventsCollectionView.frame = CGRect(x: f.origin.x, y: f.origin.y + UIScreen.mainScreen().bounds.height, width: f.width, height: f.height)
                
            } else {
                
                self.eventsCollectionView.frame = self.cvFrame
            }
                
            }, completion: { (done) -> Void in
                
                if drop {
                    self.eventsCollectionView.reloadData()
                    self.popDropCollectionView(false)
                }
                
        })
        
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
        
        popDropCollectionView(true)
    }
    
    
    //MARK: - Navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addEventSegue" {
            
            let eventSegue       = segue as! NewEventSegue
            animator             = UIDynamicAnimator(referenceView: self.view)
            let gravity          = UIGravityBehavior()
            let collision        = UICollisionBehavior()
            eventSegue.animator  = animator
            eventSegue.gravity   = gravity
            eventSegue.collision = collision
        } else if segue.identifier == "enterEventSegue" {
            
            let eventDetailVC = segue.destinationViewController as! EventDetailViewController
            eventDetailVC.event = NetworkManager.sharedManager.selectedEvent
            
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
