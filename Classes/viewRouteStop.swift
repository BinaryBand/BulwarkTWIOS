//
//  viewRouteStop.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 1/19/23.
//

import UIKit

class viewRouteStop: UIViewController ,WKNavigationDelegate,WKUIDelegate {

    @IBOutlet var webView : WKWebView!
    //var HUD: MBProgressHUD!
    @objc  var url:String!
    
    var paramsToPass:String!
    var appDelegate:BulwarkTWAppDelegate!
    var rs:RouteStop!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        paramsToPass = ""
        appDelegate = UIApplication.shared.delegate as? BulwarkTWAppDelegate
        


        //HUD = MBProgressHUD(view: view)
       // view.addSubview(HUD)
       // HUD.hide(true)
        
        
        
    webView.navigationDelegate = self
    //view = webView
    
    webView.uiDelegate = self
        
        
        self.title = "Account: " + rs.account
        
        
        let turl = URL(string: url)!
       webView.load(URLRequest(url: turl))
        // Do any additional setup after loading the view.
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
        
               
        if let url = navigationAction.request.url {
            
            let urlStr = url.absoluteString
            
            if urlStr.starts(with: "bulwarktw"){
                
                
                let urlparams = urlStr.components(separatedBy: "?")
                
                if urlparams.count > 2{
                    let dpage = Double(urlparams[1])
                    
                    let param = urlparams[2]
                    if dpage == 11 {
                        
                        
                        paramsToPass = param
                        performSegue(withIdentifier: "showPosting", sender: nil)
                        
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
          //  NSString *mapsurllink = [url.absoluteString stringByReplacingOccurrencesOfString:@"comgooglemaps://?q=" withString:@""];
            
          //      NSString *Mstring = @"comgooglemaps://?directionsmode=driving&daddr=";
          //  Mstring = [Mstring stringByAppendingString:mapsurllink];
            
            
            if url.scheme == "comgooglemaps"{
                
                var mapparam = url.absoluteString.replacingOccurrences(of: "comgooglemaps://?q=", with: "")
                
                let mstr = "comgooglemaps://?directionsmode=driving&daddr=" + mapparam
                
                UIApplication.shared.open(URL(string: mstr)!)
                decisionHandler(.cancel)
            }
            
            if url.scheme == "maps"{
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            }
            
            
            
            
            
        }
        
        
        decisionHandler(.allow)
              
        
        

    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
       

        decisionHandler(.allow)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        if segue.identifier == "showPosting" {
            
            

            
                let dc = segue.destination as! viewPosting
                dc.urlParams = paramsToPass
            
            dc.hrEmpId = appDelegate.hrEmpId ?? "1234"
            dc.name = appDelegate.name ?? "NOName"
            dc.office = appDelegate.office ?? "NA"
            dc.license = appDelegate.license ?? ""
            dc.odometer = appDelegate.odo ?? "-1"
            dc.vin = appDelegate.vin ?? "N"
            dc.lastObdRead = appDelegate.lastObdRead
            dc.rs = self.rs
            
            
            
        }
        
        
        
    }
   

}
