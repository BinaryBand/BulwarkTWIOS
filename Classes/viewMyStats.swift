//
//  viewMyStats.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 2/16/22.
//

import UIKit
import WebKit


class viewMyStats: UIViewController,WKNavigationDelegate,WKUIDelegate {
    
    @IBOutlet var webView : WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        webView.navigationDelegate = self
        //view = webView
        
        //webView.uiDelegate = self
        
       // webView.scrollView.isScrollEnabled = false
        
        
        
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        let h = appDelegate.hrEmpId ?? ""
        
        
        
        
        
        
        let url = URL(string: "https://fbf2.bulwarkapp.com/mgrapp2/techstatsipad.aspx?h=" + h)!
        webView.load(URLRequest(url: url))
       //webView.allowsBackForwardNavigation
       //webView.allowsBackForwardNavigationGestures = true
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
