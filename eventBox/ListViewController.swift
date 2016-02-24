//
//  ListViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/18/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var currentEvent = NetworkManager.sharedManager.selectedEvent
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListItemCell")! as! ListViewCell
        cell.itemLabel.text = currentEvent?.items[indexPath.row].item
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentEvent?.items.count)!
    }
    
    
    

}
