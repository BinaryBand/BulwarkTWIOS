//
//  ReportProblemEmailViewController.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 3/5/15.
//
//

import UIKit
import MessageUI


 @objc class ReportProblemEmailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var emlSubject:String = ""
    var emlSubject1:String = ""
   var attach1:String = ""
    var attach2:String = ""
    var attach3:String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        
        let att1 =  Data(contentsOfFile:attach1, options: .mappedIfSafe)
        let att2 =  Data(contentsOfFile:attach2, options: .mappedIfSafe)
        let att3 =  Data(contentsOfFile:attach3, options: .mappedIfSafe)
        
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject(emlSubject)
        picker.setToRecipients(["titans@bulwarkpest.com"])
        picker.setMessageBody("Please type a description of the problem", isHTML: true)
        picker.addAttachmentData(att1! as Data, mimeType: "application/zip", fileName: "Services.zip")
        picker.addAttachmentData(att2! as Data, mimeType: "application/zip", fileName: "GPS.zip")
        picker.addAttachmentData(att3! as Data, mimeType: "application/zip", fileName: "Settings.txt")
        present(picker, animated: true, completion: nil)
*/
        // Do any additional setup after loading the view.
    }
    

    
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
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
