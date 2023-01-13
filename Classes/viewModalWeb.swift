//
//  viewModalWeb.swift
//  BulwarkTW
//
//  Created by Terry Whipple on 9/28/22.
//

import UIKit
import WebKit

class viewModalWeb: UIViewController,WKNavigationDelegate,WKUIDelegate {

    @IBOutlet var webView : WKWebView!
    //var HUD: MBProgressHUD!
    @objc  var url:String!
    
    @objc var hrEmpId:String!
    
     var useCookie:Bool!
    
    
    
    var refController:UIRefreshControl = UIRefreshControl()


    override func viewDidLoad()  {
        
        super.viewDidLoad()
        
        
        //HUD = MBProgressHUD(view: view)
        //view.addSubview(HUD)
        //HUD.hide(true)
        
        
    webView.navigationDelegate = self
    //view = webView
    
    webView.uiDelegate = self
        
        
        
        
        
        if let hascookie = useCookie{
            
            if hascookie{
                
                
                
                Task {
                    
                    do {
                        
                        let cookie = try await JsonFetcher.postAuthCookieJson(hrEmpId: hrEmpId)
                        await webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
                        // Update collection view content
                       
                        
                        //HUD.hide(true)
                   
                        
                        let turl = URL(string: url)!
                        
 
                       webView.load(URLRequest(url: turl))
                        
                        
                    } catch {
                        print("Request failed with error: \(error)")
                    }
                    
                }
                
                
                
            }else{
                
                let turl = URL(string: url)!
            
                
               webView.load(URLRequest(url: turl))
                
                
            }
            
            
            
        }else{
            let turl = URL(string: url)!
            

           webView.load(URLRequest(url: turl))
        }
        
        
       
        // Do any additional setup after loading the view.
        
        
        refController.bounds = CGRect.init(x: 0.0, y: 50.0, width: refController.bounds.size.width, height: refController.bounds.size.height)
        refController.addTarget(self, action: #selector(self.webviewRefresh(refresh:)), for: .valueChanged)
        webView.scrollView.addSubview(refController)
        
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

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

        
        
        if(message.starts(with: "CloseModal")){
            
            completionHandler()
            self.dismissThis()
            
        }else{
            
            
            
        
        
        
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let title = NSLocalizedString("OK", comment: "OK Button")
            let ok = UIAlertAction(title: title, style: .default) { (action: UIAlertAction) -> Void in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            present(alert, animated: true)
        
            completionHandler()
        
        }
        
        }

    func dismissThis(){
        self.dismiss(animated: true, completion: nil)
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
            
            let strprt = url?.absoluteString
            let arr = strprt?.split(separator: "?")
            let spage = arr?[1] ?? "0"
            let dpage = Int(spage) ?? 0
            
            if(dpage==32){
               
                
                decisionHandler(.cancel)
                self.dismissThis()
                
            }else{
                
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            }

           
        }else{
            
            decisionHandler(.allow)
            
        }
        
        
        
        
        
        
        
                
              

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
