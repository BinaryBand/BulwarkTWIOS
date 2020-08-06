//
//  SwiftEmail.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 3/4/15.
//
//

import Foundation
import UIKit
import MessageUI




@objc class SwiftEmail: UIViewController,MFMailComposeViewControllerDelegate {


    

    
    
  @objc  func sendMail() {
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject("test")
        picker.setMessageBody("test", isHTML: true)
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}




// MFMailComposeViewControllerDelegate

// 1



