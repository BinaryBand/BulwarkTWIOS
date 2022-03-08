//
//  viewServiceSnapShot.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 3/2/22.
//

import UIKit
import WebKit

class viewServiceSnapShot: UIViewController,WKNavigationDelegate,WKUIDelegate  {

    @IBOutlet var webView : WKWebView!
    var HUD: MBProgressHUD!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        webView.navigationDelegate = self
        //view = webView
        
        //webView.uiDelegate = self
        
       // webView.scrollView.isScrollEnabled = false
        

        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        let h = appDelegate.hrEmpId ?? ""
        
        HUD = MBProgressHUD(view: view)
        view.addSubview(HUD)
        HUD.hide(true)
        
        
        
        let url = URL(string: "https://servicesnapshot.bulwarkapp.com?&hrempid=" + h)!
        webView.load(URLRequest(url: url))

        // Do any additional setup after loading the view.
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            HUD.show(true)
        } else {
            HUD.hide(true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
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
