//
//  viewRoutes.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 3/10/22.
//

import UIKit
import WebKit

 class viewRoutes: UIViewController,WKNavigationDelegate,WKUIDelegate  {
    
    @IBOutlet var webView : WKWebView!
    var HUD: MBProgressHUD!
    var mapDate:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        webView.navigationDelegate = self
        //view = webView
        
        webView.uiDelegate = self
        
       // webView.scrollView.isScrollEnabled = false
        

        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        appDelegate.viewSched = self
       
        HUD = MBProgressHUD(view: view)
        view.addSubview(HUD)
        HUD.hide(true)
        
        
        
        getSchedule()
        
        
        
     

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

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let title = NSLocalizedString("OK", comment: "OK Button")
            let ok = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true)
            completionHandler()
        
        }

   
    
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

            let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)

            alert.addTextField { (textField) in
                textField.text = defaultText
            }

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                if let text = alert.textFields?.first?.text {
                    completionHandler(text)
                } else {
                    completionHandler(defaultText)
                }

            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in

                completionHandler(nil)

            }))

             
        
        present(alert, animated: true)
        
    }

    
    

    
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {

            let alertController = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                completionHandler(true)
            }))

            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                completionHandler(false)
            }))


            present(alertController, animated: true)
        }
    
    
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
                
        
        let url = navigationAction.request.url;
        
        if(url?.scheme == "bulwarktw"){
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        if(url?.scheme == "bulwarktwmap"){
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        
        
        decisionHandler(.allow)
        

    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
       

        decisionHandler(.allow)
    }
    
    
 @objc func openMap(mpDate:String){
        
        mapDate = mpDate
        
        
        self.performSegue(withIdentifier: "OpenMapsSegue", sender: self)
        
    }
    
    
  @objc public func getSchedule(){
        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
       
        let h = appDelegate.hrEmpId ?? ""
        
        
        
        let url = URL(string: "https://fbf2.bulwarkapp.com/techapp/myroutes/routes.aspx?hr_emp_id=" + h)!
        webView.load(URLRequest(url: url))
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "OpenMapsSegue"){
            
                let displayVC = segue.destination as! viewRouteMap
            displayVC.rurl = mapDate
        }
    }
    

}
