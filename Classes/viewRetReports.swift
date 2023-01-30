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
    
    var url:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        url = "";

        

            
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
        
        url = "https://ipadapp.bulwarkapp.com/hh/retention/rptproactivedormancy.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        

 
        performSegue(withIdentifier: "showReport", sender: nil)
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadReport"), object: nil)
         //  self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func btnSearch() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        let acct = txtSearch.text ?? ""
        let newacct = acct.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        
        
        url = "https://ipadapp.bulwarkapp.com/hh/retention/rptsearch.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon + "&t=" + newacct
        
        
        
        performSegue(withIdentifier: "showReport", sender: nil)
        
        
    }
    
    @IBAction func btnPdel() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        url = "https://ipadapp.bulwarkapp.com/hh/retention/rptproactivedelinquency.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        performSegue(withIdentifier: "showReport", sender: nil)
        
        
    }
    
    @IBAction func btnDormant() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        url = "https://ipadapp.bulwarkapp.com/hh/retention/rptdormantaccounts.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        performSegue(withIdentifier: "showReport", sender: nil)
        
    }
    
    @IBAction func btnRecCan() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        url = "https://ipadapp.bulwarkapp.com/hh/retention/rptrecentcancelsipad.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        performSegue(withIdentifier: "showReport", sender: nil)
        
        
    }
    
    @IBAction func btnRecMoves() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        url = "https://ipadapp.bulwarkapp.com/hh/retention/rptrecentmoves.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        performSegue(withIdentifier: "showReport", sender: nil)
        
        
    }
    
    @IBAction func btnPool() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        url = "https://ipadapp.bulwarkapp.com/hh/retention/rptpool.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        performSegue(withIdentifier: "showReport", sender: nil)
        
        
    }
    
    @IBAction func btnCancelBuck() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        url = "https://ipadapp.bulwarkapp.com/hh/retention/rptbucketcancel.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        performSegue(withIdentifier: "showReport", sender: nil)
        
        
    }
    
    @IBAction func btnNear() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
        url = "https://ipadapp.bulwarkapp.com/hh/retention/rptpoolloc.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        performSegue(withIdentifier: "showReport", sender: nil)
        
        
    }
    
    
    @IBAction func btnGate() {
        
        
    
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        
        let h = appDelegate.hrEmpId ?? ""
        let lat = appDelegate.lat ?? ""
        let lon = appDelegate.lon ?? ""
        
       url = "https://ipadapp.bulwarkapp.com/hh/retention/rptgatecodes.aspx?hr_emp_id=" + h + "&lat=" + lat + "&lon=" + lon
        
        
        
        performSegue(withIdentifier: "showReport", sender: nil)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
        if segue.identifier == "showReport" {
            
            
            
            
            let destinationController = segue.destination as! viewReports
            destinationController.url = url
            //destinationController.hrEmpId = hrempid
            
           
            
            
        }
    }
}
