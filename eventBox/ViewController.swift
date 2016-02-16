//
//  ViewController.swift
//  eventBox
//
//  Created by Brett Tau on 2/15/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    let HEADER_HEIGHT: CGFloat = 115
    let CELL_HEIGHT_DEFAULT: CGFloat = 100
    let CELL_HEIGHT_SELECTED: CGFloat = 200
    
    var expandedRows = [EventCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as? EventCell
            else { return UITableViewCell() }
        
        cell.defaultHeight = CELL_HEIGHT_DEFAULT
        cell.selectedHeight = CELL_HEIGHT_SELECTED
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        expandedRows = []
        expandedRows.append(tableView.cellForRowAtIndexPath(indexPath) as! EventCell)
        tableView.beginUpdates()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        tableView.endUpdates()
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellTableViewHeader = tableView.dequeueReusableCellWithIdentifier("HeaderCell")
        
        return cellTableViewHeader
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? EventCell {
            if expandedRows.contains(cell) {
                return CELL_HEIGHT_SELECTED
            }
        }
        return CELL_HEIGHT_DEFAULT
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CELL_HEIGHT_DEFAULT
    }
    
    
}

