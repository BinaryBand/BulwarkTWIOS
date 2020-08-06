//
//  TermiteEmail.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 3/5/15.
//
//

import UIKit
import MobileCoreServices
import MessageUI


class TermiteEmail:  UIViewController, MFMailComposeViewControllerDelegate {
    
    var emlBody:String = ""
    var emlAttach:Data = Data()
    var Account:String = ""
    var tousr:String = ""
    var emlSubject:String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject(emlSubject)
        picker.setToRecipients([tousr])
        picker.setMessageBody(emlBody, isHTML: true)
        picker.addAttachmentData(emlAttach as Data, mimeType: "image/png", fileName: "image.png")

        present(picker, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mailComposeController(_ didFinishWithcontroller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: closed)
        
        //self.dismissViewControllerAnimated(false, completion: nil)
        // self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    func closed(){
        //self.dismissViewControllerAnimated(false, completion: nil)
        //self.navigationController?.popViewControllerAnimated(true)
        //self.removeFromParentViewController()
        self.view.removeFromSuperview()
        
        
    }
    
}
