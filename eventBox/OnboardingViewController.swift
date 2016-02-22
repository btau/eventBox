//
//  OnboardingViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/20/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginTapped(sender: UIButton) {
        
        let network = NetworkManager.sharedManager
        
        network.loginWithFB(
            DidLogInUser: { () -> Void in
                NetworkManager.sharedManager.getUserForUID(nil) { (user) -> Void in
                self.performSegueWithIdentifier("LoggedInSegue", sender: nil)
                    }
                
            },
            DidFailToLogInUser: { (error) -> Void in
                
                print(error.localizedDescription)
                
        })
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
    }
    

}
