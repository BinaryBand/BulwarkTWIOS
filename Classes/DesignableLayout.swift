//
//  DesignableUIView.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 11/21/22.
//

import Foundation

@IBDesignable class DesignableUIView: UIView {
    
    
    
    
    
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var shadowRadius: CGFloat {
           get { return layer.shadowRadius }
           set { layer.shadowRadius = newValue }
       }

       @IBInspectable var shadowOpacity: CGFloat {
           get { return CGFloat(layer.shadowOpacity) }
           set { layer.shadowOpacity = Float(newValue) }
       }

       @IBInspectable var shadowOffset: CGSize {
           get { return layer.shadowOffset }
           set { layer.shadowOffset = newValue }
       }

       @IBInspectable var shadowColor: UIColor? {
           get {
               guard let cgColor = layer.shadowColor else {
                   return nil
               }
               return UIColor(cgColor: cgColor)
           }
           set { layer.shadowColor = newValue?.cgColor }
       }
    
    @IBInspectable var cornerRadius: CGFloat {
           get {
               return 6 //layer.cornerRadius
               
           }
           set {
               
                 layer.cornerRadius = 6

                 // If masksToBounds is true, subviews will be
                 // clipped to the rounded corners.
                 //layer.masksToBounds = true//(newValue > 0)
           }
    
       }
    
    @IBInspectable var maskToBounds: Bool {
        get{ return layer.masksToBounds }
        set{ layer.masksToBounds = newValue }
    }
    

}

@IBDesignable class DesignableUISwitch: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}
