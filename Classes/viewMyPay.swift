//
//  viewMyPay.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 3/10/22.
//

import UIKit
import WebKit

class viewMyPay: UIViewController,WKNavigationDelegate,WKUIDelegate  {
    
    @IBOutlet var webView : WKWebView!
    //var HUD: MBProgressHUD!
     var rurl:String?
    
    
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
        
        webView.uiDelegate = self
        
       // webView.scrollView.isScrollEnabled = false
        

        
        let appDelegate = UIApplication.shared.delegate as! BulwarkTWAppDelegate
        let h = appDelegate.hrEmpId ?? ""
        
        //HUD = MBProgressHUD(view: view)
        //view.addSubview(HUD)
        //HUD.hide(true)
        
        
        let urlStr = "https://kpwebapi.bulwarkapp.com/payrollreports/employee?apikey=aeb9ce4f-f8af-4ced-a4b3-683b6d29864d&hrempid=" + h + "&viewedby=" + h
        
        let url = URL(string: urlStr)!
        webView.load(URLRequest(url: url))
        
        
        
        
        

        

        
        

        // Do any additional setup after loading the view.
    }
    
   public func setrurl(routeurl:String){
        rurl = routeurl;
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
