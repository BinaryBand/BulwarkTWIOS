//
//  viewRetReports.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 3/11/22.
//

import UIKit
import WebKit

class viewRetReports: UIViewController,WKNavigationDelegate,WKUIDelegate  {
    
    //@IBOutlet var webView : WKWebView!
   // var HUD: MBProgressHUD!
    //var mapDate:String?
    @IBOutlet var txtSearch : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 15, *){
          //  print("Create the collection view!")
        }else{
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = .clear
        }

        

            
        //webView.navigationDelegate = self
        //view = webView
        
        //webView.uiDelegate = self
        
       // webView.scrollView.isScrollEnabled = false
        

        
        
        //appDelegate.viewSched = self
       
        
        
        
     

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func btnPdorm() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        appDelegate.reportUrl = "https://ipadapp.bulwarkapp.com/hh/retention/rptproactivedormancy.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadReport"), object: nil)
           self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func btnSearch() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        let acct = txtSearch.text ?? ""
        let newacct = acct.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        
        
        appDelegate.reportUrl = "https://ipadapp.bulwarkapp.com/hh/retention/rptsearch.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon + "&t=" + newacct
        
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadReport"), object: nil)
           self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnPdel() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        appDelegate.reportUrl = "https://ipadapp.bulwarkapp.com/hh/retention/rptproactivedelinquency.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadReport"), object: nil)
           self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnDormant() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        appDelegate.reportUrl = "https://ipadapp.bulwarkapp.com/hh/retention/rptdormantaccounts.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadReport"), object: nil)
           self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnRecCan() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        appDelegate.reportUrl = "https://ipadapp.bulwarkapp.com/hh/retention/rptrecentcancelsipad.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadReport"), object: nil)
           self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnRecMoves() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        appDelegate.reportUrl = "https://ipadapp.bulwarkapp.com/hh/retention/rptrecentmoves.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadReport"), object: nil)
           self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnPool() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        appDelegate.reportUrl = "https://ipadapp.bulwarkapp.com/hh/retention/rptpool.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadReport"), object: nil)
           self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnCancelBuck() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        appDelegate.reportUrl = "https://ipadapp.bulwarkapp.com/hh/retention/rptbucketcancel.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadReport"), object: nil)
           self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnNear() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        appDelegate.reportUrl = "https://ipadapp.bulwarkapp.com/hh/retention/rptpoolloc.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadReport"), object: nil)
           self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func btnGate() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        appDelegate.reportUrl = "https://ipadapp.bulwarkapp.com/hh/retention/rptgatecodes.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadReport"), object: nil)
           self.dismiss(animated: true, completion: nil)
        
        
    }
    
    

    

}
