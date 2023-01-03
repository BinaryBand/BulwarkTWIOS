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
    var refController:UIRefreshControl = UIRefreshControl()
    
   // var HUD: MBProgressHUD!
    
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
        
        
        
        

    }
    

    override func viewWillAppear(_ animated: Bool) {
        
      
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        let h = appDelegate.hrEmpId ?? ""
        
   

        
        let url = URL(string: "https://dashboard.bulwarkapp.com/mgrapp2/techstatsipad.aspx?h=" + h)!
        webView.load(URLRequest(url: url))
        
        
    }
    
    @objc func webviewRefresh(refresh:UIRefreshControl){
        refController.endRefreshing()
        webView.reload()
    }
    
    
    func showActivityIndicator(show: Bool) {
        if show {
            //HUD.show(true)
            self.view.makeToastActivity(.center)
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}
