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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        detailController = segue.destinationViewController as! YALFoldingTabBarController
        
     //   detailController.delegate = self
       // detailController.tabBarView.delegate = self
        
        detailController.tabBarViewHeight                     = YALTabBarViewDefaultHeight
        detailController.tabBarView.tabBarViewEdgeInsets      = YALTabBarViewHDefaultEdgeInsets
        detailController.tabBarView.tabBarItemsEdgeInsets     = YALTabBarViewItemsDefaultEdgeInsets
        detailController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        detailController.tabBarView.extraTabBarItemHeight     = YALExtraTabBarItemsDefaultHeight

        detailController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;

      //  let menu = YALTabBarItem(itemImage: UIImage(named: "noun_menu_198777"), leftItemImage: nil, rightItemImage: nil)
        
        detailController.centerButtonImage = UIImage(named: "PlusButton")
        
        let message = YALTabBarItem(itemImage:  UIImage(named: "noun_message_323222"), leftItemImage: nil, rightItemImage: UIImage(named: "noun_comment_118635"))
        
        let location = YALTabBarItem(itemImage: UIImage(named: "noun_location-pin_281085"), leftItemImage:nil, rightItemImage: nil)

        
        
        let admin = YALTabBarItem(itemImage: UIImage(named: "Gear"), leftItemImage: nil, rightItemImage: nil)
        
        let things = YALTabBarItem(itemImage: UIImage(named: "List"), leftItemImage: nil, rightItemImage: nil)
        
        detailController.leftBarItems = [things, location]
        detailController.rightBarItems = [message, admin]
        
        detailController.tabBarView.tintColor = .eventBoxGreen()
        detailController.tabBarView.tabBarColor = .clearColor()
        detailController.tabBarView.dotColor = .eventBoxGreen()
    }

    
    
    
    

}
