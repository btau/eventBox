//
//  CreateEventViewController.swift
//  eventBox
//
//  Created by Michael Berger on 2/17/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDateTextField: UITextField!
    @IBOutlet weak var eventTimeTextField: UITextField!
    
    var textFields: [UITextField]!
    
    let animationSpeed = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [eventNameTextField,eventDateTextField,eventTimeTextField]

    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        clearTextfields(Except: textField)
        
        UIView.animateWithDuration(animationSpeed) { () -> Void in
            textField.backgroundColor = .whiteColor()
        }
        
        
        textField.borderWidth = 3
        let width:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        width.fromValue = 0
        width.toValue = 3
        width.duration = animationSpeed
        width.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
       textField.layer.addAnimation(width, forKey: "borderWidth")
        
        if textField.tag == 1 {
            return true
        }
        return false
    }
    
    func clearTextfields(Except selectedTextfield: UITextField) {
     
        for textField in textFields {
            guard textField.tag != selectedTextfield.tag else {
                continue
            }
            
            textField.resignFirstResponder()
            
            let color = UIColor(red: 240/255, green: 249/255, blue: 255/255, alpha: 1.0)
            UIView.animateWithDuration(animationSpeed) { () -> Void in
                textField.backgroundColor = color
            }
            
            let currentWidth = textField.borderWidth
            textField.borderWidth = 0
            let width:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
            width.fromValue = currentWidth
            width.toValue = 0
            width.duration = animationSpeed
            width.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            textField.layer.addAnimation(width, forKey: "borderWidth")
            
        }
        
        
        
    }
    

    

}
