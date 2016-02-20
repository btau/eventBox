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

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textEntryView: UIVisualEffectView!
    
    var messagesArray = ["Test!","Awesome!!!!! YAY, WOO, ALRIGHT! LET'S GO!!","This is a longer test Message!","This app is amaizing! I'm telling alllllllllllll my friends!","Me too!","I am running out of things to say","Yeah same here.... hmmm","The design def needs to be better, I don't like it!","Yeah it could use some work","But function is what we are after!","Yeah! wait.. we?? I am talking to myself","oh boy","jeghaejhgjadbg","fhjad sgkjah gj hgj ajsgjesh gklja","gnajs gbakj bgkjaewbg","ghae sghieaw gewh gjew gjaw b","haej guiewa gewa hgiawh","gb jskgjawe gharwb hgb arw","ghrsaj gbra giarw bg","gas ","gsjg iarwgi awh","dg iurashgiur hgia r",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 200
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.setContentOffset(CGPoint(x: 0.0, y: tableView.contentSize.height), animated: false)
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: messagesArray.count-1, inSection: 0), atScrollPosition: .Top, animated: false)
       // tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(indexPath.row)
        guard indexPath.row != tableView.numberOfRowsInSection(indexPath.section) - 1 else {
            
            let blankCell = UITableViewCell(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: 180))
            blankCell.backgroundColor = .eventBoxBlack()
            return blankCell
            
        }
        
        guard indexPath.row != 0 else {
            
            let blankCell = UITableViewCell(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: 64))
            blankCell.backgroundColor = .eventBoxBlack()
            return blankCell
            
        }
        
        var cell: MessageTableViewCell!
        
        
        
        if indexPath.row % 2 == 0 {
            
            cell = tableView.dequeueReusableCellWithIdentifier("LocalMessage")! as! MessageTableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("RemoteMessage")! as! MessageTableViewCell
            
        }
        
        cell.textView.text = messagesArray[indexPath.row - 1]
        
        
        cell.textView.textContainer.lineBreakMode = .ByWordWrapping;
        cell.textView.sizeToFit()

        
        return cell
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        guard indexPath.row != messagesArray.count else {
            return 180
        }
        
        guard indexPath.row != 0 else {

            return 64
            
        }
        
       
        return 50
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count + 2
    }
    
    func tabBarViewWillExpand() {
        print("Will Expand")
    }
    
    func tabBarViewWillCollapse() {
        
    }
    
    func extraRightItemDidPress() {
        displayKeyboard()
    }
    
    func displayKeyboard() {
        textEntryView.hidden = false
        textField.becomeFirstResponder()
        let window: UIWindow = UIApplication.sharedApplication().windows.last!
        window.addSubview(textEntryView)
    }

}
