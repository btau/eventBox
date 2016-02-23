//
//  EventLandingViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/22/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

protocol dismissEventDelegate {
    
}

class EventLandingViewController: UIViewController {

    @IBOutlet weak var eventImageView: UIImageView!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        event = NetworkManager.sharedManager.selectedEvent
        
        eventImageView.image = UIImage(named: event.imageName)
        
    }


    @IBAction func onExitTapped(sender: AnyObject) {
    }


}
