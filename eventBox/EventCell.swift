//
//  EventCell.swift
//  eventBox
//
//  Created by Michael Berger on 2/15/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    
    var defaultHeight: CGFloat!
    var selectedHeight: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(self.bounds.height)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        if selected {
//            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, selectedHeight)
//        } else {
//            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, defaultHeight)
//
//        }
        
    }
    
    
    

}
