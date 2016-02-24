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

    let CVA_DURATION: Double  = 0.5
    let CVA_DELAY:    Double  = 0.0
    let CVA_DAMPING:  CGFloat = 0.75
    let CVA_VELOCITY: CGFloat = 0.5
    
    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()

        newEventButton.tintColor = UIColor.eventBoxAccent()
        
        NetworkManager.sharedManager.getUserEvents(
            Success: { (events) -> Void in
                self.events = events
                
                self.events?.sortInPlace({ NSDate(timeIntervalSince1970: $0.0.startDate).compare(NSDate(timeIntervalSince1970: $0.1.startDate )) == .OrderedAscending })

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
        popDownCell()
        
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
        
        
        eventsCollectionView.frame = CGRect(x: 0.0, y: 80, width: eventsCollectionView.frame.width, height: screenBounds.height - (80 + 78))
        cvFrame = eventsCollectionView.frame

        
        flowLayout.itemSize = CGSizeMake(screenBounds.width - 50, eventsCollectionView.frame.height)
        flowLayout.minimumLineSpacing = -10
        flowLayout.scrollDirection = .Horizontal
        
        refresh.addTarget(self, action: "startRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        eventsCollectionView.collectionViewLayout = flowLayout
        
        eventsCollectionView.frame = CGRect(x: cvFrame.origin.x, y: cvFrame.origin.y + UIScreen.mainScreen().bounds.height, width: cvFrame.width, height: cvFrame.height)
        
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
        
        
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? EventCollectionViewCell else {
            return
        }
        
        
        NetworkManager.sharedManager.selectEvent(cell.event)
        
        popUpCell(cell)

    }
    
    //MARK - Animations
    
    var cellImageView    = UIImageView()
    var poppedCellBounds = CGRect()
    
    func popUpCell(cell: EventCollectionViewCell) {
        
        poppedCellBounds = self.view.convertRect(cell.eventImageView.bounds, fromView: cell.cellView)
        print(cell.eventImageView.bounds.origin.x)
        print(poppedCellBounds.origin.x)
        cellImageView = UIImageView(image: cell.eventImageView.image)
        cellImageView.userInteractionEnabled = true
        cellImageView.frame = self.view.convertRect(cell.eventImageView.frame, toView: self.view)
        cellImageView.contentMode = .ScaleAspectFill
        cellImageView.clipsToBounds = true
        cellImageView.center = UIApplication.sharedApplication().keyWindow!.center
        cellImageView.cornerRadius = 10
        cellImageView.alpha = 0
        
       // self.view.addSubview(cellImageView)
        self.view.insertSubview(cellImageView, belowSubview: newEventButton)
        
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            self.cellImageView.alpha = 1
            
            }) { (done) -> Void in
                
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { () -> Void in
                    
                    self.cellImageView.layer.cornerRadius = 0
                    
                    self.cellImageView.frame = CGRect(x: self.SCREEN_BOUNDS.origin.x, y: self.SCREEN_BOUNDS.origin.y, width: self.SCREEN_BOUNDS.width, height: self.SCREEN_BOUNDS.height)
                    
                    }, completion: { (done) -> Void in
                        self.performSegueWithIdentifier("enterEventSegue", sender: nil)
                })
        }
    }
    
    func popDownCell() {
        
        self.cellImageView.alpha = 1
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.cellImageView.frame = CGRect(
                x: self.poppedCellBounds.origin.x,
                y: self.poppedCellBounds.origin.y,
                width: self.poppedCellBounds.width,
                height: self.poppedCellBounds.height)
            
            self.cellImageView.layer.cornerRadius = 10
            
            }) { (done) -> Void in
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.cellImageView.alpha = 0
                    
                    }, completion: { (done) -> Void in
                            self.cellImageView.removeFromSuperview()
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
        Debug.log("return")
        //popDownCell()
    }
    
}
