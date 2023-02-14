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
    var refController:UIRefreshControl = UIRefreshControl()
    
    //var HUD: MBProgressHUD!
    
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

        
        webView.navigationDelegate = self
        //view = webView
        
        //webView.uiDelegate = self
        
       // webView.scrollView.isScrollEnabled = false
        
        //HUD = MBProgressHUD(view: view)
        //view.addSubview(HUD)
        //HUD.hide(true)
        

        
        refController.bounds = CGRect.init(x: 0.0, y: 50.0, width: refController.bounds.size.width, height: refController.bounds.size.height)
        refController.addTarget(self, action: #selector(self.webviewRefresh(refresh:)), for: .valueChanged)
        webView.scrollView.addSubview(refController)
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        let h = appDelegate.hrEmpId ?? ""
        let urlstr = "https://twreportcore.bulwarkapp.com/dashboardsharedreports/salesstats?ipad=yes&h=" + h
        //let url = URL(string: "https://fbf2.bulwarkapp.com/mgrapp2/salesstats.aspx?h=" + h)!
        
        let url = URL(string: urlstr)!
        webView.load(URLRequest(url: url))

    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
        
        
    }
    
    @objc func webviewRefresh(refresh:UIRefreshControl){
        refController.endRefreshing()
        webView.reload()
    }
    
    
    func showActivityIndicator(show: Bool) {
        if show {
            self.view.makeToastActivity(.center)
            //HUD.show(true)
        } else {
            self.view.hideToastActivity()
            //HUD.hide(true)
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        
        if let url = navigationAction.request.url {
            
            let urlStr = url.absoluteString
            
            if urlStr.starts(with: "bulwarktwsales"){
                
                
                let urlparams = urlStr.components(separatedBy: "?")
                
                if urlparams.count > 2{
                    let dpage = Double(urlparams[1])
                    
                    //let param = urlparams[2]
                    
                    
                    
                    if dpage == 3 {
                        performSegue(withIdentifier: "showAKInfo", sender: nil)
                        
                    }
                    
                    
                }
                
            
            
            // guard
            //     let component = URLComponents(string: url.absoluteString),
            // let account = component.queryItems?.first(where: { $0.name == "accountnumber" })?.value,
            // let routestopid = component.queryItems?.first(where: { $0.name == "routestopid" })?.value,
            // let hrempid = component.queryItems?.first(where: { $0.name == "hr_emp_id" })?.value
            // let servicetypecode = component.queryItems?.first(where: { $0.name == "hr_emp_id" })?.value
            
            // else {
            //        return
            //    }
            
            
            
            decisionHandler(.cancel)
            return
        }
        
    }
            
        
        
        
        decisionHandler(.allow)
              
        
        

    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
       

        decisionHandler(.allow)
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
