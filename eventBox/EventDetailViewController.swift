//
//  EventDetailViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/18/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit
import FoldingTabBar

class EventDetailViewController: UIViewController, YALTabBarViewDelegate {

    @IBOutlet weak var containerView: UIView!
    
    var detailController: YALFoldingTabBarController!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        MyNoSelectedViewController *myViewController = [[MyNoSelectedViewController alloc] initWithNibName:@"MyNoSelectedViewController" bundle:[NSBundle mainBundle]];

//        [self.tabBarController setSelectedViewController:nil];
//        [self.tabBarController setSelectedViewController:myViewController];

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        detailController = segue.destinationViewController as! YALFoldingTabBarController
        
//        let eventLandingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EventLandingViewController") as! EventLandingViewController
//        var array = detailController.viewControllers
//        array?.append(eventLandingVC)
//        detailController.viewControllers = array
//        detailController.selectedViewController = eventLandingVC
        
        
        detailController.tabBarViewHeight                     = YALTabBarViewDefaultHeight
        detailController.tabBarView.tabBarViewEdgeInsets      = YALTabBarViewHDefaultEdgeInsets
        detailController.tabBarView.tabBarItemsEdgeInsets     = YALTabBarViewItemsDefaultEdgeInsets
        detailController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        detailController.tabBarView.extraTabBarItemHeight     = YALExtraTabBarItemsDefaultHeight

        detailController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;

        
        detailController.centerButtonImage = UIImage(named: "PlusButton")
        
        let message = YALTabBarItem(itemImage:  UIImage(named: "noun_message_323222"), leftItemImage: UIImage(named: "noun_delete_45887"), rightItemImage: UIImage(named: "noun_comment_118635"))
        
        let location = YALTabBarItem(itemImage: UIImage(named: "noun_location-pin_281085"), leftItemImage:UIImage(named: "noun_delete_45887"), rightItemImage: nil)

        
        
        let landing = YALTabBarItem(itemImage: UIImage(named: "noun_newspaper_158465"), leftItemImage: nil, rightItemImage: nil)
        
        let things = YALTabBarItem(itemImage: UIImage(named: "List"), leftItemImage: UIImage(named: "noun_delete_45887"), rightItemImage: nil)
        
        detailController.leftBarItems = [landing, things]
        detailController.rightBarItems = [location, message]
        

        
        detailController.tabBarView.tintColor = .eventBoxAccent()
        detailController.tabBarView.tabBarColor = .eventBoxBlack()
        detailController.tabBarView.dotColor = .eventBoxAccent()
    }

    
    
    
    

}
