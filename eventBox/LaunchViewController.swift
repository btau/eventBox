//
//  LaunchViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/20/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NetworkManager.sharedManager.authData == nil {
            //Not logged in
            
            self.performSegueWithIdentifier("NoUserSegue", sender: nil)
            return
        }
        //Is logged in
        
        NetworkManager.sharedManager.getUserForUID(nil) { (user) -> Void in
            self.performSegueWithIdentifier("LoggedInSegue", sender: nil)
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    
    
}
