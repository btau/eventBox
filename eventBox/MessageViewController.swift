//
//  MessageViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/18/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit
import FoldingTabBar

class MessageViewController: UIViewController, YALTabBarInteracting, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let yourCell = tableView.dequeueReusableCellWithIdentifier("LocalMessage")!
        let remoteCell = tableView.dequeueReusableCellWithIdentifier("RemoteMessage")!
        
        if indexPath.row % 2 == 0 {
            
            return yourCell
            
        } else {
            return remoteCell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    

    func tabBarViewWillExpand() {
        print("Will Expand")
    }
    
    func tabBarViewWillCollapse() {
        
    }

}
