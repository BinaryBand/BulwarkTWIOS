//
//  viewMySales.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 2/16/22.
//

import UIKit
import WebKit

class viewMySales: UIViewController,WKNavigationDelegate,WKUIDelegate {

    @IBOutlet var webView : WKWebView!
    
    var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        webView.navigationDelegate = self
        //view = webView
        
        //webView.uiDelegate = self
        
       // webView.scrollView.isScrollEnabled = false
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        let h = appDelegate.hrEmpId ?? ""
        
        
        
        
        
        
        let url = URL(string: "https://fbf2.bulwarkapp.com/mgrapp2/salesstats.aspx?h=" + h)!
        webView.load(URLRequest(url: url))

        // Do any additional setup after loading the view.
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
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
