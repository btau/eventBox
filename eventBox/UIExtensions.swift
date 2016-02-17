//
//  UIExtensions.swift
//  eventBox
//
//  Created by Michael Berger on 2/16/16.
//  Copyright © 2016 Brett Tau. All rights reserved.
//

import UIKit

@IBDesignable extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.CGColor
        }
    }
    
}

@IBDesignable extension UITextField {
    
    @IBInspectable var padding: CGFloat {
        get {
            return 0
        }
        set {
            let paddingView = UIView(frame: CGRectMake(0,0,newValue,20))
            
            leftView     = paddingView
            leftViewMode = .Always
            
            rightView     = paddingView
            rightViewMode = .Always
        }
    }
    
}