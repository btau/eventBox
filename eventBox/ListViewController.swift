//
//  ListViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/18/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var itemTextField: UITextField!
    var currentEvent: Event = NetworkManager.sharedManager.selectedEvent!
    var currentUser: User?
    var itemUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "eventUpdate", object: nil)
        
        configureTextField()
        
        let userUID:String = NetworkManager.sharedManager.authData!.uid
        NetworkManager.sharedManager.getUserForUID(userUID, didGetUser: { (user) -> Void in
            self.currentUser = user
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentEvent.items.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListItemCell") as! ListViewCell
        
        cell.userImageView.backgroundColor = UIColor.eventBoxAccent()
        cell.userImageView.borderColor = UIColor.eventBoxAccent()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
        cell.itemLabel.text = currentEvent.items[indexPath.row].item
        
        if currentEvent.items[indexPath.row].userUID == "" {
            cell.userNameLabel.text = ""
            cell.userImageView.image = UIImage(named: "noun_happy_49834")
        }
        else if currentEvent.items[indexPath.row].userUID != "" {
            NetworkManager.sharedManager.getUserForUID(currentEvent.items[indexPath.row].userUID, didGetUser: { (user) -> Void in
                self.itemUser = user
                cell.userNameLabel.text = self.itemUser?.userName
                
                self.createImage((self.itemUser?.image)!, didCreateImage: { (userImage) -> Void in
                    cell.userImageView.image = userImage
                })
            })
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ListViewCell
        
        if cell.userNameLabel.text == "" {
            NetworkManager.sharedManager.selectItem(eventUID: currentEvent.eventUID, itemUID: (currentEvent.items[indexPath.row].itemUID), userUID: (currentUser?.UID)!)
            cell.userNameLabel.text = currentUser!.userName
            createImage((currentUser?.image)!, didCreateImage: { (userImage) -> Void in
                cell.userImageView.image = userImage
            })
        }
        else if cell.userNameLabel.text == currentUser?.userName {
            NetworkManager.sharedManager.unselectItem(eventUID: currentEvent.eventUID, itemUID: currentEvent.items[indexPath.row].itemUID)
            cell.userNameLabel.text = ""
            cell.userImageView.image = UIImage(named: "noun_happy_49834")
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return itemTextField.resignFirstResponder()
    }
    
    
    func createImage(userImageString: String, didCreateImage: (userImage: UIImage) -> Void) {
        let url = NSURL(string: userImageString)
        let data = NSData(contentsOfURL: url!)
        let userImage = UIImage(data: data!)
        
        didCreateImage(userImage: userImage!)
    }
    
    func configureTextField() {
        let addItemButton = UIButton()
        addItemButton.frame = CGRectMake(0, 5, 30, 30)
        addItemButton.layer.cornerRadius = 15
        addItemButton.backgroundColor = UIColor.eventBoxAccent()
        addItemButton.setTitleColor(UIColor.eventBoxBlack(), forState: .Normal)
        addItemButton.setTitle("+", forState: .Normal)
        addItemButton.addTarget(self, action: Selector("onAddItemTapped"), forControlEvents: .TouchUpInside)
        
        itemTextField.layer.cornerRadius = 15
        itemTextField.rightView = addItemButton
        itemTextField.rightViewMode = UITextFieldViewMode.Always
    }
    
    
    func reloadData() {
        currentEvent = NetworkManager.sharedManager.selectedEvent!
        listTableView.reloadData()
    }

    
    func onAddItemTapped() {
        if itemTextField.text != "" {
            NetworkManager.sharedManager.addItem(item: itemTextField.text!, eventUID: currentEvent.eventUID)
            itemTextField.text = ""
            itemTextField.resignFirstResponder()
            reloadData()
        }
    }

}
